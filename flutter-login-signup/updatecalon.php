<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST");
// Enable error reporting
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Database connection
$servername = "localhost"; // Ganti dengan server database Anda
$username = "root"; // Ganti dengan username database Anda
$password = ""; // Ganti dengan password database Anda
$dbname = "userdata"; // Ganti dengan nama database Anda

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Mendapatkan data JSON dari request
$data = json_decode(file_get_contents("php://input"));

// Memeriksa apakah data yang diperlukan ada
if (isset($data->no_paslon) && isset($data->nama_ketos) && isset($data->nama_waketos)) {
    $no_paslon = $conn->real_escape_string($data->no_paslon);
    $nama_ketos = $conn->real_escape_string($data->nama_ketos);
    $nama_waketos = $conn->real_escape_string($data->nama_waketos);

    // Check if foto_paslon is provided
    $foto_paslon = isset($data->foto_paslon) ? $conn->real_escape_string($data->foto_paslon) : null;

    // Query to fetch the current candidate's details
    $query = "SELECT foto_paslon FROM datacalon WHERE no_paslon = ?";
    $stmt = $conn->prepare($query);

    if ($stmt === false) {
        echo json_encode(['message' => 'Failed to prepare the SQL statement', 'error' => $conn->error]);
        exit;
    }

    $stmt->bind_param("s", $no_paslon);
    $stmt->execute();
    $stmt->store_result();

    // Check if candidate exists
    if ($stmt->num_rows === 0) {
        echo json_encode(['message' => 'Candidate not found']);
        exit;
    }

    $stmt->bind_result($existing_photo);
    $stmt->fetch();
    
    // If no new photo is provided, retain the existing photo
    if (is_null($foto_paslon)) {
        $foto_paslon = $existing_photo; // Keep the existing image if not provided
    }

    // Now update the candidate's details with the new names and the (possibly new) photo
    $update_query = "UPDATE datacalon SET nama_ketos = ?, nama_waketos = ?, foto_paslon = ? WHERE no_paslon = ?";
    
    // Prepare update statement
    $update_stmt = $conn->prepare($update_query);
    if ($update_stmt === false) {
        echo json_encode(['message' => 'Failed to prepare the SQL update statement', 'error' => $conn->error]);
        exit;
    }

    // Bind parameters and execute update query
    $update_stmt->bind_param("ssss", $nama_ketos, $nama_waketos, $foto_paslon, $no_paslon);

    if ($update_stmt->execute()) {
        echo json_encode(['message' => 'Candidate updated successfully']);
    } else {
        echo json_encode(['message' => 'Failed to update candidate', 'error' => $update_stmt->error]);
    }

    // Close the update statement
    $update_stmt->close();

    // Close the result fetching statement
    $stmt->close();
} else {
    echo json_encode(['message' => 'Missing required data']);
}

// Close database connection
$conn->close();
?>
