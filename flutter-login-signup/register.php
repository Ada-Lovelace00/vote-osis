<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST");

// Koneksi ke database
$db = mysqli_connect('localhost', 'root', '', 'userdata');

// Periksa koneksi
if (!$db) {
    echo json_encode(["status" => "error", "message" => "Database Connection failed"]);
    exit;
}

// Ambil data dari POST
$nisn = $_POST['nisn'] ?? ''; 
$nama_pemilih = $_POST['nama_pemilih'] ?? ''; 
$kelas = $_POST['kelas'] ?? '';
$jurusan = $_POST['jurusan'] ?? '';

// Pastikan semua input terisi
if (empty($nisn) || empty($nama_pemilih) || empty($kelas) || empty($jurusan)) {
    echo json_encode(["status" => "error", "message" => "All fields are required"]);
    exit;
}

// Cek apakah pemilih sudah ada di database
$sql_check = "SELECT * FROM datapemilih WHERE nisn = '$nisn'";
$result_check = mysqli_query($db, $sql_check);

if (mysqli_num_rows($result_check) > 0) {
    echo json_encode(["status" => "error", "message" => "Pemilih already exists"]); // Pemilih already exists
    exit;
}

// Generate token (make sure it's a 6-character string)
$token_pemilih = substr(str_pad(rand(0, 999999), 6, '0', STR_PAD_LEFT), -6); // Generate a random token

// Masukkan pemilih baru ke database
$insert = "INSERT INTO datapemilih (nisn, nama_pemilih, kelas, jurusan, token_pemilih) VALUES ('$nisn', '$nama_pemilih', '$kelas', '$jurusan', '$token_pemilih')";
$query = mysqli_query($db, $insert);

// Periksa apakah query INSERT berhasil
if ($query) {
    echo json_encode(["status" => "success", "message" => "Registration successful"]); // Berhasil mendaftar
} else {
    echo json_encode(["status" => "error", "message" => "Registration failed"]); // Gagal mendaftar
}

// Tutup koneksi
mysqli_close($db);
?>
