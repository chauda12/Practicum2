import java.io.BufferedReader;
import java.io.FileReader;

import static java.sql.Types.NULL;

public class InsertCrew{

    public static void main(String[] arg) throws Exception {

        Crew crew = new Crew();
        String crew_table = "crew";

        BufferedReader TSVFile = new BufferedReader(new FileReader("title.crew.tsv"));
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


            if(dataArray[1].equals("\\N")){
                dataArray[1] = String.valueOf(NULL);
            }

            if(dataArray[2].equals("\\N")){
                dataArray[2] = String.valueOf(NULL);
            }

            String[] directorArray = dataArray[1].split(",");
            for(String director: directorArray){
                crew.InsertIntoCrew(crew_table, director, dataArray[0], "director");
            }

            String[] writerArray = dataArray[2].split(",");
            for(String writer: writerArray){
                crew.InsertIntoCrew(crew_table, writer, dataArray[0], "writer");
            }

            dataRow = TSVFile.readLine();
        }
        TSVFile.close();
    }
}