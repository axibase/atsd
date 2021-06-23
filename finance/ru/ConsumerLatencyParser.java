import java.io.*;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.TimeUnit;
import java.util.function.IntPredicate;
import java.util.function.Supplier;
import java.util.function.ToDoubleFunction;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.util.zip.GZIPInputStream;

import org.apache.commons.math3.stat.descriptive.rank.Max;
import org.apache.commons.math3.stat.descriptive.rank.Min;
import org.apache.commons.math3.stat.descriptive.rank.Percentile;
import org.apache.commons.math3.util.FastMath;
import org.apache.commons.math3.util.Pair;
import org.apache.commons.math3.util.ResizableDoubleArray;

public class ConsumerLatencyParser {
	private static final int TYPE_DERIVATIVES = 1;
	private static final int TYPE_INDEX = 2;
	private static final int TYPE_FOND = 3;
	private static final int TYPE_FX = 4;
	private static final DateTimeFormatter DTF_FULL = DateTimeFormatter.ofPattern("yyMMddHHmmssSSSSSS");
	private static final long NANOS_IN_DAY = TimeUnit.DAYS.toNanos(1);
	private static final long NANOS_IN_MINUTE = TimeUnit.MINUTES.toNanos(1);
	private static final long NANOS_IN_SECOND = TimeUnit.SECONDS.toNanos(1);
	private static final long NANOS_IN_MICROS = TimeUnit.MICROSECONDS.toNanos(1);
	private static final ZoneId UTC = ZoneId.of("UTC");
	private static final Map<String, ToDoubleFunction<ResizableDoubleArray>> STATISTICS_CALCULATORS = prepareStatisticsCalculators();

	private static Map<String, ToDoubleFunction<ResizableDoubleArray>> prepareStatisticsCalculators() {
		final Map<String, ToDoubleFunction<ResizableDoubleArray>> calculators = new LinkedHashMap<>();
		calculators.put("count", ResizableDoubleArray::getNumElements);
		calculators.put("min", array -> array.compute(new Min()));
		for (String rank : "0.1,1,5,10,25,50,75,90,95,99,99.9".split(",")) {
			double quantile = Double.parseDouble(rank);
			calculators.put("p" + rank, array -> array.compute(new Percentile(quantile)));
		}
		calculators.put("max", array -> array.compute(new Max()));
		return calculators;
	}

	private final ResizableDoubleArray sendingToProcess = new ResizableDoubleArray(100_000);
	private final ResizableDoubleArray lastUpdateToProcess = new ResizableDoubleArray(100_000);
	private final ResizableDoubleArray receiveToProcess = new ResizableDoubleArray(100_000);
	private final ResizableDoubleArray entryToProcess = new ResizableDoubleArray(100_000);
	private final ResizableDoubleArray lastUpdateToSending = new ResizableDoubleArray(100_000);
	private final ResizableDoubleArray sendingToReceive = new ResizableDoubleArray(100_000);
	private final ResizableDoubleArray entryToSending = new ResizableDoubleArray(100_000);
	private final ResizableByteArray actions = new ResizableByteArray(100_000);
	private final ResizableByteArray types = new ResizableByteArray(100_000);
	private SetsContainer sets = new SetsContainer();

	public ResizableDoubleArray getTimestamps(String from, String to) {
		if ("process".equals(to)) {
			if ("sending".equals(from)) {
				return sendingToProcess;
			} else if ("lastupdate".equals(from)) {
				return lastUpdateToProcess;
			} else if ("receive".equals(from)) {
				return receiveToProcess;
			} else if ("entry".equals(from)) {
				return entryToProcess;
			}
		} else if ("sending".equals(to)) {
			if ("lastupdate".equals(from)) {
				return lastUpdateToSending;
			} else if ("entry".equals(from)) {
				return entryToSending;
			}
		} else if ("sending".equals(from) && "receive".equals(to)) {
			return sendingToReceive;
		}
		throw new IllegalArgumentException("Latency from " + from + " to " + to + " not collected");
	}

	private final int mode;
	private final String filterInstrument;
	private final int moexConsumerType;
	private final File f;
	private final LocalDate localDate;
	private final String localDateStr;
	private final long dateUtcOffsetNanos;

	public ConsumerLatencyParser(String date, int mode, String filterInstrument, int moexConsumerType, File file) {
		this.mode = mode;
		this.filterInstrument = filterInstrument;
		this.moexConsumerType = moexConsumerType;
		this.localDate = LocalDate.parse(date, DateTimeFormatter.ofPattern("dd-MM-yyyy"));
		this.f = file;
		this.dateUtcOffsetNanos = localDate.atStartOfDay(UTC).toEpochSecond() * NANOS_IN_SECOND;
		this.localDateStr = DateTimeFormatter.ofPattern("yyMMdd").format(this.localDate);
	}

	public static void main(String[] args) throws Exception {
		String directory = args[0];
		String filePrefix = args[1];
		String date = args[2];
		String csvPath = args.length > 3 ? args[3] : null;

		final long st = System.currentTimeMillis();
		System.out.println("Start " + directory + " : " + filePrefix + " : " + date + " : " + csvPath);

		//24-02-2021
		if (date.equals("-")) {
			String prevMskDate = Instant.now().atZone(ZoneId.of("Europe/Moscow")).minusDays(1).format(DateTimeFormatter.ofPattern("dd-MM-yyyy"));
			System.out.println("Use previous date " + prevMskDate + " in Europe/Moscow timezone");
			date = prevMskDate;
		}

		int mode = args.length > 4 ? Integer.parseInt(args[4]) : 0;
		if (mode <= 0) {
			System.out.println("mode: read, parse, calculate");
		} else if (mode == 1) {
			System.out.println("mode: read, parse");
		} else if (mode >= 2) {
			System.out.println("mode: read");
		}

		String filterInstrument = args.length > 5 ? args[5] : null; //"1642954", "GAZP"

		if (!new File(directory).isDirectory()) {
			throw new Exception("Invalid directory: " + directory);
		}

		String namePrefix = filePrefix + "." + date + ".";
		File[] files = new File(directory).listFiles(f -> f.getName().startsWith(namePrefix) && f.getName().endsWith(".log.gz") && f.length()>0);

		if (files == null) {
			throw new Exception("No files matched: " + directory + "/" + filePrefix + "." + date + ".*.log.gz");
		}

		files = Arrays.stream(files)
				.map(f -> {
					String[] parts = f.getName().split("\\.");
					return new AbstractMap.SimpleEntry<>(f, Integer.parseInt(parts[parts.length-3]));
				})
				.sorted(Map.Entry.comparingByValue())
				.map(AbstractMap.SimpleEntry::getKey)
				.toArray(File[]::new);

		System.out.println("Files found: " + files.length + " in " + directory + " for " + date);

		String[] dirs = new File(directory).getAbsolutePath().split("/");
		int indexOfLogs = Arrays.asList(dirs).lastIndexOf("logs");
		if (indexOfLogs < 1) {
			throw new IllegalArgumentException("Unexpected directory: " + directory);
		}
		String loggerName = dirs[indexOfLogs - 1];
		System.out.println("consumer/logger name: " + loggerName);

		final int consumerType;
		if (loggerName.contains("hc_jdk") || loggerName.contains("fond")) {
			consumerType = TYPE_FOND;
		} else if (loggerName.contains("fx")) {
			consumerType = TYPE_FX;
		} else if (loggerName.contains("futures") || loggerName.contains("spectra")) {
			consumerType = filePrefix.contains("index") ? TYPE_INDEX : TYPE_DERIVATIVES;
		} else {
			consumerType = 0;
			System.err.println("Could not detect consumer type");
		}
		int ioParallelism = 1;
		try {
			ioParallelism = Integer.parseInt(System.getProperty("ioThreads", "1"));
		} catch (Exception e) {
			System.err.println("Could not parse ioThreads: number required. Single thread will be used");
		}
		int calcParallelism = 1;
		try {
			calcParallelism = Integer.parseInt(System.getProperty("calcThreads", "1"));
		} catch (Exception e) {
			System.err.println("Could not parse calcThreads: number required. Single thread will be used");
		}

		final String effectiveDate = date;
		final ConsumerLatencyParser parsed = merge(parallelize(Arrays.stream(files)
				.map(file -> new ConsumerLatencyParser(effectiveDate, mode, filterInstrument, consumerType, file))
				.map(ConsumerLatencyParser::parse), ioParallelism)
				.toArray(new ConsumerLatencyParser[0]));

		if (mode <= 0) {
			final long beforeCalculations = System.currentTimeMillis();
			System.out.println("Spent on reading: " + (beforeCalculations - st) + " ms");
			writeCsvSummary(date, loggerName, filePrefix, csvPath, parsed, calcParallelism);
			System.out.println("Spent on calculations: " + (System.currentTimeMillis() - beforeCalculations) + " ms");
		} else {
			System.out.println("Skip writing to file");
		}

		System.out.println("Completed");
		System.out.println("Elapsed: " + (System.currentTimeMillis() - st) + " ms");
	}

	private static ConsumerLatencyParser merge(ConsumerLatencyParser[] tasks) {
		final ConsumerLatencyParser result = tasks[0];
		final int length = tasks.length;
		if (length == 1) {
			return result;
		}
		final int totalCount = Arrays.stream(tasks).mapToInt(d -> d.actions.numElements).sum();
		move(Arrays.stream(tasks).skip(1).map(t -> t.sendingToProcess), result.sendingToProcess, totalCount);
		move(Arrays.stream(tasks).skip(1).map(t -> t.lastUpdateToProcess), result.lastUpdateToProcess, totalCount);
		move(Arrays.stream(tasks).skip(1).map(t -> t.receiveToProcess), result.receiveToProcess, totalCount);
		move(Arrays.stream(tasks).skip(1).map(t -> t.entryToProcess), result.entryToProcess, totalCount);
		move(Arrays.stream(tasks).skip(1).map(t -> t.lastUpdateToSending), result.lastUpdateToSending, totalCount);
		move(Arrays.stream(tasks).skip(1).map(t -> t.sendingToReceive), result.sendingToReceive, totalCount);
		move(Arrays.stream(tasks).skip(1).map(t -> t.entryToSending), result.entryToSending, totalCount);
		move(Arrays.stream(tasks).skip(1).map(t -> t.actions), result.actions, totalCount);
		move(Arrays.stream(tasks).skip(1).map(t -> t.types), result.types, totalCount);
		result.sets = SetsContainer.merged(Arrays.stream(tasks).map(d -> d.sets).toArray(SetsContainer[]::new));
		return result;
	}

	private static void move(Stream<ResizableByteArray> fromArr, ResizableByteArray to, int totalCount){
		int index = to.numElements;
		to.internalArray = Arrays.copyOf(to.internalArray, totalCount);
		final byte[] internalValuesTarget = to.internalArray;
		final Iterator<ResizableByteArray> iterator = fromArr.iterator();
		while (iterator.hasNext()) {
			ResizableByteArray from = iterator.next();
			final byte[] internalValuesSrc = from.internalArray;
			final int size = from.numElements;
			System.arraycopy(internalValuesSrc, 0, internalValuesTarget, index, size);
			index += size;
			from.numElements = 0;
			from.contract();
		}
	}

	private static void move(Stream<ResizableDoubleArray> fromArr, ResizableDoubleArray to, int totalCount) {
		int index = to.getNumElements();
		to.setNumElements(totalCount);
		final double[] internalValuesTarget = to.getInternalValues();
		final Iterator<ResizableDoubleArray> iterator = fromArr.iterator();
		while (iterator.hasNext()) {
			ResizableDoubleArray from = iterator.next();
			final double[] internalValuesSrc = from.getInternalValues();
			final int size = from.getNumElements();
			System.arraycopy(internalValuesSrc, 0, internalValuesTarget, index, size);
			index += size;
			from.setNumElements(0);
			from.contract();
		}
	}

	private static long parseTimeOffsetNanos(String hhMMssSSSSSS, int startIdx) {
		int hour = (hhMMssSSSSSS.charAt(startIdx) - '0') * 10 + (hhMMssSSSSSS.charAt(startIdx + 1) - '0');
		int minute = (hhMMssSSSSSS.charAt(startIdx + 2) - '0') * 10 + (hhMMssSSSSSS.charAt(startIdx + 3) - '0');
		int acc = 0;
		final int endIdx = startIdx + 12;
		for (int i = startIdx + 4; i < endIdx; i++) {
			acc = acc * 10 + hhMMssSSSSSS.charAt(i) - '0';
		}
		return (minute * 60L + hour * 3600L) * NANOS_IN_SECOND + acc * NANOS_IN_MICROS;
	}

	private long parseYYMMddHHMMssSSSSSS(String yyMMddHHMMssSSSSSS) {
		if (localDateStr.regionMatches(0, yyMMddHHMMssSSSSSS, 0, 6)) {
			return dateUtcOffsetNanos + parseTimeOffsetNanos(yyMMddHHMMssSSSSSS, 6);
		} else {
			final ZonedDateTime zonedDateTime = LocalDateTime.parse(yyMMddHHMMssSSSSSS, DTF_FULL).atZone(UTC);
			final Instant instant = zonedDateTime.toInstant();
			return instant.getEpochSecond() * NANOS_IN_SECOND + instant.getNano();
		}
	}

	private long parseHHMMssSSSSSS(String hhMMssSSSSSS) {
		return dateUtcOffsetNanos + parseTimeOffsetNanos(hhMMssSSSSSS, 0);
	}

	public ConsumerLatencyParser parse() {
		System.out.println("== processing file " + f.getAbsolutePath() + " : " + f.length() + " ==");

		//4*60 as of March 1, 2020 for futures and fx
		int earlyStartMinute = localDate.isBefore(LocalDate.of(2021, Month.MARCH, 1)) ? 7*60 : 4*60;
		boolean lastUpdateTimeExists = true;
		List<String> header = null;
		int indexMsqSeqNum = -1;
		int indexReceiveTime = -1;
		int indexProcessTime = -1;
		int indexSendingTime = -1;
		int indexLastUpdateTime = -1;
		int indexMDUpdateAction = -1;
		int indexMDEntryType = -1;
		int indexSymbol = -1;
		int indexSecurityID = -1;
		int indexRptSeq = -1;
		int indexMDEntryDate = -1;
		int indexMDEntryTime = -1;
		int indexTradingSessionID = -1;

		try (BufferedReader br = new BufferedReader(new InputStreamReader(new GZIPInputStream(new FileInputStream(f))))) {

			long startTime = System.currentTimeMillis();
			long lastLogTime = System.currentTimeMillis();
			long lastLogCount = 0;
			int lineCount = 0;

			String line = br.readLine();
			do {

				lineCount++;

				if (System.currentTimeMillis() - lastLogTime > 10000) {
					double msgPerSec = ((lineCount - lastLogCount) / (System.currentTimeMillis() - lastLogTime)) * 1000L;
					System.out.println("processing line " + lineCount + " : " + line + " : msg/sec: " + String.format("%.0f", msgPerSec));
					lastLogTime = System.currentTimeMillis();
					lastLogCount = lineCount;
				}

				if (header == null) {
					String[] sp = line.split(",", -1);
					header = Arrays.asList(sp);
					indexMsqSeqNum = header.indexOf("MsgSeqNum");
					indexReceiveTime = header.indexOf("ReceiveTime");
					indexProcessTime = header.indexOf("ProcessTime");
					indexSendingTime = header.indexOf("SendingTime");
					indexLastUpdateTime = header.indexOf("LastUpdateTime");
					indexMDUpdateAction = header.indexOf("MDUpdateAction");
					indexMDEntryType = header.indexOf("MDEntryType");
					indexSymbol = header.indexOf("Symbol");
					indexSecurityID = header.indexOf("SecurityID");
					indexRptSeq = header.indexOf("RptSeq");
					indexMDEntryDate = header.indexOf("MDEntryDate");
					indexMDEntryTime = header.indexOf("MDEntryTime");
					indexTradingSessionID = header.indexOf("TradingSessionID");
					if (indexLastUpdateTime < 0) {
						lastUpdateTimeExists = false;
					}
					continue;
				}

				if (mode >= 2) {
					//only read
					continue;
				}

				String[] sp = line.split(",", -1);
				if (sp.length != header.size()) {
					System.err.println("Mismatch in columns: " + header.size() + " : " + sp.length + " : " + line);
					continue;
				}

				long rptSeq = sp[indexRptSeq].isEmpty() ? -1 : Long.parseLong(sp[indexRptSeq]);
				if (rptSeq < 0) {
					// J
					continue;
				}

				if (sp[indexMDUpdateAction].length() != 1) {
					System.err.println("Invalid MDUpdateAction: " + line);
					continue;
				}

				if (filterInstrument != null) {
					String symbol = sp[indexSymbol];
					if (indexTradingSessionID >= 0) {
						String tradingSessionID = sp[indexTradingSessionID];
						if (symbol.equals(filterInstrument) && tradingSessionID.equals("TQBR")) {

						} else if (symbol.equals(filterInstrument) && tradingSessionID.equals("CETS")) {

						} else {
							continue;
						}
					} else {
						String securityID = sp[indexSecurityID];
						if (securityID.equals(filterInstrument)) {

						} else {
							continue;
						}
					}
				}

				long sendingTime = getSendingTime(sp, indexSendingTime);
				int minutes_of_day = (int)((sendingTime % NANOS_IN_DAY) / NANOS_IN_MINUTE);

				if (moexConsumerType == TYPE_DERIVATIVES) {
					if (minutes_of_day < earlyStartMinute || minutes_of_day >= 11 * 60 && minutes_of_day < 11 * 60 + 5 || minutes_of_day >= 15 * 60 + 45 && minutes_of_day < 16 * 60 || minutes_of_day >= 20 * 60 + 50) {
						continue;
					}
				} else if (moexConsumerType == TYPE_INDEX && indexSymbol >= 0) {
					if (minutes_of_day < 7 * 60 || minutes_of_day >= 20 * 60 + 50 || minutes_of_day >= 15 * 60 + 40 && minutes_of_day < 16 * 60) {
						continue;
					}
					String symbol = sp[indexSymbol];
					if (!symbol.isEmpty()) {
						if (symbol.contains("FIX") || symbol.contains("RVI")) {
							continue;
						}
					}
					if (indexMDEntryTime > 0) {
						String iet = sp[indexMDEntryTime];
						if (iet.equals("83000000000000") || iet.equals("93000000000000") || iet.equals("154000000000000") || iet.equals("155000000000000") || iet.equals("160000000000000")) {
							continue;
						}
					}
				} else if (moexConsumerType == TYPE_FOND) {
					//if (minutes_of_day < 7*60 || minutes_of_day >= 15*60+40 && minutes_of_day < 16*60+5 || minutes_of_day >= 20*60+50) {
					if (minutes_of_day < 7 * 60 || minutes_of_day >= 20 * 60 + 50) {
						continue;
					}
				} else if (moexConsumerType == TYPE_FX) {
					if (minutes_of_day < earlyStartMinute || minutes_of_day >= 20 * 60 + 50) {
						continue;
					}
				}

				final long processTime = getTimeFromStandardFormat(sp, indexProcessTime);
				final long receiveTime = getTimeFromStandardFormat(sp, indexReceiveTime);
				final long entryTime = getEntryTime(sp, indexMDEntryDate, indexMDEntryTime);
				final long lastUpdateTime = getTimeFromStandardFormat(sp, indexLastUpdateTime);

				if (mode >= 1) {
					//only read and parse
					continue;
				}

				addLatency(sendingToProcess, sendingTime, processTime);
				addLatency(receiveToProcess, receiveTime, processTime);
				addLatency(entryToProcess, entryTime, processTime);
				addLatency(sendingToReceive, sendingTime, receiveTime);
				addLatency(entryToSending, entryTime, sendingTime);
				if (lastUpdateTimeExists) {
					addLatency(lastUpdateToProcess, lastUpdateTime, processTime);
					addLatency(lastUpdateToSending, lastUpdateTime, sendingTime);
				}
				byte entryType = toByte(sp[indexMDEntryType], "MDEntryType");
				int updateActionValue = toByte(sp[indexMDUpdateAction], "MDUpdateAction") - '0';
				actions.add((byte)updateActionValue);
				sets.uniqueActions.add(updateActionValue);
				types.add(entryType);
				sets.uniqueTypes.add(entryType);
				sets.uniqueActionTypeCombinations.add(entryType + 128 * updateActionValue);

				/*
				if (entryTime != null) {
					long interval_micros = ChronoUnit.MICROS.between(entryTime, sendingTime);
					if (interval_micros > 100_000L || minutes_of_day >= (15*60+44) && minutes_of_day < 16*60+6 || minutes_of_day < 07*60+1) {
						System.out.println("SLOW ET: " + interval_micros + " : " + entryTime + " : " + sendingTime + " : " + line);
					}
				}

				if (lastUpdateTime != null) {
					long interval_micros = ChronoUnit.MICROS.between(lastUpdateTime, sendingTime);
					if (interval_micros > 100_000L) {
						System.out.println("SLOW LU: " + interval_micros + " : " + lastUpdateTime + " : " + sendingTime + " : " + line);
					}
				}
				*/

			} while ((line = br.readLine()) != null);
			System.out.println("processed file. lines: " + lineCount + " in " + (System.currentTimeMillis()-startTime) + " ms");
		} catch (IOException e) {
			throw new UncheckedIOException(e);
		}

		return this;
	}

	private void addLatency(ResizableDoubleArray array, long fromNanos, long toNanos) {
		if (fromNanos == Long.MIN_VALUE || toNanos == Long.MIN_VALUE) {
			array.addElement(Double.NaN);
		} else {
			array.addElement((toNanos - fromNanos) / (double)NANOS_IN_MICROS);
		}
	}

	private static void writeCsvSummary(String date, String loggerName, String filePrefix, String csvPath, ConsumerLatencyParser data, int parallelismLevel) throws IOException {
		if (parallelismLevel <= 0 || parallelismLevel == ForkJoinPool.getCommonPoolParallelism()) {
			parallelismLevel = 0;
		}
		final int totalValues = data.actions.numElements;
		System.out.println("Sample count: " + totalValues);
		System.out.printf("Memory consumed total: %.1f MB, per metric: %.1f MB%n", (7 * 8L + 2) * totalValues / 1024.0 / 1024.0, 8L * totalValues / 1024.0 / 1024.0);
		final Stream<String> stream = Stream.of(
				Pair.create("entry", "sending"),
				Pair.create("lastupdate", "sending"),
				Pair.create("sending", "receive"),
				Pair.create("receive", "process"),
				Pair.create("entry", "process"),
				Pair.create("lastupdate", "process"),
				Pair.create("sending", "process")
		)
				.flatMap(pair -> calculateStatistics(pair.getFirst(), pair.getSecond(), data).entrySet().stream())
				.sorted(Comparator.comparing((Map.Entry<StatisticsMetadata, Supplier<Map<String, Double>>> a) -> a.getKey().mdUpdateAction)
						.thenComparing(b -> b.getKey().mdEntryType)
						.thenComparing(a -> a.getKey().from)
						.thenComparing(a -> a.getKey().to))
				.map(e -> new AbstractMap.SimpleEntry<>(e.getKey(), e.getValue().get()))
				.filter(e -> e.getValue() != null)
				.sorted(Comparator.comparing((Map.Entry<StatisticsMetadata, Map<String, Double>> a) -> a.getKey().from)
						.thenComparing(b -> b.getKey().to)
						.thenComparing(a -> a.getKey().mdUpdateAction)
						.thenComparing(a -> a.getKey().mdEntryType))
				.map(e -> toCSVRow(date, loggerName, filePrefix, e.getKey(), e.getValue()));
		final List<String> cmds = parallelize(stream, parallelismLevel);

		String csvHeader = "date,directory,file,from,to,action,type," + String.join(",", STATISTICS_CALCULATORS.keySet());
		//System.out.println(csvHeader);
		//for (String cmd : cmds) {
		//System.out.println(cmd);
		//}

		System.out.println("Write to file: " + csvPath + " records: " + cmds.size());

		if (csvPath != null) {
			try (BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(csvPath)))) {
				bw.write(csvHeader);
				bw.write('\n');
				for (String cmd : cmds) {
					bw.write(cmd);
					bw.write('\n');
				}
			}
		}
	}

	private static <T> List<T> parallelize(Stream<T> originalStream, int parallelism) {
		final Stream<T> stream = parallelism == 1 ? originalStream : originalStream.parallel();
		if (parallelism <= 1) {
			return stream.collect(Collectors.toList());
		} else {
			final ForkJoinPool pool = new ForkJoinPool(parallelism);
			try {
				return pool.submit(() -> stream.collect(Collectors.toList())).get();
			} catch (Exception e) {
				throw new IllegalStateException(e);
			} finally {
				pool.shutdown();
			}
		}
	}

	private static byte toByte(String value, String type) {
		if (value.length() == 1) {
			return (byte)value.charAt(0);
		} else if (value.isEmpty()) {
			return 0;
		}
		throw new IllegalStateException("Illegal " + type + " value: " + value);
	}

	private static Map<StatisticsMetadata, Supplier<Map<String, Double>>> calculateStatistics(String fromStr, String toStr, ConsumerLatencyParser data) {
		final long calculateStartTime = System.currentTimeMillis();
		final ResizableDoubleArray array = data.getTimestamps(fromStr, toStr);
		final ResizableDoubleArray latenciesAll = array.getNumElements() == 0 || Arrays.stream(array.getInternalValues())
				.limit(array.getNumElements())
				.anyMatch(Double::isNaN) ? filter(array, array.getNumElements(), i -> true) : array;
		if (latenciesAll == null) {
			return Collections.emptyMap();
		}
		final Map<StatisticsMetadata, Supplier<Map<String, Double>>> result = new LinkedHashMap<>();
		final Supplier<Map<String, Double>> all = () -> {
			final LinkedHashMap<String, Double> allStat = calculateStatistics(latenciesAll);
			System.out.printf("Calculated latency for %s -> %s MDEntryType=all, MDUpdateAction=all in %s ms%n", fromStr, toStr, System.currentTimeMillis() - calculateStartTime);
			return allStat;
		};
		result.put(new StatisticsMetadata(fromStr, toStr, "", ""), all);
		if (data.sets.uniqueActions.size() == 1) {
			final int action = data.sets.uniqueActions.getValues().keySet().iterator().next();
			System.out.printf("Skipped per-action latency calculations %s -> %s: single action=%s found%n", fromStr, toStr, action);
			result.put(new StatisticsMetadata(fromStr, toStr, "", Integer.toString(action)), all);
		} else {
			for (Map.Entry<Integer, Integer> actionAndCount : data.sets.uniqueActions.getValues().entrySet()) {
				final int action = actionAndCount.getKey();
				final Supplier<Map<String, Double>> byAction = () -> {
					final long st = System.currentTimeMillis();
					final ResizableDoubleArray latenciesPerAction = filter(array, actionAndCount.getValue(), i -> data.actions.get(i) == action);
					if (latenciesPerAction != null) {
						final LinkedHashMap<String, Double> perAction = calculateStatistics(latenciesPerAction);
						System.out.printf("Calculated latency for %s -> %s MDEntryType=all, MDUpdateAction=%s in %s ms%n", fromStr, toStr, action, System.currentTimeMillis() - st);
						return perAction;
					}
					return null;
				};
				result.put(new StatisticsMetadata(fromStr, toStr, "", Integer.toString(actionAndCount.getKey())), byAction);
			}
		}
		if (data.sets.uniqueTypes.size() == 1) {
			final char type = (char) data.sets.uniqueTypes.getValues().keySet().iterator().next().intValue();
			System.out.printf("Skipped per-type latency calculations for %s -> %s: single MDEntryType=%s found%n", fromStr, toStr, type);
			result.put(new StatisticsMetadata(fromStr, toStr, Character.toString(type), ""), all);
		} else {
			for (Map.Entry<Integer, Integer> typeAndCount : data.sets.uniqueTypes.getValues().entrySet()) {
				final int type = typeAndCount.getKey();
				char typeAsChar = (char) type;
				final Supplier<Map<String, Double>> byType = () -> {
					final long st = System.currentTimeMillis();
					final ResizableDoubleArray latenciesPerType = filter(array, typeAndCount.getValue(), i -> data.types.get(i) == type);
					if (latenciesPerType != null) {
						final LinkedHashMap<String, Double> perType = calculateStatistics(latenciesPerType);
						System.out.printf("Calculated latency for %s -> %s MDEntryType=%s, MDUpdateAction=all in %s ms%n", fromStr, toStr, typeAsChar, System.currentTimeMillis() - st);
						return perType;
					}
					return null;
				};
				result.put(new StatisticsMetadata(fromStr, toStr, Character.toString(typeAsChar), ""), byType);
			}
		}
		if (data.sets.uniqueActionTypeCombinations.size() == 1) {
			final char type = (char)data.sets.uniqueTypes.getValues().keySet().iterator().next().intValue();
			final int action = data.sets.uniqueActions.getValues().keySet().iterator().next();
			System.out.printf("Skipped per-combination latency calculations for %s -> %s: single combination of MDEntryType=%s and MDUpdateAction=%s found%n", fromStr, toStr, type, action);
			result.put(new StatisticsMetadata(fromStr, toStr, Character.toString(type), Integer.toString(action)), all);
		} else {
			for (Map.Entry<Integer, Integer> cmbToCount : data.sets.uniqueActionTypeCombinations.getValues().entrySet()) {
				int cmb = cmbToCount.getKey();
				char typeAsChar = (char) (cmb % 128);
				int action = cmb / 128;
				final Supplier<Map<String, Double>> byActionAndType = () -> {
					final long st = System.currentTimeMillis();
					final ResizableDoubleArray latenciesPerCombo = filter(array, cmbToCount.getValue(), i -> data.types.get(i) + data.actions.get(i) * 128 == cmb);
					if (latenciesPerCombo != null) {
						final LinkedHashMap<String, Double> perCombo = calculateStatistics(latenciesPerCombo);
						System.out.printf("Calculated latency for %s -> %s MDEntryType=%s, MDUpdateAction=%s in %s ms%n", fromStr, toStr, typeAsChar, action, System.currentTimeMillis() - st);
						return perCombo;
					}
					return null;
				};
				result.put(new StatisticsMetadata(fromStr, toStr, Character.toString(typeAsChar), Integer.toString(action)), byActionAndType);
			}
		}
		return result;
	}

	private static ResizableDoubleArray filter(ResizableDoubleArray source, int size, IntPredicate indexPredicate) {
		if (size == 0) {
			return null;
		}
		final ResizableDoubleArray latencies = new ResizableDoubleArray(size);
		final int len = source.getNumElements();
		final double[] array = source.getInternalValues();
		for (int i = 0; i < len; i++) {
			final double element = array[i];
			if (Double.isNaN(element) || !indexPredicate.test(i)) {
				continue;
			}
			latencies.addElement(element);
		}
		return latencies.getNumElements() == 0 ? null : latencies;
	}


	private static LinkedHashMap<String, Double> calculateStatistics(ResizableDoubleArray latencies) {
		return STATISTICS_CALCULATORS.entrySet().stream()
				.collect(Collectors.toMap(Map.Entry::getKey,
						e -> e.getValue().applyAsDouble(latencies),
						(a, b) -> b,
						LinkedHashMap::new));
	}

	public static String toCSVRow(String date, String directory, String filePrefix, StatisticsMetadata meta, Map<String, Double> values) {
		StringBuilder row = new StringBuilder()
				.append(date).append(',').append(directory)
				.append(',').append(filePrefix)
				.append(',').append(meta.from)
				.append(',').append(meta.to).append(',')
				.append(meta.mdUpdateAction).append(',')
				.append(meta.mdEntryType);
		for (Map.Entry<String, Double> entry : values.entrySet()) {
			row.append(',');
			if ("count".equals(entry.getKey())) {
				row.append(entry.getValue().longValue());
			} else {
				row.append(String.format("%.0f", entry.getValue()));
			}
		}
		return row.toString();
	}

	private static final DateTimeFormatter TF_SEC = DateTimeFormatter.ofPattern("HHmmss");
	private static final DateTimeFormatter TF_MILLI = DateTimeFormatter.ofPattern("HHmmssSSS");
	private static final DateTimeFormatter TF_MICRO = DateTimeFormatter.ofPattern("HHmmssSSSSSS");
	private static final DateTimeFormatter TF_NANO = DateTimeFormatter.ofPattern("HHmmssSSSSSSSSS");

	// In opposite to getSendingTime method, return Long.MIN_VALUE instead of exception in case of empty value
	private long getTimeFromStandardFormat(String[] sp, int idx) {
		String str;
		if (idx < 0 || (str = sp[idx]).isEmpty()) {
			return Long.MIN_VALUE;
		}
		if (str.length() == 12) {
			return parseHHMMssSSSSSS(str);
		}
		return parseYYMMddHHMMssSSSSSS(str);
	}

	private long getSendingTime(String[] sp, int idx) {
		String str;
		if (idx < 0 || (str = sp[idx]).isEmpty()) {
			throw new IllegalStateException("SendingTime must be specified");
		}
		switch (str.length()) {
			case 18: return parseYYMMddHHMMssSSSSSS(str);
			case 17: return LocalTime.parse(str.substring(8), TF_MILLI).toNanoOfDay() + dateUtcOffsetNanos;
			case 12: return parseHHMMssSSSSSS(str);
			default: throw new RuntimeException("Unexpected sendingTime " + str);
		}
	}

	private long getEntryTime(String[] sp, int indexDate, int indexTime) {
		String timeStr;
		if (indexTime < 0 || (timeStr = sp[indexTime]).isEmpty() || !sp[indexDate].isEmpty()) {
			return Long.MIN_VALUE;
		}
		int tlen = timeStr.length();
		final DateTimeFormatter df;
		if (tlen <= 6) {
			df = TF_SEC;
			//timeStr = String.format("%06d", Long.parseLong(timeStr));
			//second-level precision doesn't make sense for latency monitoring
			return Long.MIN_VALUE;
		} else if (tlen == 11) {
			// 70958834009 > 070958834009
			timeStr = "0" + timeStr;
			df = TF_MICRO;
			return parseHHMMssSSSSSS(timeStr);
		} else if (tlen == 12) {
			df = TF_MICRO;
			return parseHHMMssSSSSSS(timeStr);
		} else if (tlen == 14) {
			timeStr = "0" + timeStr;
			df = TF_NANO;
		} else if (tlen == 15) {
			df = TF_NANO;
		} else {
			throw new RuntimeException("Unexpected time string: " + timeStr);
		}
		return LocalTime.parse(timeStr, df).toNanoOfDay() + dateUtcOffsetNanos;
	}

	private static final class StatisticsMetadata {
		private final String from;
		private final String to;
		private final String mdEntryType;
		private final String mdUpdateAction;

		private StatisticsMetadata(String from, String to, String mdEntryType, String mdUpdateAction) {
			this.from = from;
			this.to = to;
			this.mdEntryType = mdEntryType;
			this.mdUpdateAction = mdUpdateAction;
		}
	}

	private static final class SetsContainer {
		private final SimpleIntMultiSet uniqueActions;
		private final SimpleIntMultiSet uniqueTypes;
		private final SimpleIntMultiSet uniqueActionTypeCombinations;

		private SetsContainer() {
			this(new SimpleIntMultiSet(3), new SimpleIntMultiSet(128), new SimpleIntMultiSet(128 * 3));
		}

		private SetsContainer(SimpleIntMultiSet uniqueActions, SimpleIntMultiSet uniqueTypes, SimpleIntMultiSet uniqueActionTypeCombinations) {
			this.uniqueActions = uniqueActions;
			this.uniqueTypes = uniqueTypes;
			this.uniqueActionTypeCombinations = uniqueActionTypeCombinations;
		}

		public static SetsContainer merged(SetsContainer[] containers) {
			return new SetsContainer(
					SimpleIntMultiSet.merge(Arrays.stream(containers).map(c -> c.uniqueActions).toArray(SimpleIntMultiSet[]::new)),
					SimpleIntMultiSet.merge(Arrays.stream(containers).map(c -> c.uniqueTypes).toArray(SimpleIntMultiSet[]::new)),
					SimpleIntMultiSet.merge(Arrays.stream(containers).map(c -> c.uniqueActionTypeCombinations).toArray(SimpleIntMultiSet[]::new))
			);
		}
	}

	private static final class SimpleIntMultiSet {
		private final int[] data;
		private int size;

		public SimpleIntMultiSet(int maxSize) {
			data = new int[maxSize];
		}

		public static SimpleIntMultiSet merge(SimpleIntMultiSet[] sets) {
			int length = Arrays.stream(sets).mapToInt(s -> s.data.length).max().orElse(0);
			final SimpleIntMultiSet merged = new SimpleIntMultiSet(length);
			for (int i = 0; i < length; i++) {
				int cnt = 0;
				for (SimpleIntMultiSet set : sets) {
					if (set.data.length > i) {
						cnt += set.data[i];
					}
				}
				if (cnt > 0) {
					merged.data[i] = cnt;
					merged.size++;
				}
			}
			return merged;
		}

		public void add(int c) {
			final int oldLength = data[c];
			data[c] = oldLength + 1;
			if (oldLength == 0) {
				size++;
			}
		}

		public Map<Integer, Integer> getValues() {
			Map<Integer, Integer> result = new LinkedHashMap<>();
			if (size > 0) {
				for (int i = 0; i < data.length; i++) {
					if (data[i] > 0) {
						result.put(i, data[i]);
					}
				}
			}
			return result;
		}

		public int size() {
			return size;
		}
	}

	private static final class ResizableByteArray {
		private final double expansionFactor = 2.0;
		private byte[] internalArray;
		private int numElements;

		public ResizableByteArray(int initialCapacity) {
			if (initialCapacity <= 0) {
				throw new IllegalArgumentException("Initial capacity must be positive");
			}
			this.internalArray = new byte[initialCapacity];
		}

		public void contract() {
			this.internalArray = Arrays.copyOf(internalArray, numElements + 1);
		}

		public void add(byte value) {
			if (this.internalArray.length <= this.numElements) {
				this.expand();
			}
			this.internalArray[this.numElements++] = value;
		}

		private void expand() {
			final int oldLength = internalArray.length;
			long newSize = (long) FastMath.ceil((double)this.internalArray.length * this.expansionFactor);;
			if (newSize > Integer.MAX_VALUE - 2) {
				if (oldLength < Integer.MAX_VALUE - 2) {
					newSize = Integer.MAX_VALUE - 2;
				} else {
					throw new OutOfMemoryError("Cannot allocate memory for " + (Integer.MAX_VALUE - 1) + " elements");
				}
			}
			this.internalArray = Arrays.copyOf(internalArray, (int)newSize);
		}

		public byte get(int index) {
			return this.internalArray[index];
		}
	}
}