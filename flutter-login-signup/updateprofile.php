<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST");

$host = 'localhost'; // Change this to your database host if necessary
$dbname = 'userdata';
$username = 'root';  // Your database username
$password = '';      // Your database password

// Create a connection
$conn = new mysqli($host, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Database connection failed']));
}

// Get the data from the request
$email = $_POST['email'] ?? '';
$password = $_POST['pass'] ?? '';

// Validate input
if (empty($email) || empty($password)) {
    echo json_encode(['status' => 'error', 'message' => 'Please provide both email and password']);
    exit;
}

// Sanitize input to prevent SQL injection
$email = $conn->real_escape_string($email);
$password = password_hash($password, PASSWORD_BCRYPT); // Hash password for security

// Update query
$sql = "UPDATE dataregister SET pass='$password' WHERE email='$email'";

// Execute the query
if ($conn->query($sql) === TRUE) {
    echo json_encode(['status' => 'success', 'message' => 'Profile updated successfully']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Error updating profile: ' . $conn->error]);
}

// Close connection
$conn->close();
?>
