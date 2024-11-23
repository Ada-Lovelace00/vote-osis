<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST");

// Koneksi ke database
$conn = new mysqli("localhost", "root", "", "userdata");

if ($conn->connect_error) {
    die("Koneksi gagal: " . $conn->connect_error);
}

$nisn = $_POST['nisn'];
$token = $_POST['token_pemilih'];

// Query untuk memeriksa NISN dan token
$sql = "SELECT * FROM datapemilih WHERE nisn = ? AND token_pemilih = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ss", $nisn, $token);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    // Jika ada hasil, login berhasil
    echo json_encode(['status' => 'success', 'message' => 'Login berhasil']);
} else {
    // Jika tidak ada hasil, login gagal
    echo json_encode(['status' => 'error', 'message' => 'NISN atau token tidak valid.']);
}

$stmt->close();
$conn->close();
?>
