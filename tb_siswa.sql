-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 16, 2024 at 01:50 PM
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
-- Database: `db_osis`
--

-- --------------------------------------------------------

--
-- Table structure for table `tb_siswa`
--

CREATE TABLE `tb_siswa` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama` varchar(50) NOT NULL,
  `id_divisi` bigint(20) UNSIGNED NOT NULL,
  `kelas` int(11) NOT NULL,
  `gender` enum('L','P') NOT NULL,
  `jurusan` varchar(38) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tb_siswa`
--

INSERT INTO `tb_siswa` (`id`, `nama`, `id_divisi`, `kelas`, `gender`, `jurusan`) VALUES
(1, 'salman', 3, 12, 'P', 'PPLG'),
(2, 'kari', 4, 11, 'P', 'PPLG'),
(4, 'Farel', 1, 11, 'L', 'DKV'),
(5, 'Agus', 1, 11, 'L', 'DKV'),
(6, 'Ujang', 1, 11, 'L', 'DKV'),
(8, 'ardi', 2, 11, 'L', 'PPLG'),
(9, 'Risto', 2, 11, 'L', 'DKV'),
(11, 'Agung', 2, 11, 'L', 'DKV'),
(12, 'Ilham', 2, 11, 'L', 'DKV'),
(13, 'jabar', 2, 12, 'L', 'DKV'),
(14, 'salman', 5, 11, 'P', 'PPLG'),
(15, 'King', 3, 11, 'L', 'PPLG'),
(17, 'Habib', 3, 11, 'L', 'PPLG'),
(18, 'Khrisan', 4, 11, 'L', 'PPLG'),
(19, 'Bowo', 4, 11, 'L', 'PPLG'),
(20, 'Garin', 4, 11, 'L', 'PPLG'),
(21, 'Naruto', 6, 11, 'L', 'PPLG');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tb_siswa`
--
ALTER TABLE `tb_siswa`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tb_siswa`
--
ALTER TABLE `tb_siswa`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
