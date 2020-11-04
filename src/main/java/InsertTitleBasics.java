import java.io.BufferedReader;
import java.io.FileReader;

import static java.sql.Types.NULL;

public class InsertTitleBasics{

    public static void main(String[] arg) throws Exception {

        TitleBasics titleBasics = new TitleBasics();
        String title_table = "title";
        String titleGenre_table = "titleGenre";
        String genre_table = "genres";

        BufferedReader TSVFile = new BufferedReader(new FileReader("title.basics.tsv"));
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

            // Insertion into person
            if (dataArray[6].equals("\\N")) {
                titleBasics.insertIntoTitle(title_table, dataArray[0], dataArray[1], dataArray[2], dataArray[3],
                        Boolean.parseBoolean(dataArray[4]), Integer.parseInt(dataArray[5]), NULL,
                        Integer.parseInt(dataArray[7]));
            }

            else {
                titleBasics.insertIntoTitle(title_table, dataArray[0], dataArray[1], dataArray[2], dataArray[3],
                        Boolean.parseBoolean(dataArray[4]), Integer.parseInt(dataArray[5]),
                        Integer.parseInt(dataArray[6]), Integer.parseInt(dataArray[7]));
            }

            // Insert into genre tables
            String[] genreArray = dataArray[8].split(",");
            for(String genre: genreArray){

                // Check to see if genre already exists in table
                if(titleBasics.lookupGenre(genre_table, genre) == 0) {

                    // Genre does not exist, create a row in genre table
                    titleBasics.insertIntoGenres(genre_table, genre);
                }

                titleBasics.insertIntoTitleGenre(titleGenre_table, dataArray[0],
                        titleBasics.lookupGenre(genre_table, genre));
            }

            dataRow = TSVFile.readLine();
        }
        TSVFile.close();
    }
}