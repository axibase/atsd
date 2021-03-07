import java.io.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.zip.GZIPInputStream;

import org.apache.commons.math3.stat.descriptive.DescriptiveStatistics;

public class ConsumerLatencyParser {
	
	public static Integer fileIndex(File f) {
		String name = f.getName();
		//statistics.19-02-2021.1.log.gz
		return Integer.parseInt(name.split("\\.")[name.split("\\.").length-3]);
	}

	public static void main(String[] args) throws Exception {

		System.out.println("Start");
		
		String directory = args[0];
		String filePrefix = args[1];
		String date = args[2];
		String csvPath = args.length > 3 ? args[3] : null;

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
		LocalDate.parse(date, DateTimeFormatter.ofPattern("dd-MM-yyyy"));
		
		if (!new File(directory).isDirectory()) {
			throw new Exception("Invalid directory: " + directory);
		}
		
		File[] files = new File(directory).listFiles(f -> f.getName().startsWith(filePrefix + "." + date + ".") && f.getName().endsWith(".log.gz") && f.length()>0);		
		
		if (files == null) {
			throw new Exception("No files matched: " + directory + "/" + filePrefix + "." + date + ".*.log.gz");
		}
		
		Arrays.sort(files, (a, b) -> fileIndex(a).compareTo(fileIndex(b)));
		
		System.out.println("Files found: " + files.length + " in " + directory + " for " + date);
		
		String loggerName = null;
		{
			String[] dirs = new File(directory).getPath().split("/");
			for (int k = dirs.length-1; k >= 0; k--) {
				String dir = dirs[k];
				if (dir.startsWith("logger_")) {
					loggerName = dir;
					break;
				}
			}
			if (loggerName == null) {
				throw new IllegalArgumentException("Unexpected directory: " + directory);
			}
			System.out.println("consumer/logger name: " + loggerName);
		}
		
		boolean is_futures = loggerName.contains("futures");
		boolean is_fond = loggerName.contains("hc_jdk");
		boolean is_fx = loggerName.contains("fx");
		boolean is_index = loggerName.contains("futures") && filePrefix.contains("index");
		
		//4*60 as of March 1, 2020 for futures and fx
		int earlyStartMinute = LocalDate.parse(date, DateTimeFormatter.ofPattern("dd-MM-yyyy")).isBefore(LocalDate.parse("01-03-2021", DateTimeFormatter.ofPattern("dd-MM-yyyy"))) ? 7*60 : 4*60;
		
		Map<Map<String, String>, DescriptiveStatistics> sendingProcessDsMap = new TreeMap<>(new TypeActionComparator());
		Map<Map<String, String>, DescriptiveStatistics> lastUpdateProcessDsMap = new TreeMap<>(new TypeActionComparator());
		Map<Map<String, String>, DescriptiveStatistics> receiveProcessDsMap = new TreeMap<>(new TypeActionComparator());
		Map<Map<String, String>, DescriptiveStatistics> entryProcessDsMap = new TreeMap<>(new TypeActionComparator());
		Map<Map<String, String>, DescriptiveStatistics> lastUpdateSendingDsMap = new TreeMap<>(new TypeActionComparator());
		Map<Map<String, String>, DescriptiveStatistics> sendingReceiveDsMap = new TreeMap<>(new TypeActionComparator());
		Map<Map<String, String>, DescriptiveStatistics> entrySendingDsMap = new TreeMap<>(new TypeActionComparator());

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

			int lineCount = 0;
			long startTime = System.currentTimeMillis();
			long lastLogTime = System.currentTimeMillis();

			BufferedReader br = new BufferedReader(new InputStreamReader(new GZIPInputStream(new FileInputStream(f))));
			String line = br.readLine();
			do {
				
				lineCount++;
				
				if (System.currentTimeMillis() - lastLogTime > 10000) {
					System.out.println("processing line " + lineCount + " : " + line);
					lastLogTime = System.currentTimeMillis();
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
				
				LocalDateTime sendingTime = getSendingTime(sp, indexSendingTime);

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
				


				LocalDateTime processTime = getTimeFromStandardFormat(sp, indexProcessTime);
				LocalDateTime receiveTime = getTimeFromStandardFormat(sp, indexReceiveTime);
				LocalDateTime lastUpdateTime = getTimeFromStandardFormat(sp, indexLastUpdateTime);
				LocalDateTime entryTime = getEntryTime(sp, indexMDEntryDate, indexMDEntryTime, indexReceiveTime);
				
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

	public static List<String> toCSV(String date, String from, String to, String directory, String filePrefix, Map<Map<String, String>, DescriptiveStatistics> ds) {

		List<String> res = new ArrayList<>();
		for (Map.Entry<Map<String, String>, DescriptiveStatistics> me : ds.entrySet()) {
			String row = date + "," + directory + "," + filePrefix;
			row += "," + from;
			row += "," + to;
			row += "," + ((me.getKey().get("action") == null) ? "" : me.getKey().get("action"));
			row += "," + ((me.getKey().get("type") == null) ? "" : me.getKey().get("type"));
			DescriptiveStatistics d = me.getValue();
			row += "," + d.getN();
			row += "," + String.format("%.0f", d.getMin());
			double[] ranks = {0.1, 1.0, 5.0, 10.0, 25.0, 50.0, 75.0, 90.0, 95.0, 99.0, 99.9};
			for (double rank : ranks) {
				row += "," + String.format("%.0f", d.getPercentile(rank));
			}
			row += "," + String.format("%.0f", d.getMax());
			res.add(row);
		}
		return res;
	}
	
	public static void addInterval(LocalDateTime from, LocalDateTime to, int action, String type, Map<Map<String, String>, DescriptiveStatistics> dsMap) {
		
		if (to == null || from == null) {
			return;
		}
		
		long interval_micros = ChronoUnit.MICROS.between(from, to);

		Set<Map<String, String>> keys = new HashSet<>();
		{
			Map<String, String> key = new LinkedHashMap<>();
			//key.put("action", "" + action);
			//key.put("type", type);
			keys.add(key);
		}
		{
			Map<String, String> key = new LinkedHashMap<>();
			key.put("action", "" + action);
			//key.put("type", type);
			keys.add(key);
		}
		{
			Map<String, String> key = new LinkedHashMap<>();
			//key.put("action", "" + action);
			key.put("type", type);
			keys.add(key);
		}
		{
			Map<String, String> key = new LinkedHashMap<>();
			key.put("action", "" + action);
			key.put("type", type);
			keys.add(key);
		}
		
		for (Map<String, String> key : keys) {
			DescriptiveStatistics ds = dsMap.get(key);
			if (ds == null) {
				ds = new DescriptiveStatistics();
				dsMap.put(key, ds);
			}
			ds.addValue(interval_micros);
		}
	}
	
	private static DateTimeFormatter DTF_SEC   = DateTimeFormatter.ofPattern("yyMMddHHmmss");
	private static DateTimeFormatter DTF_MILLI = DateTimeFormatter.ofPattern("yyMMddHHmmssSSS");
	private static DateTimeFormatter DTF_MICRO = DateTimeFormatter.ofPattern("yyMMddHHmmssSSSSSS");
	private static DateTimeFormatter DTF_NANO  = DateTimeFormatter.ofPattern("yyMMddHHmmssSSSSSSSSS");
	
	public static LocalDateTime getTimeFromStandardFormat(String[] sp, int idx) {
		if (idx < 0) {
			return null;
		}
		String str = sp[idx];

		if (str.isEmpty()) {
			return null;
		}
		return LocalDateTime.parse(str, DTF_MICRO);
	}
	
	public static LocalDateTime getSendingTime(String[] sp, int idx) {
		if (idx < 0) {
			return null;
		}
		String str = sp[idx];
		if (str.isEmpty()) {
			return null;
		}
		if (str.length() == 18) {
			return LocalDateTime.parse(str, DTF_MICRO);
		} else if (str.length() == 17) {
			return LocalDateTime.parse(str.substring(2), DTF_MILLI);
		} else {
			throw new RuntimeException("Unexpected sendingTime " + str);
		}
	}
	
	public static LocalDateTime getEntryTime(String[] sp, int indexDate, int indexTime, int indexReceiveTime) {
		if (indexTime < 0) {
			return null;
		}
		String timeStr = sp[indexTime];
		if (timeStr.isEmpty()) {
			return null;
		}
		String dateStr = sp[indexDate];
		String receiveDate = sp[indexReceiveTime].substring(0, 6);
		if (dateStr.isEmpty()) {
			dateStr = receiveDate;
		} else {
			dateStr = dateStr.substring(2);
			if (!dateStr.equals(receiveDate)) {
				// previous day? 20210219,210000000000000 -> 0210220 (same day in Moscow)
				return null;
			}
		}
		
		//avoid string format for perf
		int tlen = timeStr.length();
		DateTimeFormatter df = null;
		if (tlen <= 6) {
			df = DTF_SEC;
			timeStr = String.format("%06d", Long.parseLong(timeStr));
			//second-level precision doesn't make sense for latency monitoring
			return null;
		} else if (tlen == 11) {
			// 70958834009 > 070958834009
			timeStr = "0" + timeStr;
			df = DTF_MICRO;
		} else if (tlen == 12) {
			df = DTF_MICRO;
		} else if (tlen == 14) {
			timeStr = "0" + timeStr;
			df = DTF_NANO;
		} else if (tlen == 15) {
			df = DTF_NANO;
		} else {
			throw new RuntimeException("Unexpected time string: " + timeStr);
		}
		return LocalDateTime.parse(dateStr + timeStr, df);
	
	}
	
	public static class TypeActionComparator implements Comparator<Map<String, String>> {

		public TypeActionComparator() {
		}
		
		@Override
		public int compare(Map<String, String> m1, Map<String, String> m2) {
			int res = Integer.compare(m1.size(), m2.size());
			if (res == 0) {
				res = m1.toString().compareTo(m2.toString());
			}
			return res;
		}
	}
	
}