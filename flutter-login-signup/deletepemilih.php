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

// Get nisn from POST request
$nisn = isset($_POST['nisn']) ? $_POST['nisn'] : '';

// Validate nisn
if (empty($nisn)) {
    echo json_encode(["message" => "NISN is required"]);
    http_response_code(400);  // Bad Request
    exit;
}

// SQL query to delete voter by nisn
$sql = "DELETE FROM datapemilih WHERE nisn = ?";

// Prepare the SQL statement
if ($stmt = $conn->prepare($sql)) {
    // Bind the parameter (s = string)
    $stmt->bind_param('s', $nisn);

    // Execute the query
    if ($stmt->execute()) {
        // Check if any row was affected (to ensure the voter was deleted)
        if ($stmt->affected_rows > 0) {
            echo json_encode(["message" => "Voter deleted successfully"]);
            http_response_code(200);  // OK
        } else {
            // If no rows were affected, voter might not exist
            echo json_encode(["message" => "Voter not found"]);
            http_response_code(404);  // Not Found
        }
    } else {
        echo json_encode(["message" => "Failed to delete voter"]);
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
