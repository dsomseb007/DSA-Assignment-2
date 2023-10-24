import ballerina/config;
import ballerina/mongodb;

// Initialize the MongoDB client based on configuration
mongodb:Client client = check new({
    host: config:getAsString("mongodb.uri")
});

// Function to query the MongoDB database
public function queryDatabase(string collectionName, json query) returns json {
    // Get the MongoDB collection by name
    mongodb:Collection collection = check client->getCollection(collectionName);
    // Execute the find query
    var result = collection->find(query);
    // Initialize an array to store the query results
    var data = json[];

    // Iterate through the query results
    while (result.hasNext()) {
        // Append each result to the 'data' array
        data.push(result.next());
    }

    // Return the data as a JSON array
    return data;
}
