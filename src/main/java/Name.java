import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Statement;

public class Name {

    private Connection connect = null;
    private Statement statement = null;

    private static final String url = "jdbc:mysql://localhost:3306/Practicum2";
    private static final String user = "root";
    private static final String pass = "";

    public void insertIntoPerson(String sql_table, String personID, String primaryName, int birthYear, int deathYear){

        try{
            connect = DriverManager.getConnection(url, user, pass);
            statement = connect.createStatement();

            PreparedStatement preparedStatement = connect.prepareStatement("INSERT INTO `" + sql_table +
                    "`(personID, primaryName, birthYear, deathYear) " +
                    "VALUES (?, ?, ?, ?)");

            preparedStatement.setString(1, personID);
            preparedStatement.setString(2, primaryName);
            preparedStatement.setInt(3, birthYear);
            preparedStatement.setInt(4, deathYear);

            preparedStatement.executeUpdate();
            connect.close();

        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
    }

    public void insertIntoProfession(String sql_table, String professionText){

        try{
            connect = DriverManager.getConnection(url, user, pass);
            statement = connect.createStatement();

            PreparedStatement preparedStatement = connect.prepareStatement("INSERT INTO `" + sql_table +
                    "`(professionText) " +
                    "VALUES (?)");

            preparedStatement.setString(1, professionText);

            preparedStatement.executeUpdate();
            connect.close();

        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
    }

    public void insertIntoKnownFor(String sql_table, String personID, String titleID){
        try{
            connect = DriverManager.getConnection(url, user, pass);
            statement = connect.createStatement();

            PreparedStatement preparedStatement = connect.prepareStatement("INSERT INTO `" + sql_table +
                    "`(personID, titleID) " +
                    "VALUES (?, ?)");

            preparedStatement.setString(1, personID);
            preparedStatement.setString(2, titleID);

            preparedStatement.executeUpdate();
            connect.close();

        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
    }

}
