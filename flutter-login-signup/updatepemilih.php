<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST");

// Database connection parameters
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "userdata";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get the input data
$data = json_decode(file_get_contents("php://input"));

// Check if the required fields are set
if (isset($data->nisn) && isset($data->nama_pemilih) && isset($data->kelas) && isset($data->jurusan)) {

    // Prepare the update query
    $nisn = $data->nisn;
    $nama_pemilih = $data->nama_pemilih;
    $kelas = $data->kelas;
    $jurusan = $data->jurusan;

    // Build the update query (only include the fields provided in the request)
    $query = "UPDATE datapemilih SET nama_pemilih = ?, kelas = ?, jurusan = ? WHERE nisn = ?";

    // Check if token_pemilih is included in the request
    if (isset($data->token_pemilih)) {
        $token_pemilih = $data->token_pemilih;
        $query = "UPDATE datapemilih SET nama_pemilih = ?, kelas = ?, jurusan = ?, token_pemilih = ? WHERE nisn = ?";
    }

    // Prepare and bind parameters
    if ($stmt = $conn->prepare($query)) {
        if (isset($token_pemilih)) {
            $stmt->bind_param("sssss", $nama_pemilih, $kelas, $jurusan, $token_pemilih, $nisn);
        } else {
            $stmt->bind_param("ssss", $nama_pemilih, $kelas, $jurusan, $nisn);
        }

        // Execute the statement
        if ($stmt->execute()) {
            // Return success response
            echo json_encode(["message" => "Voter updated successfully"]);
        } else {
            // Return error if update fails
            echo json_encode(["message" => "Failed to update voter"]);
        }
        $stmt->close();
    } else {
        echo json_encode(["message" => "Failed to prepare statement"]);
    }
} else {
    // Return error if required fields are missing
    echo json_encode(["message" => "Invalid input data"]);
}

$conn->close();
?>
