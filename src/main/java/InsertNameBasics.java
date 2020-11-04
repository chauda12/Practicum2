import java.io.BufferedReader;
import java.io.FileReader;

import static java.sql.Types.NULL;

public class InsertNameBasics{

    public static void main(String[] arg) throws Exception {

        Name nameInsertion = new Name();
        String person_table = "person";
        String known_table = "knownFor";

        BufferedReader TSVFile = new BufferedReader(new FileReader("name.basics.tsv"));
        String[] dataArray;
        String dataRow = TSVFile.readLine();
        dataRow = TSVFile.readLine();

        // while (dataRow != null){
        for(int i = 0; i < 10; i++) {
            dataArray = dataRow.split("\t");

            // Insertion into person
            if (dataArray[3].equals("\\N")) {
                nameInsertion.insertIntoPerson(person_table, dataArray[0], dataArray[1], Integer.parseInt(dataArray[2]), NULL);
            }

            else {
                System.out.println(dataArray[2]);
                nameInsertion.insertIntoPerson(person_table, dataArray[0], dataArray[1], Integer.parseInt(dataArray[2]), Integer.parseInt(dataArray[3]));
            }

            // Insertion into knownFor
            if(!dataArray[5].equals("\\N")){
                String[] titleArray = dataArray[5].split(",");
                for(String title: titleArray){
                    nameInsertion.insertIntoKnownFor(known_table, dataArray[0], title);
                }
            }

            dataRow = TSVFile.readLine();
        }
        TSVFile.close();
    }
}