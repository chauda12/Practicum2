import java.io.BufferedReader;
import java.io.FileReader;
import java.util.Iterator;
import java.util.*;
import java.util.List;

public class TSV_read{

    public static void main(String[] arg) throws Exception {

        BufferedReader TSVFile =
                new BufferedReader(new FileReader("name.basics.tsv"));

        String dataRow = TSVFile.readLine();
        List<String> list = new ArrayList<String>();

        // while (dataRow != null){
        for(int i = 0; i < 10; i++){
            String[] dataArray = dataRow.split("\t");
            for (String element: dataArray){
                System.out.println(element);
            }
            System.out.println(); // Print the data line.
            dataRow = TSVFile.readLine();
        }

        TSVFile.close();

        System.out.println();
    }
}