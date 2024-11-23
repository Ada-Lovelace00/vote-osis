<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST");

// Koneksi ke database
$conn = new mysqli("localhost", "root", "", "userdata");

if ($conn->connect_error) {
    die("Koneksi gagal: " . $conn->connect_error);
}

$email = $_POST['email'];
$pass = $_POST['pass'];

// Query untuk memeriksa NISN dan token
$sql = "SELECT * FROM dataregister WHERE email = ? AND pass = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ss", $email, $pass);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    // Jika ada hasil, login berhasil
    echo json_encode(['status' => 'success', 'message' => 'Login berhasil']);
} else {
    // Jika tidak ada hasil, login gagal
    echo json_encode(['status' => 'error', 'message' => 'email atau password tidak valid.']);
}

$stmt->close();
$conn->close();
?>
