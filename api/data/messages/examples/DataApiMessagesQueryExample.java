import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONTokener;

import javax.xml.bind.DatatypeConverter;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.zip.GZIPInputStream;

public class DataApiMessagesQueryExample {

    public static void main(String[] args) throws Exception {

        String databaseUrl = "http://10.102.0.6:8088";
        String userName = "axibase";
        String password = "********";
        String query = "[{\"startDate\": \"current_day\",\"endDate\":\"now\",\"limit\":3}]";

        System.out.println("Execute messages query:\r\n" + query);

        URL url = new URL(databaseUrl + "/api/v1/messages/query");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        System.out.println("Connection established to " + databaseUrl);

        conn.setDoOutput(true);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("charset", "utf-8");
        conn.setRequestProperty("Accept-Encoding", "gzip");
        conn.setRequestProperty("Content-Type", "application/json");

        String authString = userName + ":" + password;
        String authEncoded = DatatypeConverter.printBase64Binary(authString.getBytes(StandardCharsets.UTF_8));
        conn.setRequestProperty("Authorization", "Basic " + authEncoded);
        byte[] payload = query.getBytes(StandardCharsets.UTF_8);

        conn.setUseCaches(false);

        try (DataOutputStream wr = new DataOutputStream(conn.getOutputStream())) {
            wr.write(payload);

            System.out.println("Request sent");

            int code = conn.getResponseCode();

            System.out.println("Response code: " + code);

            if (code == HttpURLConnection.HTTP_OK) {
                try (InputStreamReader reader = "gzip".equals(conn.getContentEncoding()) ? new InputStreamReader(new GZIPInputStream(conn.getInputStream()), StandardCharsets.UTF_8) : new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8)) {
                    JSONTokener tokener = new JSONTokener(reader);
                    JSONArray resultArray = new JSONArray(tokener);

                    for (int i = 0; i < resultArray.length(); i++) {
                        JSONObject msg = (JSONObject) resultArray.get(i);

                        System.out.println("message: entity= " + msg.get("entity") + " : type= " + msg.get("type") + " : source= " + msg.get("source") + " : severity= " + msg.get("severity") + " : date= " + msg.get("date"));

                        JSONObject tags = (JSONObject) msg.get("tags");

                        System.out.println("    tags= " + tags);
                        System.out.println("    message = " + msg.get("message"));
                    }
                }


            } else {
                System.out.println(conn.getResponseMessage());
            }

        }
    }
}
