<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
// Database connection
$servername = "localhost";
$username = "root"; // Use your database username
$password = ""; // Use your database password
$dbname = "userdata"; // Use your database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Query to fetch voters
$sql = "SELECT * FROM datapemilih";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $voters = array();
    while($row = $result->fetch_assoc()) {
        $voters[] = $row;
    }
    echo json_encode(['data' => $voters]);
} else {
    echo json_encode(['data' => []]);
}

$conn->close();
?>
