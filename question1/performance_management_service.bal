import ballerina/http;
import ballerina/graphql;
import ballerina/mongodb;

// Define GraphQL schema here
const graphqlSchema = `
    type User {
        user_id: ID!
        first_name: String
        last_name: String
        job_title: String
        position: String
        role: UserRole
        kpis: [KPI]
    }

    type DepartmentObjective {
        objective_id: ID!
        description: String
        weight: Float
    }

    type KPI {
        kpi_id: ID!
        user: User
        objective: DepartmentObjective
        kpi_description: String
        unit: String
        target: Float
        actual_value: Float
    }

    enum UserRole {
        HoD
        Supervisor
        Employee
    }

    type Query {
        getUsers: [User]
        getDepartmentObjectives: [DepartmentObjective]
        getKPIs: [KPI]
    }

    type Mutation {
        createUser(input: UserInput): User
        createDepartmentObjective(input: ObjectiveInput): DepartmentObjective
        createKPI(input: KPIInput): KPI
        assignUserRole(user_id: ID!, role: UserRole): User
        updateKPIValue(kpi_id: ID!, actual_value: Float): KPI
    }

    input UserInput {
        first_name: String
        last_name: String
        job_title: String
        position: String
        role: UserRole
    }

    input ObjectiveInput {
        description: String
        weight: Float
    }

    input KPIInput {
        user_id: ID
        objective_id: ID
        kpi_description: String
        unit: String
        target: Float
        actual_value: Float
    }
`;

// Initialize the MongoDB client
mongodb:Client mongoClient = check new({
    host: config:getAsString("mongodb.uri")
});

// Create a new GraphQL service
graphql:Service performanceManagementService = new({
    schema: graphqlSchema,
    resolvers: [
        public function getUsers(graphql:Context ctx, graphql:SelectionSet selectionSet) returns graphql:SelectionSet {
            mongodb:Collection usersCollection = check mongoClient->getCollection("users");
            json result = check usersCollection->find({});
            return result;
        }

        public function createUser(graphql:Context ctx, graphql:SelectionSet selectionSet, UserInput input) returns User {
             mongodb:Collection usersCollection = check mongoClient->getCollection("users");
            json newUser = check usersCollection->insertOne(input);
            return newUser;
        }

        public function getDepartmentObjectives(graphql:Context ctx, graphql:SelectionSet selectionSet) returns graphql:SelectionSet {
             mongodb:Collection objectivesCollection = check mongoClient->getCollection("objectives");
            json result = check objectivesCollection->find({});
            return result;
        }

        public function createDepartmentObjective(graphql:Context ctx, graphql:SelectionSet selectionSet, ObjectiveInput input) returns DepartmentObjective {
            mongodb:Collection objectivesCollection = check mongoClient->getCollection("objectives");
            json newObjective = check objectivesCollection->insertOne(input);
            return newObjective;
        }

        public function getKPIs(graphql:Context ctx, graphql:SelectionSet selectionSet) returns graphql:SelectionSet {
        mongodb:Collection kpisCollection = check mongoClient->getCollection("kpis");
            json result = check kpisCollection->find({});
            return result;
        }

        public function assignUserRole(graphql:Context ctx, graphql:SelectionSet selectionSet, ID user_id, UserRole role) returns User {
             mongodb:Collection usersCollection = check mongoClient->getCollection("users");
            // Update the user's role
            json updatedUser = check usersCollection->updateOne({"_id": user_id}, {"$set": {"role": role}});
            return updatedUser;
        }

        public function updateKPIValue(graphql:Context ctx, graphql:SelectionSet selectionSet, ID kpi_id, Float actual_value) returns KPI {
            mongodb:Collection kpisCollection = check mongoClient->getCollection("kpis");
            // Update the KPI's actual value
            json updatedKPI = check kpisCollection->updateOne({"_id": kpi_id}, {"$set": {"actual_value": actual_value}});
            return updatedKPI;
        }
    ]
});

public function main() returns error? {
    // Start the Ballerina GraphQL service
    graphql:ServerConfiguration graphqlConfig = { basePath: "/graphql" };
    graphql:Server graphqlServer = new(graphqlConfig, performanceManagementService);
    error? startResult = graphqlServer.start();
    if (startResult is error) {
        log:printError("Error starting the GraphQL service: " + startResult);
        return startResult;
    }
    return null;
}