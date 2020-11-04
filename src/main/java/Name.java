import java.sql.*;

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

    public int lookupProfession(String sql_table, String professionText) {
        try {
            connect = DriverManager.getConnection(url, user, pass);
            statement = connect.createStatement();

            String statement = "SELECT professionID FROM profession WHERE professionText = ?";
            PreparedStatement preparedStatement = connect.prepareStatement(statement);
            preparedStatement.setString(1, professionText);
            ResultSet resultSet = preparedStatement.executeQuery();

            if(resultSet.next()){
                return resultSet.getInt(1);
            }

        } catch (Exception e) {
            System.err.println(e.getMessage());
        }

        return 0;
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

    public void insertIntoPersonProfession(String sql_table, String personID, int professionID){
        try{
            connect = DriverManager.getConnection(url, user, pass);
            statement = connect.createStatement();

            PreparedStatement preparedStatement = connect.prepareStatement("INSERT INTO `" + sql_table +
                    "`(personID, professionID) " +
                    "VALUES (?, ?)");

            preparedStatement.setString(1, personID);
            preparedStatement.setInt(2, professionID);

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
