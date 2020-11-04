import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Statement;

public class Episode {

    private Connection connect = null;
    private Statement statement = null;

    private static final String url = "jdbc:mysql://localhost:3306/Practicum2";
    private static final String user = "root";
    private static final String pass = "";

    public void insertIntoEpisode(String sql_table, String titleID, int seasonNumber, int episodeNumber) {

        try {
            connect = DriverManager.getConnection(url, user, pass);
            statement = connect.createStatement();

            PreparedStatement preparedStatement = connect.prepareStatement("INSERT INTO `" + sql_table +
                    "`(titleID, seasonNumber, episodeNumber) " +
                    "VALUES (?, ?, ?)");

            preparedStatement.setString(1, titleID);
            preparedStatement.setInt(2, seasonNumber);
            preparedStatement.setInt(3, episodeNumber);

            preparedStatement.executeUpdate();
            connect.close();

        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
    }
}