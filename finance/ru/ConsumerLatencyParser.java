import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.zip.GZIPInputStream;

import org.apache.commons.math3.stat.descriptive.DescriptiveStatistics;

public class ConsumerLatencyParser {

	public static int fileIndex(File f) {
		String name = f.getName();
		//statistics.19-02-2021.1.log.gz
		String[] parts = name.split("\\.");
		return Integer.parseInt(parts[parts.length-3]);
	}

	private static final DateTimeFormatter DTF_MIN = DateTimeFormatter.ofPattern("yyMMddHHmm");
	private static final DateTimeFormatter TF_MIN = DateTimeFormatter.ofPattern("HHmm");

	// not Thread-safe, but 40% faster
	//210224180237044631 > 2102241802 37044631
	private static String lastMinuteTime = null;
	private static LocalDateTime lastLocalDateTime = null;

	private static LocalDateTime parseMicroUsingFullFormat(String yyMMddHHMMssSSSSSS) {
		if (lastMinuteTime == null || !lastMinuteTime.regionMatches(0, yyMMddHHMMssSSSSSS, 0, 10)) {
			String minPart = yyMMddHHMMssSSSSSS.substring(0, 10);
			lastMinuteTime = minPart;
			lastLocalDateTime = DTF_MIN.parse(minPart, LocalDateTime::from);
		}
		long nanos = 1000L*Integer.parseInt(yyMMddHHMMssSSSSSS.substring(10));
		return lastLocalDateTime.plusNanos(nanos);
	}

	private static LocalDateTime parseMicroUsingShortFormat(String hhMMssSSSSSS, LocalDate localDate) {
		if (lastMinuteTime == null || !lastMinuteTime.regionMatches(0, hhMMssSSSSSS, 0, 4)) {
			String minPart = hhMMssSSSSSS.substring(0, 4);
			lastMinuteTime = minPart;
			lastLocalDateTime = LocalDateTime.of(localDate, TF_MIN.parse(minPart, LocalTime::from));
		}
		long nanos = 1000L*Integer.parseInt(hhMMssSSSSSS.substring(4));
		return lastLocalDateTime.plusNanos(nanos);
	}

	public static void main(String[] args) throws Exception {
		String directory = args[0];
		String filePrefix = args[1];
		String date = args[2];
		String csvPath = args.length > 3 ? args[3] : null;

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

		//try parsing the date
		LocalDate localDate = LocalDate.parse(date, DateTimeFormatter.ofPattern("dd-MM-yyyy"));

		if (!new File(directory).isDirectory()) {
			throw new Exception("Invalid directory: " + directory);
		}

		String namePrefix = filePrefix + "." + date + ".";
		File[] files = new File(directory).listFiles(f -> f.getName().startsWith(namePrefix) && f.getName().endsWith(".log.gz") && f.length()>0);

		if (files == null) {
			throw new Exception("No files matched: " + directory + "/" + filePrefix + "." + date + ".*.log.gz");
		}

		files = Arrays.stream(files)
				.map(f -> new AbstractMap.SimpleEntry<>(f, fileIndex(f)))
				.sorted(Map.Entry.comparingByValue())
				.map(AbstractMap.SimpleEntry::getKey)
				.toArray(File[]::new);

		System.out.println("Files found: " + files.length + " in " + directory + " for " + date);

		String loggerName = null;
		{
			String[] dirs = new File(directory).getAbsolutePath().split("/");
			int indexOfLogs = lastIndexOf(dirs, "logs");
			if (indexOfLogs < 1) {
				throw new IllegalArgumentException("Unexpected directory: " + directory);
			}
			loggerName = dirs[indexOfLogs - 1];
			System.out.println("consumer/logger name: " + loggerName);
		}

		boolean is_futures = loggerName.contains("futures") || loggerName.contains("spectra");
		boolean is_fond = loggerName.contains("hc_jdk") || loggerName.contains("fond");
		boolean is_fx = loggerName.contains("fx");
		boolean is_index = is_futures && filePrefix.contains("index");

		//4*60 as of March 1, 2020 for futures and fx
		int earlyStartMinute = LocalDate.parse(date, DateTimeFormatter.ofPattern("dd-MM-yyyy")).isBefore(LocalDate.parse("01-03-2021", DateTimeFormatter.ofPattern("dd-MM-yyyy"))) ? 7*60 : 4*60;

		Map<ActionAndType, DescriptiveStatistics> sendingProcessDsMap = new TreeMap<>();
		Map<ActionAndType, DescriptiveStatistics> lastUpdateProcessDsMap = new TreeMap<>();
		Map<ActionAndType, DescriptiveStatistics> receiveProcessDsMap = new TreeMap<>();
		Map<ActionAndType, DescriptiveStatistics> entryProcessDsMap = new TreeMap<>();
		Map<ActionAndType, DescriptiveStatistics> lastUpdateSendingDsMap = new TreeMap<>();
		Map<ActionAndType, DescriptiveStatistics> sendingReceiveDsMap = new TreeMap<>();
		Map<ActionAndType, DescriptiveStatistics> entrySendingDsMap = new TreeMap<>();

		for (File f : files) {

			System.out.println("== processing file " + f.getAbsolutePath() + " : " + f.length() + " ==");

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

			BufferedReader br = new BufferedReader(new InputStreamReader(new GZIPInputStream(new FileInputStream(f))));

			long startTime = System.currentTimeMillis();
			long lastLogTime = System.currentTimeMillis();
			long lastLogCount = 0;
			int lineCount = 0;

			String line = br.readLine();
			do {

				lineCount++;

				if (System.currentTimeMillis() - lastLogTime > 10000) {
					double msgPerSec = ((lineCount-lastLogCount)/(System.currentTimeMillis() - lastLogTime))*1000L;
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
					continue;
				}

				if (mode >= 2) {
					//only read
					continue;
				}

				String[] sp = line.split(",", -1);
				if (sp.length != header.size()){
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

				String entryType = sp[indexMDEntryType];
				int updateAction = Integer.parseInt(sp[indexMDUpdateAction]);

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

				LocalDateTime sendingTime = getSendingTime(sp, indexSendingTime, localDate);

				int minutes_of_day = sendingTime.getHour()*60 + sendingTime.getMinute();

				if (is_futures && !is_index) {
					if (minutes_of_day < earlyStartMinute || minutes_of_day >= 11*60 && minutes_of_day < 11*60+5 || minutes_of_day >= 15*60+45 && minutes_of_day < 16*60 || minutes_of_day >= 20*60+50) {
						continue;
					}
				}

				if (is_index && indexSymbol >= 0) {
					if (minutes_of_day < 7*60 || minutes_of_day >= 20*60+50 || minutes_of_day >= 15*60+40 && minutes_of_day < 16*60) {
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
				}

				if (is_fond) {
					//if (minutes_of_day < 7*60 || minutes_of_day >= 15*60+40 && minutes_of_day < 16*60+5 || minutes_of_day >= 20*60+50) {
					if (minutes_of_day < 7*60 || minutes_of_day >= 20*60+50) {
						continue;
					}
				}

				if (is_fx) {
					if (minutes_of_day < earlyStartMinute || minutes_of_day >= 20*60+50) {
						continue;
					}
				}

				LocalDateTime processTime = getTimeFromStandardFormat(sp, indexProcessTime, localDate);
				LocalDateTime receiveTime = getTimeFromStandardFormat(sp, indexReceiveTime, localDate);
				LocalDateTime lastUpdateTime = getTimeFromStandardFormat(sp, indexLastUpdateTime, localDate);
				LocalDateTime entryTime = getEntryTime(sp, indexMDEntryDate, indexMDEntryTime, localDate);

				if (mode >= 1) {
					//only read and parse
					continue;
				}

				addInterval(sendingTime, processTime, updateAction, entryType, sendingProcessDsMap);
				addInterval(lastUpdateTime, processTime, updateAction, entryType, lastUpdateProcessDsMap);
				addInterval(receiveTime, processTime, updateAction, entryType, receiveProcessDsMap);
				addInterval(entryTime, processTime, updateAction, entryType, entryProcessDsMap);
				addInterval(lastUpdateTime, sendingTime, updateAction, entryType, lastUpdateSendingDsMap);
				addInterval(entryTime, sendingTime, updateAction, entryType, entrySendingDsMap);
				addInterval(sendingTime, receiveTime, updateAction, entryType, sendingReceiveDsMap);

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

			br.close();

			System.out.println("processed file. lines: " + lineCount + " in " + (System.currentTimeMillis()-startTime));

		}

		if (mode <= 0) {

			List<String> cmds = new ArrayList<String>();
			cmds.addAll(toCSV(date, "entry", "sending", loggerName, filePrefix, entrySendingDsMap));
			cmds.addAll(toCSV(date, "lastupdate", "sending", loggerName, filePrefix, lastUpdateSendingDsMap));
			cmds.addAll(toCSV(date, "sending", "receive", loggerName, filePrefix, sendingReceiveDsMap));
			cmds.addAll(toCSV(date, "receive", "process", loggerName, filePrefix, receiveProcessDsMap));
			cmds.addAll(toCSV(date, "entry", "process", loggerName, filePrefix, entryProcessDsMap));
			cmds.addAll(toCSV(date, "lastupdate", "process", loggerName, filePrefix, lastUpdateProcessDsMap));
			cmds.addAll(toCSV(date, "sending", "process", loggerName, filePrefix, sendingProcessDsMap));

			String csvHeader = "date,directory,file,from,to,action,type,count,min,p0.1,p1,p5,p10,p25,p50,p75,p90,p95,p99,p99.9,max";
			//System.out.println(csvHeader);
			for (String cmd : cmds) {
				//System.out.println(cmd);
			}

			System.out.println("Write to file: " + csvPath + " records: " + cmds.size());

			if (csvPath != null) {
				BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(new File(csvPath))));
				bw.write(csvHeader + "\n");
				for (String cmd : cmds) {
					bw.write(cmd + "\n");
				}
				bw.close();
			}
		} else {
			System.out.println("Skip writing to file");
		}

		System.out.println("Completed");

	}

	private static <T> int lastIndexOf(T[] array, T element) {
		for (int i = array.length - 1; i >= 0; i--) {
			if (element.equals(array[i])) {
				return i;
			}
		}
		return -1;
	}

	public static List<String> toCSV(String date, String from, String to, String directory, String filePrefix, Map<ActionAndType, DescriptiveStatistics> ds) {
		List<String> res = new ArrayList<>();
		StringBuilder row = new StringBuilder();
		for (Map.Entry<ActionAndType, DescriptiveStatistics> me : ds.entrySet()) {
			row.setLength(0);
			row.append(date).append(',').append(directory)
				.append(',').append(filePrefix)
				.append(',').append(from)
				.append(',').append(to).append(',');
			if (me.getKey().action >= 0) {
				row.append(me.getKey().action);
			}
			row.append(',');
			if (me.getKey().type != null) {
				row.append(me.getKey().type);
			}
			DescriptiveStatistics d = me.getValue();
			row.append(",").append(d.getN());
			row.append(",").append(String.format("%.0f", d.getMin()));
			double[] ranks = {0.1, 1.0, 5.0, 10.0, 25.0, 50.0, 75.0, 90.0, 95.0, 99.0, 99.9};
			for (double rank : ranks) {
				row.append(',').append(String.format("%.0f", d.getPercentile(rank)));
			}
			row.append(',').append(String.format("%.0f", d.getMax()));
			res.add(row.toString());
		}
		return res;
	}

	public static void addInterval(LocalDateTime from, LocalDateTime to, int action, String type, Map<ActionAndType, DescriptiveStatistics> dsMap) {
		if (to == null || from == null) {
			return;
		}
		long interval_micros = ChronoUnit.MICROS.between(from, to);
		dsMap.computeIfAbsent(ActionAndType.ofNone(), k -> new DescriptiveStatistics()).addValue(interval_micros);
		dsMap.computeIfAbsent(ActionAndType.ofAction(action), k -> new DescriptiveStatistics()).addValue(interval_micros);
		dsMap.computeIfAbsent(ActionAndType.ofType(type), k -> new DescriptiveStatistics()).addValue(interval_micros);
		dsMap.computeIfAbsent(ActionAndType.ofActionAndType(action, type), k -> new DescriptiveStatistics()).addValue(interval_micros);
	}

	private static final DateTimeFormatter TF_SEC = DateTimeFormatter.ofPattern("HHmmss");
	private static final DateTimeFormatter TF_MILLI = DateTimeFormatter.ofPattern("HHmmssSSS");
	private static final DateTimeFormatter TF_MICRO = DateTimeFormatter.ofPattern("HHmmssSSSSSS");
	private static final DateTimeFormatter TF_NANO = DateTimeFormatter.ofPattern("HHmmssSSSSSSSSS");

	public static LocalDateTime getTimeFromStandardFormat(String[] sp, int idx, LocalDate date) {
		if (idx < 0) {
			return null;
		}
		String str = sp[idx];

		if (str.isEmpty()) {
			return null;
		}
		if (str.length() == 12) {
			return parseMicroUsingShortFormat(str, date);
		}
		return parseMicroUsingFullFormat(str);
	}

	public static LocalDateTime getSendingTime(String[] sp, int idx, LocalDate date) {
		if (idx < 0) {
			return null;
		}
		String str = sp[idx];
		if (str.isEmpty()) {
			return null;
		}
		switch (str.length()) {
			case 18: return parseMicroUsingFullFormat(str);
			case 17: return LocalDateTime.of(date, LocalTime.parse(str.substring(8), TF_MILLI));
			case 12: return parseMicroUsingShortFormat(str, date);
			default: throw new RuntimeException("Unexpected sendingTime " + str);
		}
	}

	public static LocalDateTime getEntryTime(String[] sp, int indexDate, int indexTime, LocalDate localDate) {
		if (indexTime < 0) {
			return null;
		}
		String timeStr = sp[indexTime];
		if (timeStr.isEmpty()) {
			return null;
		}
		String dateStr = sp[indexDate];
		if (!dateStr.isEmpty()) { // previous day
			return null;
		}

		//avoid string format for perf
		int tlen = timeStr.length();
		DateTimeFormatter df = null;
		if (tlen <= 6) {
			df = TF_SEC;
			timeStr = String.format("%06d", Long.parseLong(timeStr));
			//second-level precision doesn't make sense for latency monitoring
			return null;
		} else if (tlen == 11) {
			// 70958834009 > 070958834009
			timeStr = "0" + timeStr;
			df = TF_MICRO;
			return parseMicroUsingShortFormat(timeStr, localDate);
		} else if (tlen == 12) {
			df = TF_MICRO;
			return parseMicroUsingShortFormat(timeStr, localDate);
		} else if (tlen == 14) {
			timeStr = "0" + timeStr;
			df = TF_NANO;
		} else if (tlen == 15) {
			df = TF_NANO;
		} else {
			throw new RuntimeException("Unexpected time string: " + timeStr);
		}
		return LocalDateTime.of(localDate, LocalTime.parse(timeStr, df));

	}

	private static final class ActionAndType implements Comparable<ActionAndType> {
		private final int action;
		private final String type;
		private String str;

		private static ActionAndType ofType(String type) {
			return new ActionAndType(-1, type);
		}

		private static ActionAndType ofAction(int action) {
			return new ActionAndType(action, null);
		}

		private static ActionAndType ofActionAndType(int action, String type) {
			return new ActionAndType(action, type);
		}

		private static ActionAndType ofNone() {
			return new ActionAndType(-1, null);
		}

		private ActionAndType(int action, String type) {
			this.action = action;
			this.type = type;
		}

		@Override
		public String toString() {
			if (str == null) {
				StringBuilder sb = new StringBuilder().append('{');
				if (action != -1) {
					sb.append("action=").append(action);
				}
				if (type != null) {
					if (sb.length() > 1) {
						sb.append(", ");
					}
					sb.append("type=").append(type);
				}
				sb.append('}');
				str = sb.toString();
			}
			return str;
		}

		private int size() {
			int size = 0;
			if (action != -1) {
				size++;
			}
			if (type != null) {
				size++;
			}
			return size;
		}

		@Override
		public int compareTo(ActionAndType o) {
			int cmp = Integer.compare(size(), o.size());
			if (cmp == 0) {
				cmp = toString().compareTo(o.toString());
			}
			return cmp;
		}
	}
}