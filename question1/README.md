Using the GraphQL API
I have created the following queries and mutations in the GraphQL API:

getUsers: Get a list of users.
createUser: Create a new user.
getDepartmentObjectives: Get a list of department objectives.
createDepartmentObjective: Create a new department objective.
getKPIs: Get a list of KPIs.
createKPI: Create a new KPI.
assignUserRole: Assign a role to a user.
updateKPIValue: Update the actual value of a KPI.
For detailed information on the schema and how to use the API, you can refer to the GraphQL schema.

Project Structure
performance_management_service.bal: This is the Ballerina program that sets up the GraphQL service and resolvers.
schema.graphql: It contains the GraphQL schema definition for our API.
ballerina.conf: This is the Ballerina configuration file for setting up MongoDB connection details.