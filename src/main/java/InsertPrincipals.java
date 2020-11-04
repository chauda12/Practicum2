import java.io.BufferedReader;
import java.io.FileReader;

import static java.sql.Types.NULL;

public class InsertPrincipals{

    public static void main(String[] arg) throws Exception {

        Principals principals = new Principals();
        String principals_table = "principals";

        BufferedReader TSVFile = new BufferedReader(new FileReader("title.principals.tsv"));
        String[] dataArray;
        String dataRow = TSVFile.readLine();
        dataRow = TSVFile.readLine();

        // while (dataRow != null){
        for(int i = 0; i < 10; i++) {
            dataArray = dataRow.split("\t");

            /*
            for(String element: dataArray){
                System.out.println(element);
            }
             */

            // Job null
            if (dataArray[4].equals("\\N")) {
                dataArray[4] = String.valueOf(NULL);
            }

            // Characters null
            if (dataArray[5].equals("\\N")) {
                dataArray[4] = String.valueOf(NULL);
            }

            principals.insertIntoPrincipals(principals_table, dataArray[0], Integer.parseInt(dataArray[1]),
                    dataArray[2], dataArray[3], dataArray[4], dataArray[5]);

            dataRow = TSVFile.readLine();
        }
        TSVFile.close();
    }
}