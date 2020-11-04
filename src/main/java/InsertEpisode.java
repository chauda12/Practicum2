import java.io.BufferedReader;
import java.io.FileReader;

import static java.sql.Types.NULL;

public class InsertEpisode{

    public static void main(String[] arg) throws Exception {

        Episode episode = new Episode();
        String ratings_table = "episode";

        BufferedReader TSVFile = new BufferedReader(new FileReader("title.episode.tsv"));
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

            episode.insertIntoEpisode(ratings_table, dataArray[0],
                    Integer.parseInt(dataArray[1]), Integer.parseInt(dataArray[2]));

            dataRow = TSVFile.readLine();
        }
        TSVFile.close();
    }
}