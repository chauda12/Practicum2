import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Statement;

public class Principals {

    private Connection connect = null;
    private Statement statement = null;

    private static final String url = "jdbc:mysql://localhost:3306/Practicum2";
    private static final String user = "root";
    private static final String pass = "";

    public void insertIntoPrincipals(String sql_table, String titleID, int ordering, String personID,
                                  String category, String job, String characters) {

        try {
            connect = DriverManager.getConnection(url, user, pass);
            statement = connect.createStatement();

            PreparedStatement preparedStatement = connect.prepareStatement("INSERT INTO `" + sql_table +
                    "`(titleID, ordering, personID, category, job, characters) " +
                    "VALUES (?, ?, ?, ?, ?, ?)");

            preparedStatement.setString(1, titleID);
            preparedStatement.setInt(2, ordering);
            preparedStatement.setString(3, personID);
            preparedStatement.setString(4, category);
            preparedStatement.setString(5, job);
            preparedStatement.setString(6, characters);

            preparedStatement.executeUpdate();
            connect.close();

        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
    }
}