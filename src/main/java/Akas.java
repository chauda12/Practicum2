import java.sql.*;

public class Akas {

    private Connection connect = null;
    private Statement statement = null;

    private static final String url = "jdbc:mysql://localhost:3306/Practicum2";
    private static final String user = "root";
    private static final String pass = "";

    public void InsertIntoTitleInfo(String sql_table, String titleID, int ordering, String title,
                                    String region, String language, Boolean isOriginalTitle){

        try{
            connect = DriverManager.getConnection(url, user, pass);
            statement = connect.createStatement();

            PreparedStatement preparedStatement = connect.prepareStatement("INSERT INTO `" + sql_table +
                    "`(titleID, ordering, title, region, language, isOriginalTitle) " +
                    "VALUES (?, ?, ?, ?, ?, ?)");

            preparedStatement.setString(1, titleID);
            preparedStatement.setInt(2, ordering);
            preparedStatement.setString(3, title);
            preparedStatement.setString(4, region);
            preparedStatement.setString(3, language);
            preparedStatement.setBoolean(4, isOriginalTitle);

            preparedStatement.executeUpdate();
            connect.close();

        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
    }

    public int lookupMediaType(String sql_table, String mediaTypeText) {
        try {
            connect = DriverManager.getConnection(url, user, pass);
            statement = connect.createStatement();

            String statement = "SELECT mediaTypeID FROM mediaType WHERE mediaTypeText = ?";
            PreparedStatement preparedStatement = connect.prepareStatement(statement);
            preparedStatement.setString(1, mediaTypeText);
            ResultSet resultSet = preparedStatement.executeQuery();

            if(resultSet.next()){
                return resultSet.getInt(1);
            }

        } catch (Exception e) {
            System.err.println(e.getMessage());
        }

        return 0;
    }

    public void insertIntoMediaType(String sql_table, String mediaTypeText){
        try{
            connect = DriverManager.getConnection(url, user, pass);
            statement = connect.createStatement();

            PreparedStatement preparedStatement = connect.prepareStatement("INSERT INTO `" + sql_table +
                    "`(mediaTypeText) " +
                    "VALUES (?)");

            preparedStatement.setString(1, mediaTypeText);

            preparedStatement.executeUpdate();
            connect.close();

        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
    }

    public void insertIntoTitleMediaType(String sql_table, int titleInfoID, int mediaTypeID){
        try{
            connect = DriverManager.getConnection(url, user, pass);
            statement = connect.createStatement();

            PreparedStatement preparedStatement = connect.prepareStatement("INSERT INTO `" + sql_table +
                    "`(titleInfoID, mediaTypeID) " +
                    "VALUES (?, ?)");

            preparedStatement.setInt(1, titleInfoID);
            preparedStatement.setInt(2, mediaTypeID);

            preparedStatement.executeUpdate();
            connect.close();

        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
    }

    public int lookupAttribute(String sql_table, String attributeText) {
        try {
            connect = DriverManager.getConnection(url, user, pass);
            statement = connect.createStatement();

            String statement = "SELECT attributeID FROM attributes WHERE attributeText = ?";
            PreparedStatement preparedStatement = connect.prepareStatement(statement);
            preparedStatement.setString(1, attributeText);
            ResultSet resultSet = preparedStatement.executeQuery();

            if(resultSet.next()){
                return resultSet.getInt(1);
            }

        } catch (Exception e) {
            System.err.println(e.getMessage());
        }

        return 0;
    }

    public void insertIntoAttributes(String sql_table, String attributeText){
        try{
            connect = DriverManager.getConnection(url, user, pass);
            statement = connect.createStatement();

            PreparedStatement preparedStatement = connect.prepareStatement("INSERT INTO `" + sql_table +
                    "`(attributeText) " +
                    "VALUES (?)");

            preparedStatement.setString(1, attributeText);

            preparedStatement.executeUpdate();
            connect.close();

        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
    }

    public void insertIntoTitleAttribute(String sql_table, int titleInfoID, int attributeID){
        try{
            connect = DriverManager.getConnection(url, user, pass);
            statement = connect.createStatement();

            PreparedStatement preparedStatement = connect.prepareStatement("INSERT INTO `" + sql_table +
                    "`(titleInfoID, attributeID) " +
                    "VALUES (?, ?)");

            preparedStatement.setInt(1, titleInfoID);
            preparedStatement.setInt(2, attributeID);

            preparedStatement.executeUpdate();
            connect.close();

        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
    }

}
