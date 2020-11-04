import java.io.BufferedReader;
import java.io.FileReader;

import static java.sql.Types.NULL;

public class InsertAkas{

    public static void main(String[] arg) throws Exception {

        Akas akas = new Akas();
        String titleInfo_table = "titleInfo";
        String mediaType_table = "mediaType";
        String titleMediaType_table = "titleMediaType";
        String attributes_table = "attributes";
        String titleAttributes_table = "titleAttributes";

        BufferedReader TSVFile = new BufferedReader(new FileReader("title.akas.tsv"));
        String[] dataArray;
        String dataRow = TSVFile.readLine();
        dataRow = TSVFile.readLine();

        // while (dataRow != null){
        for(int i = 0; i < 10; i++) {
            dataArray = dataRow.split("\t");


            for(String element: dataArray){
                System.out.println(element);
            }


            akas.InsertIntoTitleInfo(titleInfo_table, dataArray[0], Integer.parseInt(dataArray[1]),
                    dataArray[2], dataArray[3], dataArray[4], Boolean.parseBoolean(dataArray[5]));

            // Insert into genre tables
            String[] mediaArray = dataArray[4].split(",");
            for(String media: mediaArray){

                // Check to see if genre already exists in table
                if(akas.lookupMediaType(mediaType_table, media) == 0) {

                    // Genre does not exist, create a row in genre table
                    akas.insertIntoMediaType(mediaType_table, media);
                }
            }

            dataRow = TSVFile.readLine();
        }
        TSVFile.close();
    }
}