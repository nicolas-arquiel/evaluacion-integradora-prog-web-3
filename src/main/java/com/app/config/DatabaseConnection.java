package com.app.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static Connection connection = null;

    private static final String HOST = System.getenv("DB_HOST");
    private static final String PORT = System.getenv("DB_PORT");
    private static final String NAME = System.getenv("DB_NAME");
    private static final String USER = System.getenv("DB_USER");
    private static final String PASSWORD = System.getenv("DB_PASSWORD");

    public static Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            String url = String.format("jdbc:postgresql://%s:%s/%s", HOST, PORT, NAME);

            try {
                Class.forName("org.postgresql.Driver");
            } catch (ClassNotFoundException e) {
                throw new SQLException("No se encontró el driver JDBC de PostgreSQL", e);
            }

            connection = DriverManager.getConnection(url, USER, PASSWORD);
            System.out.println("✅ Conexión exitosa a PostgreSQL en " + url);
        }
        return connection;
    }

    public static void close() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("🔒 Conexión cerrada correctamente");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
