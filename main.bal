bal openapi -i openapi-spec.yaml --mode service -o server

import ballerina/http;
import ballerina/graphql;
import ballerina/io;

// Constants for server connection
const string serverURL = "http://localhost:9090/graphql";
const string adminUsername = "admin";
const string adminPassword = "password";

// Constants for API requests
const string getEmployeeScore = """
    query getEmployeeScore($id: string) {
        getEmployeeScore(id: $id)
    }
    """;

const string createDepartmentObjectives = """
    mutation createDepartmentObjectives($department: string, $objectives: [string]) {
        createDepartmentObjectives(department: $department, objectives: $objectives)
    }
    """;

// Main function to demonstrate the GraphQL client usage
public function main() {
    http:Client client = check new http:Client();
    client->auth = {
        username: adminUsername,
        password: adminPassword
    };

    graphql:Client graphqlClient = check new graphql:Client(client, serverURL);

    // Create Department Objectives
    string department = "Computer Science";
    string[] objectives = ["100 Published Research Papers", "20 National Projects", "5 International Collaborations"];
    graphql:Request request = {
        document: createDepartmentObjectives,
        variables: { "department": department, "objectives": objectives }
    };
    var result = check graphqlClient->executeRequest(request);
    io:println("Department Objectives Created: ", result);

    // Get Employee Score
    string employeeId = "E1001";
    graphql:Request request2 = {
        document: getEmployeeScore,
        variables: { "id": employeeId }
    };
    var result2 = check graphqlClient->executeRequest(request2);
    io:println("Employee Score: ", result2);
}