import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Statement;

public class Crew {

    private Connection connect = null;
    private Statement statement = null;

    private static final String url = "jdbc:mysql://localhost:3306/Practicum2";
    private static final String user = "root";
    private static final String pass = "";

    public void InsertIntoCrew(String sql_table, String personID, String titleID, String job) {

        try {
            connect = DriverManager.getConnection(url, user, pass);
            statement = connect.createStatement();

            PreparedStatement preparedStatement = connect.prepareStatement("INSERT INTO `" + sql_table +
                    "`(personID, titleID, job) " +
                    "VALUES (?, ?, ?)");

            preparedStatement.setString(1, personID);
            preparedStatement.setString(2, titleID);
            preparedStatement.setString(3, job);

            preparedStatement.executeUpdate();
            connect.close();

        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
    }
}