import javax.xml.bind.DatatypeConverter;
import java.io.DataOutputStream;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class DataApiSeriesCsvInsertExample {

    public static void main(String[] args) throws Exception {

        String databaseUrl = "http://localhost:8088";
        String userName = "axibase";
        String password = "axibase";

        String host = InetAddress.getLocalHost().getHostName();
        String header = "time,runtime.memory.free,runtime.memory.max,runtime.memory.total";
        String dataRow = System.currentTimeMillis() + "," + Runtime.getRuntime().freeMemory() + "," + Runtime.getRuntime().maxMemory() + "," + Runtime.getRuntime().totalMemory();
        String csvContent = header + "\n" + dataRow;

        System.out.println("Sending csv: \n" + csvContent);

        URL url = new URL(databaseUrl + "/api/v1/series/csv/" + host);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        System.out.println("Connection established to " + databaseUrl);

        conn.setDoOutput(true);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("charset", "utf-8");
        conn.setRequestProperty("Content-Type", "text/csv");

        String authString = userName + ":" + password;
        String authEncoded = DatatypeConverter.printBase64Binary(authString.getBytes(StandardCharsets.UTF_8));
        conn.setRequestProperty("Authorization", "Basic " + authEncoded);

        byte[] payload = csvContent.getBytes(StandardCharsets.UTF_8);
        conn.setUseCaches(false);

        try (DataOutputStream wr = new DataOutputStream(conn.getOutputStream())) {
            wr.write(payload);

            System.out.println("Request sent");

            int code = conn.getResponseCode();

            System.out.println("Response code: " + code);

            if (code == HttpURLConnection.HTTP_NO_CONTENT) {
                System.out.println("Commands sent");
            } else {
                System.out.println(conn.getResponseMessage());
            }
        }


    }


}
