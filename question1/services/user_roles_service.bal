import ballerina/io;

service /user-roles {
    resource function post createUserRole(json userRole) {
        // Add logic to create a user role
        io:println("Creating a user role");
    }
}
