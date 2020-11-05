package TitleBasics;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

import static java.sql.Types.NULL;

public class InsertTitleBasics{

    private final TitleBasics titleBasics = new TitleBasics();

    private static int counter = 1;

    private void checkForNulls(String[] dataArray){
        // Insertion into person
        if (dataArray[5].equals("\\N")) {
            dataArray[5] = String.valueOf(NULL);
        }

        if (dataArray[6].equals("\\N")) {
            dataArray[6] = String.valueOf(NULL);
        }

        if (dataArray[7].equals("\\N")) {
            dataArray[7] = String.valueOf(NULL);
        }
    }

    private void insertData(String tsv_file) throws IOException {

        BufferedReader TSVFile = new BufferedReader(new FileReader(tsv_file));
        String dataRow = TSVFile.readLine();

        // Header row for first file
        if(counter == 1) {
            dataRow = TSVFile.readLine();
        }

        while (dataRow != null){
        //for (int i = 0; i < 2400; i++) {
            String[] dataArray = dataRow.split("\t");

            this.checkForNulls(dataArray);

            String title_table = "title";
            titleBasics.insertIntoTitle(title_table, dataArray[0], dataArray[1], dataArray[2], dataArray[3],
                    Boolean.parseBoolean(dataArray[4]), Integer.parseInt(dataArray[5]),
                    Integer.parseInt(dataArray[6]), Integer.parseInt(dataArray[7]));


            // Insert into genre tables
            String[] genreArray = dataArray[8].split(",");
            for (String genre : genreArray) {

                genre = genre.toLowerCase();

                // Check to see if genre already exists in table
                String genre_table = "genres";
                if (titleBasics.lookupGenre(genre_table, genre) == 0) {

                    // Genre does not exist, create a row in genre table
                    titleBasics.insertIntoGenres(genre_table, genre);
                }

                String titleGenre_table = "titleGenre";
                titleBasics.insertIntoTitleGenre(titleGenre_table, dataArray[0],
                        titleBasics.lookupGenre(genre_table, genre));
            }

            dataRow = TSVFile.readLine();
        }
        TSVFile.close();
    }

    public static void main(String[] arg) throws Exception {

        InsertTitleBasics insertTitleBasics = new InsertTitleBasics();
        while (counter <= 3045) {

            String header = "C:\\Users\\Matthew Chau\\Desktop\\Practicum2\\title_basic_split\\";
            String footer = "title.basics.tsv";
            String tsv_file = header + counter + footer;
            // Daniel for you it would just be this for now
            // insertTitleBasics.insertData(footer);
            insertTitleBasics.insertData(tsv_file);

            System.out.println("Done with " + counter);
            counter++;
        }
    }
}