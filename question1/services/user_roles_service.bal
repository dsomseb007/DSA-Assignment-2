import ballerina/http;
import ballerina/io;

service `../../user-role-management` on new http:Listener(8082) {
    resource function post createUserRole(http:Request req, http:Response res) {
        // Add logic to create a user role and store it in a JSON file
        io:println("Creating a user role");
        // Add your data storage logic here
        res.setPayload("User role created");
        checkpanic res.send();
    }
}

