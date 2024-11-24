-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 03, 2024 at 08:38 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `userdata`
--

-- --------------------------------------------------------

--
-- Table structure for table `calon`
--

CREATE TABLE `calon` (
  `id` int(11) NOT NULL,
  `nama_calon` varchar(100) NOT NULL,
  `kelas` enum('10','11','12') NOT NULL,
  `jurusan` enum('PPLG','DKV','TJKT','ULP','PM','MPLB','AM') NOT NULL,
  `visi` text DEFAULT NULL,
  `gambar` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `calon`
--

INSERT INTO `calon` (`id`, `nama_calon`, `kelas`, `jurusan`, `visi`, `gambar`) VALUES
(14, 'asdbhahsd', '11', 'DKV', '', 'asdbhahsd.png'),
(16, 'asdbhahsd agdhasd', '11', 'DKV', '', 'asdbhahsd&agdhasd.png'),
(27, 'jadsbhas', '11', 'DKV', 'asdnbas', 'jadsbhas.png'),
(28, 'rayangntng', '11', 'PPLG', 'asjkdasjajsmds', 'rayangntng.png'),
(29, 'Rayan & Rayon', '11', 'PPLG', 'NGntd', 'Rayan___Rayon.png');

-- --------------------------------------------------------

--
-- Table structure for table `datapemilih`
--

CREATE TABLE `datapemilih` (
  `nisn` varchar(10) NOT NULL,
  `nama_pemilih` varchar(100) NOT NULL,
  `kelas` enum('10','11','12') NOT NULL,
  `jurusan` enum('PPLG','DKV','TJKT','ULP','PM','MPLB','AKUNTANSI') NOT NULL,
  `token_pemilih` varchar(6) NOT NULL,
  `status_vote` enum('sudah','belum') DEFAULT 'belum'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `datapemilih`
--

INSERT INTO `datapemilih` (`nisn`, `nama_pemilih`, `kelas`, `jurusan`, `token_pemilih`, `status_vote`) VALUES
('0033', 'rassy', '11', 'PPLG', '33', 'sudah'),
('0044', 'rayon', '11', 'PPLG', '44', 'belum'),
('0067', 'rayanc', '11', 'PPLG', '67', 'belum');

--
-- Triggers `datapemilih`
--
DELIMITER $$
CREATE TRIGGER `after_update_datapemilih` BEFORE UPDATE ON `datapemilih` FOR EACH ROW BEGIN
    -- Update token_pemilih when nisn is updated
    SET NEW.token_pemilih = SUBSTRING(NEW.nisn, 3);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_datapemilih` BEFORE INSERT ON `datapemilih` FOR EACH ROW BEGIN
    -- Create token by removing the first two characters (leading zeros) from nisn
    SET NEW.token_pemilih = SUBSTRING(NEW.nisn, 3);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `dataregister`
--

CREATE TABLE `dataregister` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dataregister`
--

INSERT INTO `dataregister` (`id`, `nama`, `email`, `password`) VALUES
(33, 'RayanAdmin', 'rayanadmin@example.com', '0192023a7bbd73250516f069df18b500'),
(38, 'Rayan', 'rayanadmin4@example.com', 'admin123');

-- --------------------------------------------------------

--
-- Table structure for table `pemilihan`
--

CREATE TABLE `pemilihan` (
  `id` int(11) NOT NULL,
  `id_calon` int(11) DEFAULT NULL,
  `nisn` varchar(10) DEFAULT NULL,
  `nama_pemilih` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `calon`
--
ALTER TABLE `calon`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `datapemilih`
--
ALTER TABLE `datapemilih`
  ADD PRIMARY KEY (`nisn`);

--
-- Indexes for table `dataregister`
--
ALTER TABLE `dataregister`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `pemilihan`
--
ALTER TABLE `pemilihan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_calon` (`id_calon`),
  ADD KEY `nisn` (`nisn`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `calon`
--
ALTER TABLE `calon`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `dataregister`
--
ALTER TABLE `dataregister`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `pemilihan`
--
ALTER TABLE `pemilihan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `pemilihan`
--
ALTER TABLE `pemilihan`
  ADD CONSTRAINT `pemilihan_ibfk_1` FOREIGN KEY (`id_calon`) REFERENCES `calon` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `pemilihan_ibfk_2` FOREIGN KEY (`nisn`) REFERENCES `datapemilih` (`nisn`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
