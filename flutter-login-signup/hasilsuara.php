<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *"); // Allow requests from any origin
header("Access-Control-Allow-Methods: GET, OPTIONS"); // Specify allowed HTTP methods
header("Access-Control-Allow-Headers: Content-Type, Authorization"); // Allow certain headers

$host = 'localhost';
$dbname = 'userdata';
$username = 'root';
$password = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    // Return a JSON error response if the database connection fails
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed: ' . $e->getMessage()]);
    exit;
}

try {
    // Fetch voting results from the database
    $stmt = $pdo->prepare("SELECT no_paslon, nama_ketos, nama_waketos, votes FROM datacalon ORDER BY votes DESC");
    $stmt->execute();
    $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Return a JSON response with the voting data
    echo json_encode(['status' => 'success', 'data' => $results]);
} catch (Exception $e) {
    // Return a JSON error response if the data fetching fails
    echo json_encode(['status' => 'error', 'message' => 'Failed to fetch voting results: ' . $e->getMessage()]);
}
?>
