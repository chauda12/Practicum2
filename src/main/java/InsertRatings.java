import java.io.BufferedReader;
import java.io.FileReader;

import static java.sql.Types.NULL;

public class InsertRatings{

    public static void main(String[] arg) throws Exception {

        Ratings ratings = new Ratings();
        String ratings_table = "rating";

        BufferedReader TSVFile = new BufferedReader(new FileReader("title.ratings.tsv"));
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

            ratings.insertIntoRatings(ratings_table, dataArray[0],
                    Double.parseDouble(dataArray[1]), Integer.parseInt(dataArray[2]));

            dataRow = TSVFile.readLine();
        }
        TSVFile.close();
    }
}