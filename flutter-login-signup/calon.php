<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// Aktifkan error reporting untuk debugging
ini_set('display_errors', 1);
error_reporting(E_ALL);

// Konfigurasi database
$host = "localhost"; // Host database
$db_name = "userdata"; // Nama database
$username = "root"; // Username database
$password = ""; // Password database

// Membuat koneksi
$conn = new mysqli($host, $username, $password, $db_name);

// Cek koneksi
if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Koneksi database gagal: " . $conn->connect_error]));
}

// Query SQL untuk mengambil data kandidat
$sql = "SELECT no_paslon, nama_ketos, nama_waketos, foto_paslon FROM datacalon";
$result = $conn->query($sql);

// Menyiapkan array data untuk respons JSON
if ($result->num_rows > 0) {
    $data = [];

    while ($row = $result->fetch_assoc()) {
        $foto_paslon_blob = $row['foto_paslon'];
        $foto_paslon_base64 = '';

        // Periksa apakah foto_paslon berisi data biner yang valid
        if (!empty($foto_paslon_blob)) {
            // Encode gambar biner (LONGBLOB) sebagai base64
            $foto_paslon_base64 = base64_encode($foto_paslon_blob);
        } else {
            $foto_paslon_base64 = ''; // Jika gambar tidak ditemukan
        }

        // Menambahkan data kandidat ke array
        $data[] = [
            "no_paslon" => $row["no_paslon"],
            "nama_ketos" => $row["nama_ketos"], // Nama ketua kandidat
            "nama_waketos" => $row["nama_waketos"], // Nama wakil ketua kandidat
            "foto_paslon" => $foto_paslon_base64, // Gambar dalam format base64 atau kosong jika tidak ada
        ];
    }

    // Mengirimkan data sebagai JSON
    echo json_encode(["status" => "success", "data" => $data]);
} else {
    // Jika tidak ada kandidat ditemukan, kirim pesan error
    echo json_encode(["status" => "error", "message" => "Tidak ada kandidat yang ditemukan"]);
}

// Menutup koneksi
$conn->close();
?>
