import java.sql.*;

public class TitleBasics {

    private Connection connect = null;
    private Statement statement = null;

    private static final String url = "jdbc:mysql://localhost:3306/Practicum2";
    private static final String user = "root";
    private static final String pass = "";

    public void insertIntoTitle(String sql_table, String titleID, String titleType, String primaryTitle,
                                String originalTitle, Boolean isAdult, int startYear, int endYear,
                                int runtimeMinutes) {

        try {
            connect = DriverManager.getConnection(url, user, pass);
            statement = connect.createStatement();

            PreparedStatement preparedStatement = connect.prepareStatement("INSERT INTO `" + sql_table +
                    "`(titleID, titleType, primaryTitle, originalTitle, isAdult, startYear, endYear, runtimeMinutes) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

            preparedStatement.setString(1, titleID);
            preparedStatement.setString(2, titleType);
            preparedStatement.setString(3, primaryTitle);
            preparedStatement.setString(4, originalTitle);
            preparedStatement.setBoolean(5, isAdult);
            preparedStatement.setInt(6, startYear);
            preparedStatement.setInt(7, endYear);
            preparedStatement.setInt(8, runtimeMinutes);


            preparedStatement.executeUpdate();
            connect.close();

        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
    }

    public int lookupGenre(String sql_table, String genreText) {
        try {
            connect = DriverManager.getConnection(url, user, pass);
            statement = connect.createStatement();

            String statement = "SELECT genreID FROM genres WHERE genreText = ?";
            PreparedStatement preparedStatement = connect.prepareStatement(statement);
            preparedStatement.setString(1, genreText);
            ResultSet resultSet = preparedStatement.executeQuery();

            if(resultSet.next()){
                return resultSet.getInt(1);
            }

        } catch (Exception e) {
            System.err.println(e.getMessage());
        }

        return 0;
    }

    public void insertIntoGenres(String sql_table, String genreText){
        try{
            connect = DriverManager.getConnection(url, user, pass);
            statement = connect.createStatement();

            PreparedStatement preparedStatement = connect.prepareStatement("INSERT INTO `" + sql_table +
                    "`(genreText) " +
                    "VALUES (?)");

            preparedStatement.setString(1, genreText);

            preparedStatement.executeUpdate();
            connect.close();

        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
    }

    public void insertIntoTitleGenre(String sql_table, String titleID, String genreID){
        
    }
}