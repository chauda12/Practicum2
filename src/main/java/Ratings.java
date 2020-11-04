import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Statement;

public class Ratings {

    private Connection connect = null;
    private Statement statement = null;

    private static final String url = "jdbc:mysql://localhost:3306/Practicum2";
    private static final String user = "root";
    private static final String pass = "";

    public void insertIntoRatings(String sql_table, String titleID, double averageRating, int numVotes) {

        try {
            connect = DriverManager.getConnection(url, user, pass);
            statement = connect.createStatement();

            PreparedStatement preparedStatement = connect.prepareStatement("INSERT INTO `" + sql_table +
                    "`(titleID, averageRating, numVotes) " +
                    "VALUES (?, ?, ?)");

            preparedStatement.setString(1, titleID);
            preparedStatement.setDouble(2, averageRating);
            preparedStatement.setInt(3, numVotes);

            preparedStatement.executeUpdate();
            connect.close();

        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
    }
}