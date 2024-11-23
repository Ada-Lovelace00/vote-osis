<?php
// Set headers to accept JSON request
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST");

// Database connection settings
$host = 'localhost';
$dbname = 'userdata';  // Change to your database name
$username = 'root';     // Change to your database username
$password = '';         // Change to your database password

// Create database connection
$conn = new mysqli($host, $username, $password, $dbname);

// Check if connection is successful
if ($conn->connect_error) {
    // Send error response with connection failure
    echo json_encode(["message" => "Connection failed: " . $conn->connect_error]);
    http_response_code(500);  // Internal Server Error
    exit;
}

// Get no_paslon from POST request
$no_paslon = isset($_POST['no_paslon']) ? $_POST['no_paslon'] : '';

// Validate no_paslon
if (empty($no_paslon)) {
    echo json_encode(["message" => "No Paslon is required"]);
    http_response_code(400);  // Bad Request
    exit;
}

// SQL query to delete candidate by no_paslon
$sql = "DELETE FROM datacalon WHERE no_paslon = ?";

// Prepare the SQL statement
if ($stmt = $conn->prepare($sql)) {
    // Bind the parameter (s = string)
    $stmt->bind_param('s', $no_paslon);

    // Execute the query
    if ($stmt->execute()) {
        // Check if any row was affected (to ensure the candidate was deleted)
        if ($stmt->affected_rows > 0) {
            echo json_encode(["message" => "Candidate deleted successfully"]);
            http_response_code(200);  // OK
        } else {
            // If no rows were affected, candidate might not exist
            echo json_encode(["message" => "Candidate not found"]);
            http_response_code(404);  // Not Found
        }
    } else {
        echo json_encode(["message" => "Failed to delete candidate"]);
        http_response_code(500);  // Internal Server Error
    }

    // Close the prepared statement
    $stmt->close();
} else {
    echo json_encode(["message" => "Failed to prepare SQL statement"]);
    http_response_code(500);  // Internal Server Error
}

// Close the database connection
$conn->close();
?>
