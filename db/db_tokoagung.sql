-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 08 Apr 2020 pada 09.05
-- Versi server: 10.4.11-MariaDB
-- Versi PHP: 7.4.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_tokoagung`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `total_harga_transaksi` ()  BEGIN
SELECT 
SUM(tb_keranjang.jumlah*tb_keranjang.harga) AS total_harga
FROM tb_keranjang;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `admin`
--

INSERT INTO `admin` (`id`, `username`, `password`) VALUES
(1, 'agung', 'agung'),
(2, 'budi', 'budi');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_databarang`
--

CREATE TABLE `tb_databarang` (
  `kode_barang` int(50) NOT NULL,
  `nama_barang` varchar(50) NOT NULL,
  `harga` int(10) NOT NULL,
  `stok` int(10) NOT NULL,
  `tanggal` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `tb_databarang`
--

INSERT INTO `tb_databarang` (`kode_barang`, `nama_barang`, `harga`, `stok`, `tanggal`) VALUES
(2022, 'Mie Goreng', 2500, 1140, '2020-04-04'),
(2023, 'Mie sedap Kuah soto', 2500, 2400, '2020-04-04'),
(2024, 'Gula', 15000, 100, '2020-04-04'),
(2025, 'Aqua Botol 750 ml', 4000, 500, '2020-04-04'),
(2026, 'Aqua Botol 1200 ml', 8000, 498, '2020-04-04'),
(2027, 'Minyak goreng RoseBrand 1 L', 17500, 300, '2020-04-04'),
(2028, 'Teh Kotak', 5000, 200, '2020-04-07'),
(2029, 'Kopi Kapal Api Besar', 12000, 100, '2020-04-07'),
(2030, 'Kopi ABC moka', 2000, 200, '2020-04-07');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_datapetugas`
--

CREATE TABLE `tb_datapetugas` (
  `id_petugas` int(11) NOT NULL,
  `nama_petugas` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `alamat` text NOT NULL,
  `tanggal_pendaftaran` date NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `tb_datapetugas`
--

INSERT INTO `tb_datapetugas` (`id_petugas`, `nama_petugas`, `email`, `alamat`, `tanggal_pendaftaran`, `username`, `password`) VALUES
(1, 'Agung', 'noxuu968@gmail.com', 'Kutai Barat', '2020-03-24', 'agung', '12345');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_keranjang`
--

CREATE TABLE `tb_keranjang` (
  `id_transaksi` int(11) NOT NULL,
  `kode_barang` int(10) NOT NULL,
  `nama_barang` varchar(50) NOT NULL,
  `harga` int(10) NOT NULL,
  `jumlah` int(10) NOT NULL,
  `total_harga` int(10) NOT NULL,
  `tgl_transaksi` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Trigger `tb_keranjang`
--
DELIMITER $$
CREATE TRIGGER `cancel` AFTER DELETE ON `tb_keranjang` FOR EACH ROW BEGIN
UPDATE tb_databarang SET
stok = stok + OLD.jumlah
WHERE kode_barang = OLD.kode_barang;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `cancel_2` AFTER DELETE ON `tb_keranjang` FOR EACH ROW BEGIN
DELETE FROM transaksi
WHERE kode_barang = OLD.kode_barang;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `stok_habis` AFTER INSERT ON `tb_keranjang` FOR EACH ROW BEGIN
DELETE FROM tb_databarang
WHERE stok = 0
AND
kode_barang = NEW.kode_barang;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `transaksi`
--

CREATE TABLE `transaksi` (
  `tgl_transaksi` date NOT NULL,
  `id_transaksi` int(11) NOT NULL,
  `kode_barang` int(50) NOT NULL,
  `nama_barang` varchar(50) NOT NULL,
  `harga` int(11) NOT NULL,
  `jumlah_barang` int(10) NOT NULL,
  `total_harga` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `transaksi`
--

INSERT INTO `transaksi` (`tgl_transaksi`, `id_transaksi`, `kode_barang`, `nama_barang`, `harga`, `jumlah_barang`, `total_harga`) VALUES
('2020-04-08', 27, 2022, 'Mie Goreng', 2500, 2, 5000),
('2020-04-08', 28, 2022, 'Mie Goreng', 2500, 4, 10000),
('2020-04-08', 29, 2022, 'Mie Goreng', 2500, 4, 10000),
('2020-04-08', 30, 2026, 'Aqua Botol 1200 ml', 8000, 2, 16000);

--
-- Trigger `transaksi`
--
DELIMITER $$
CREATE TRIGGER `keranjang` AFTER INSERT ON `transaksi` FOR EACH ROW BEGIN
INSERT INTO tb_keranjang SET
id_transaksi = NEW.id_transaksi,
kode_barang = NEW.kode_barang,
nama_barang = NEW.nama_barang,
harga = NEW.harga,
jumlah = NEW.jumlah_barang,
total_harga = NEW.total_harga,
tgl_transaksi = NEW.tgl_transaksi;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `transaksi` AFTER INSERT ON `transaksi` FOR EACH ROW BEGIN
UPDATE tb_databarang SET
stok = stok - NEW.jumlah_barang
WHERE kode_barang = NEW.kode_barang;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `tb_databarang`
--
ALTER TABLE `tb_databarang`
  ADD PRIMARY KEY (`kode_barang`);

--
-- Indeks untuk tabel `tb_datapetugas`
--
ALTER TABLE `tb_datapetugas`
  ADD PRIMARY KEY (`id_petugas`);

--
-- Indeks untuk tabel `tb_keranjang`
--
ALTER TABLE `tb_keranjang`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `kode_barang` (`kode_barang`);

--
-- Indeks untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `kode_barang` (`kode_barang`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `tb_databarang`
--
ALTER TABLE `tb_databarang`
  MODIFY `kode_barang` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2031;

--
-- AUTO_INCREMENT untuk tabel `tb_datapetugas`
--
ALTER TABLE `tb_datapetugas`
  MODIFY `id_petugas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT untuk tabel `tb_keranjang`
--
ALTER TABLE `tb_keranjang`
  MODIFY `id_transaksi` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id_transaksi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `tb_keranjang`
--
ALTER TABLE `tb_keranjang`
  ADD CONSTRAINT `tb_keranjang_ibfk_1` FOREIGN KEY (`kode_barang`) REFERENCES `tb_databarang` (`kode_barang`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
