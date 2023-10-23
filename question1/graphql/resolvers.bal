import ballerina/sql;

// Define the database client configuration
endpoint sql:Client dbClient {
    data Source dataSource = {
        driverClassName: "com.mysql.jdbc.Driver",
        url: "jdbc:mysql://<database-host>:<port>/performance_management", // Still need to work on installation of instance
        username: "des",
        password: "123"
    }
};

public function insertUser(User user) returns int {
    // Insert user data into the 'users' table
    int|error result = dbClient->update("INSERT INTO users (first_name, last_name, job_title, position, role) VALUES (?, ?, ?, ?, ?)",
        user.first_name, user.last_name, user.job_title, user.position, user.role);

    if (result is int) {
        return result;
    } else {
        throw result;
    }
}
// Implement other database operations (e.g., objectives, performance records) similarly
