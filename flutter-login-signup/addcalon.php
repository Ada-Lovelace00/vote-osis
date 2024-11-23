<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// Enable error reporting for debugging
ini_set('display_errors', 1);
error_reporting(E_ALL);

// Database configuration
$host = "localhost";
$db_name = "userdata";
$username = "root";
$password = "";

// Create connection
$conn = new mysqli($host, $username, $password, $db_name);

// Check connection
if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Database connection failed: " . $conn->connect_error]));
}

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $no_paslon = $_POST['no_paslon'];
    $nama_ketos = $_POST['nama_ketos'];
    $nama_waketos = $_POST['nama_waketos'];
    $foto_paslon = $_POST['foto_paslon']; // Base64 encoded image

    // Convert base64 image to binary data
    $foto_paslon_blob = base64_decode($foto_paslon);

    // SQL query to insert a new candidate
    $query = "INSERT INTO datacalon (no_paslon, nama_ketos, nama_waketos, foto_paslon) VALUES (?, ?, ?, ?)";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("ssss", $no_paslon, $nama_ketos, $nama_waketos, $foto_paslon_blob);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Candidate added successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to add candidate: " . $stmt->error]);
    }

    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}

$conn->close();
?>
