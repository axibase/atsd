import javax.xml.bind.DatatypeConverter;
import java.io.DataOutputStream;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class DataApiCommandInsertExample {

    public static void main(String[] args) throws Exception {

        String databaseUrl = "http://10.102.0.6:8088";
        String userName = "axibase";
        String password = "********";

        List<String> commands = new ArrayList<String>();
        String host = InetAddress.getLocalHost().getHostName();
        commands.add(String.format("series e:%s ms:%d m:%s=%d", host, System.currentTimeMillis(), "runtime.free.memory", Runtime.getRuntime().freeMemory()));
        //commands.add("series e:" + host + " ms:" + System.currentTimeMillis() + " m:runtime.free.memory=" + Runtime.getRuntime().freeMemory());
        commands.add(String.format("property e:%s ms:%d t:%s v:%s=\"%s\" v:%s=\"%s\"", host, System.currentTimeMillis(), "runtime", "available.processors", Runtime.getRuntime().availableProcessors(), "os.name", System.getProperty("os.name")));

        /*
        series e:nurswgvml101 ms:1470815995166 m:runtime.free.memory=57153512
        property e:nurswgvml101 ms:1470815995170 t:runtime v:available.processors="8" v:os.name="Linux"
        */

        System.out.println("Sending commands: \n" + commands);

        URL url = new URL(databaseUrl + "/api/v1/command");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        System.out.println("Connection established to " + databaseUrl);

        conn.setDoOutput(true);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("charset", "utf-8");
        conn.setRequestProperty("Content-Type", "text/plain");

        String authString = userName + ":" + password;
        String authEncoded = DatatypeConverter.printBase64Binary(authString.getBytes(StandardCharsets.UTF_8));
        conn.setRequestProperty("Authorization", "Basic " + authEncoded);

        String commandString = commands.stream().collect(Collectors.joining(System.lineSeparator()));
        byte[] payload = commandString.getBytes(StandardCharsets.UTF_8);
        conn.setUseCaches(false);

        try (DataOutputStream wr = new DataOutputStream(conn.getOutputStream())) {
            wr.write(payload);

            System.out.println("Request sent");

            int code = conn.getResponseCode();

            System.out.println("Response code: " + code);

            if (code == HttpURLConnection.HTTP_OK) {
                System.out.println("Commands sent");
            } else {
                System.out.println(conn.getResponseMessage());
            }
        }
    }
}
