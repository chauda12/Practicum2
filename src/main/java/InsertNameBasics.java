import java.io.BufferedReader;
import java.io.FileReader;

import static java.sql.Types.NULL;

public class InsertNameBasics{

    public static void main(String[] arg) throws Exception {

        Name nameInsertion = new Name();
        String person_table = "person";
        String known_table = "knownFor";
        String personProfession_table = "personProfession";
        String profession_table = "profession";

        BufferedReader TSVFile = new BufferedReader(new FileReader("name.basics.tsv"));
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
            if (dataArray[3].equals("\\N")) {
                nameInsertion.insertIntoPerson(person_table, dataArray[0], dataArray[1], Integer.parseInt(dataArray[2]), NULL);
            }

            else {
                nameInsertion.insertIntoPerson(person_table, dataArray[0], dataArray[1], Integer.parseInt(dataArray[2]), Integer.parseInt(dataArray[3]));
            }

            // Insertion into knownFor
            if(!dataArray[5].equals("\\N")){
                String[] titleArray = dataArray[5].split(",");
                for(String title: titleArray){
                    nameInsertion.insertIntoKnownFor(known_table, dataArray[0], title);
                }
            }

            // Insert into genre tables
            String[] professionArray = dataArray[4].split(",");
            for(String profession: professionArray){

                // Check to see if genre already exists in table
                if(nameInsertion.lookupProfession(profession_table, profession) == 0) {

                    // Genre does not exist, create a row in genre table
                    nameInsertion.insertIntoProfession(profession_table, profession);
                }

                nameInsertion.insertIntoPersonProfession(personProfession_table, dataArray[0],
                        nameInsertion.lookupProfession(profession_table, profession));
            }

            dataRow = TSVFile.readLine();
        }
        TSVFile.close();
    }
}