<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");


$host = 'localhost';
$dbname = 'userdata';
$username = 'root';
$password = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed: ' . $e->getMessage()]);
    exit;
}

// Check if `no_paslon` is provided in POST request
if (isset($_POST['no_paslon'])) {
    $no_paslon = $_POST['no_paslon'];

    try {
        // Begin transaction
        $pdo->beginTransaction();

        // Check if candidate exists
        $checkStmt = $pdo->prepare("SELECT * FROM datacalon WHERE no_paslon = :no_paslon");
        $checkStmt->bindParam(':no_paslon', $no_paslon);
        $checkStmt->execute();

        if ($checkStmt->rowCount() > 0) {
            // Increment vote count for the specified candidate
            $updateStmt = $pdo->prepare("UPDATE datacalon SET votes = votes + 1 WHERE no_paslon = :no_paslon");
            $updateStmt->bindParam(':no_paslon', $no_paslon);
            $updateStmt->execute();

            // Commit transaction
            $pdo->commit();
            echo json_encode(['status' => 'success', 'message' => 'Vote added successfully']);
        } else {
            // Rollback transaction if candidate not found
            $pdo->rollBack();
            echo json_encode(['status' => 'error', 'message' => 'Candidate not found']);
        }
    } catch (Exception $e) {
        // Rollback transaction on error
        $pdo->rollBack();
        echo json_encode(['status' => 'error', 'message' => 'Failed to add vote: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'No candidate number provided']);
}

?>
