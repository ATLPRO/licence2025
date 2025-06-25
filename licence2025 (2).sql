-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Jun 25, 2025 at 09:36 AM
-- Server version: 10.1.16-MariaDB
-- PHP Version: 5.5.38

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `licence2025`
--

-- --------------------------------------------------------

--
-- Table structure for table `article`
--

CREATE TABLE `article` (
  `idArt` int(11) NOT NULL,
  `refArt` varchar(8) DEFAULT NULL,
  `desArt` varchar(30) DEFAULT NULL,
  `QteUArt` double DEFAULT NULL,
  `grammage` varchar(5) DEFAULT NULL,
  `pA` double DEFAULT NULL,
  `PV` double DEFAULT NULL,
  `typeArt` varchar(30) DEFAULT NULL,
  `stockMin` double DEFAULT NULL,
  `idFam` int(11) DEFAULT NULL,
  `supprimer` tinyint(1) DEFAULT '0',
  `stockable` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `article`
--

INSERT INTO `article` (`idArt`, `refArt`, `desArt`, `QteUArt`, `grammage`, `pA`, `PV`, `typeArt`, `stockMin`, `idFam`, `supprimer`, `stockable`) VALUES
(4, 'art1', 'pain', 23, 'g', 34, 0, 'produit fini', 0, 6, 1, 1),
(8, 'art2', 'bonbons', 2, 'g', 23, 45, 'produit fini', 24, 6, 0, 1),
(9, 'art3', 'mangue', 2, 'g', 67, 56, 'matiere premiere', 12, 7, 1, 1),
(10, 'art4', 'eau ', 20, 'kg', 23, 43, 'matiere premiere', 43, 6, 1, 1),
(11, 'art001', 'sucre', 8, 'g', 34, 56, 'matiere premiere', 60, 10, 1, 1),
(12, 'ART002', 'tablette', 5, 'kg', 67, 87, 'matiere premiere', 56, 6, 1, 1),
(13, 'ART003', 'carton', 2, 'kg', 45, 56, 'divers', 67, 6, 0, 1),
(14, 'ART004', 'biscuit', 4, 'kg', 45, 67, 'produit fini', 9, 6, 0, 1),
(15, 'ART005', 'chinchin', 50, 'kg', 80, 100, 'produit fini', 8640, 8, 0, 1),
(16, 'ART006', 'farine ble', 30, 'kg', 450, 460, 'matiere premiere', 200, 9, 0, 1),
(17, 'ART007', 'farine plantain', 30, 'kg', 1000, 1100, 'matiere premiere', 200, 11, 0, 1),
(18, 'ART008', 'sucre fin', 30, 'kg', 700, 750, 'matiere premiere', 200, 10, 0, 1),
(19, 'ART009', 'beurre', 30, 'kg', 1250, 1300, 'matiere premiere', 200, 12, 0, 1),
(20, 'ART010', 'arome', 30, 'kg', 10000, 10050, 'matiere premiere', 200, 11, 0, 1),
(21, 'ART011', 'eau', 30, 'L', 375, 400, 'matiere premiere', 200, 11, 0, 1),
(22, 'ART012', 'huile', 30, 'L', 1350, 1400, 'matiere premiere', 200, 11, 0, 1),
(23, 'ART013', 'cartons', 30, 'kg', 15, 15, 'divers', 200, 11, 0, 1),
(24, 'ART014', 'sachet', 30, 'kg', 15, 15, 'divers', 200, 11, 0, 1),
(25, 'ART015', 'cout machine', 1, 'F', 1, 1, 'divers', 1, 11, 0, 0),
(26, 'ART016', 'cout ressources Humaines', 1, 'F', 1, 1, 'divers', 1, 11, 0, 0),
(27, 'ART017', 'cout autres charges', 1, 'F', 1, 1, 'divers', 1, 11, 0, 0),
(28, 'ART018', 'erty', 1, 'G', 5, 8, 'matiere premiere', 9, 6, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `avoir`
--

CREATE TABLE `avoir` (
  `qteA` double DEFAULT NULL,
  `puA` double DEFAULT NULL,
  `idU` int(11) DEFAULT NULL,
  `idArt` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `avoir`
--

INSERT INTO `avoir` (`qteA`, `puA`, `idU`, `idArt`) VALUES
(1, 10, 3, 10),
(1, 1, 3, 9),
(1, 1, 2, 8),
(1, 11, 2, 11),
(1, 500, 2, 12),
(1, 45, 2, 13),
(1, 2, 2, 14),
(1, 100, 4, 15),
(1, 450, 2, 16),
(1, 1000, 2, 17),
(1, 700, 2, 18),
(1, 1250, 2, 19),
(1, 10000, 2, 20),
(1, 375, 3, 21),
(1, 1350, 3, 22),
(1, 5, 4, 23),
(1, 15, 4, 24),
(1, 1.85879628, 5, 25),
(1, 1.157407407, 6, 26),
(1, 0.03295396, 7, 27),
(1, 1, 3, 28);

-- --------------------------------------------------------

--
-- Table structure for table `commande`
--

CREATE TABLE `commande` (
  `idcom` int(11) NOT NULL,
  `numcom` varchar(10) NOT NULL,
  `refcom` varchar(50) NOT NULL,
  `datecom` date DEFAULT NULL,
  `montantTcom` double DEFAULT NULL,
  `idpers` int(11) DEFAULT NULL,
  `idfour` int(11) DEFAULT NULL,
  `supprimer` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `commande`
--

INSERT INTO `commande` (`idcom`, `numcom`, `refcom`, `datecom`, `montantTcom`, `idpers`, `idfour`, `supprimer`) VALUES
(10, 'com01', 'farine', '0025-06-04', 350, 2, 2, 1),
(11, 'com02', 'divers', '2025-06-04', 10, 2, 2, 1),
(12, 'com', 'lait', '0025-06-04', 2, 2, 2, 1),
(13, 'com03', 'fruit', '2025-03-03', 1, 2, 2, 1),
(14, 'com04', 'lait', '2025-03-31', 1000, 2, 1, 1),
(15, 'com05', 'fruit', '2024-09-04', 45, 2, 1, NULL),
(16, 'com6', 'plantai', '2023-04-06', 10, 2, 1, 1),
(18, ' com07', 'eau', '9808-06-07', 130, 2, 1, 1),
(19, 'comm00', 'commande sucre', '2025-06-09', 450, 2, 1, 0),
(25, 'comm001', 'jus citrone', '2025-06-04', 900, 2, 1, 0),
(26, 'COM002', 'sdfghj', '2025-06-11', 13, 2, 2, 1),
(27, 'COM003', 'erty', '2025-06-17', 630, 2, 1, 1),
(28, 'COM004', 'sucre pour biscuit', '2025-06-19', 500, 2, 1, 0),
(29, 'COM005', 'plant', '2025-06-21', 900, 2, 2, 0),
(30, 'COM006', 'farine', '2025-06-22', 1180, 2, 1, 0),
(31, 'COM007', 'div', '2025-06-22', 50, 2, 1, 0),
(32, 'COM008', 'achat pour chinchin', '2025-06-22', 757250, 2, 2, 0);

-- --------------------------------------------------------

--
-- Table structure for table `concerner`
--

CREATE TABLE `concerner` (
  `qteC` double DEFAULT NULL,
  `puC` double DEFAULT NULL,
  `idcom` int(11) DEFAULT NULL,
  `idArt` int(11) DEFAULT NULL,
  `idmag` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `concerner`
--

INSERT INTO `concerner` (`qteC`, `puC`, `idcom`, `idArt`, `idmag`) VALUES
(10, 14, 10, 10, NULL),
(14, 15, 10, 9, NULL),
(1, 1, 12, 10, NULL),
(1, 1, 12, 9, NULL),
(20, 50, 14, 10, NULL),
(3, 15, 15, 9, NULL),
(1, 10, 16, 10, NULL),
(12, 10, NULL, 10, NULL),
(1, 1, NULL, 9, NULL),
(12, 10, NULL, 10, NULL),
(1, 1, NULL, 9, NULL),
(1, 10, 11, 10, NULL),
(1, 1, 13, 10, NULL),
(13, 10, 18, 10, NULL),
(18, 10, 19, 11, NULL),
(15, 18, 19, 10, NULL),
(20, 30, 25, 10, 1),
(15, 20, 25, 10, 1),
(13, 1, 26, 9, 1),
(14, 45, 27, 13, 1),
(50, 10, 28, 11, 1),
(30, 10, 29, 11, 1),
(40, 15, 29, 10, 1),
(37, 10, 30, 11, 1),
(18, 45, 30, 13, 1),
(5, 10, 31, 11, 1),
(50, 450, 32, 16, 1),
(50, 1000, 32, 17, 1),
(50, 700, 32, 18, 1),
(50, 1250, 32, 19, 1),
(50, 10000, 32, 20, 1),
(50, 1350, 32, 22, 1),
(50, 375, 32, 21, 1),
(50, 5, 32, 23, 1),
(50, 15, 32, 24, 1);

--
-- Triggers `concerner`
--
DELIMITER $$
CREATE TRIGGER `maj_stock_apres_insert_concerner` AFTER INSERT ON `concerner` FOR EACH ROW BEGIN
    DECLARE idU_local INT;
    DECLARE ancienne_qte DOUBLE DEFAULT 0;
    DECLARE ancien_cmup DOUBLE DEFAULT 0;
    DECLARE nouvelle_qte DOUBLE;
    DECLARE nouveau_cmup DOUBLE;
    DECLARE stock_existe INT;

        SELECT idU INTO idU_local
    FROM avoir
    WHERE idArt = NEW.idArt
    LIMIT 1;

        SELECT COUNT(*) INTO stock_existe
    FROM stocker
    WHERE idArt = NEW.idArt AND idU = idU_local AND idmag = NEW.idmag;

    IF stock_existe > 0 THEN
                SELECT qteS, cmup INTO ancienne_qte, ancien_cmup
        FROM stocker
        WHERE idArt = NEW.idArt AND idU = idU_local AND idmag = NEW.idmag
        LIMIT 1;

        SET nouvelle_qte = ancienne_qte + NEW.qteC;
        SET nouveau_cmup = ROUND(
            ((ancienne_qte * ancien_cmup) + (NEW.qteC * NEW.puC)) / nouvelle_qte, 2
        );

                UPDATE stocker
        SET qteS = nouvelle_qte, cmup = nouveau_cmup
        WHERE idArt = NEW.idArt AND idU = idU_local AND idmag = NEW.idmag;

    ELSE
                INSERT INTO stocker (idArt, idU, idmag, qteS, cmup)
        VALUES (NEW.idArt, idU_local, NEW.idmag, NEW.qteC, NEW.puC);
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `detailproduction`
--

CREATE TABLE `detailproduction` (
  `idprod` int(11) DEFAULT NULL,
  `idMagSource` int(11) DEFAULT NULL,
  `idMagDest` int(11) DEFAULT NULL,
  `idArt` int(11) DEFAULT NULL,
  `qteP` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `detailproduction`
--

INSERT INTO `detailproduction` (`idprod`, `idMagSource`, `idMagDest`, `idArt`, `qteP`) VALUES
(3, NULL, NULL, 4, 10),
(5, 1, 3, 4, 10),
(6, 1, 3, 4, 10),
(7, 1, 3, 14, 1),
(9, 1, 3, 14, 2),
(10, 1, 3, 8, 2),
(17, 1, 3, 14, 0.2),
(18, 1, 3, 8, 4),
(19, 1, 3, 14, 2),
(20, 1, 3, 15, 1),
(21, 1, 3, 15, 12),
(22, 1, 3, 15, 1);

--
-- Triggers `detailproduction`
--
DELIMITER $$
CREATE TRIGGER `trigger_stock_update` AFTER INSERT ON `detailproduction` FOR EACH ROW BEGIN
  DECLARE idMP INT;
  DECLARE uniteMP INT;
  DECLARE qteParUnite Double;
  DECLARE qteTotalRetirer double;
  DECLARE fini BOOLEAN DEFAULT FALSE;
  DECLARE uniteProduit INT;
  DECLARE stockExiste INT DEFAULT 0;

  -- Variables pour calcul CMUP
  DECLARE coutTotalMP double DEFAULT 0;
  DECLARE cmupAncien double DEFAULT 0;
  DECLARE qteStockAncienne double DEFAULT 0;
  DECLARE cmupNouveau double;
  DECLARE cmupMP double;  -- <-- déclaration déplacée ici

  DECLARE curseur CURSOR FOR
    SELECT n.idArtFils, n.qteN, a.idU
    FROM nomenclature n
    JOIN avoir a ON a.idArt = n.idArtFils
    WHERE n.idArt = NEW.idArt;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fini = TRUE;

  OPEN curseur;

  boucle: LOOP
    FETCH curseur INTO idMP, qteParUnite, uniteMP;
    IF fini THEN
      LEAVE boucle;
    END IF;

    SET qteTotalRetirer = qteParUnite * NEW.qteP;

    -- Récupérer le cmup de la matière première dans stock
    SELECT cmup INTO cmupMP FROM stocker WHERE idArt = idMP AND idU = uniteMP LIMIT 1;

    -- Accumuler le coût total MP = quantité * cmup
    SET coutTotalMP = coutTotalMP + (qteTotalRetirer * IFNULL(cmupMP, 0));

    -- Mettre à jour le stock de la matière première
    UPDATE stocker
    SET qteS = qteS - qteTotalRetirer
    WHERE idArt = idMP AND idU = uniteMP AND idmag = NEW.idMagSource;
  END LOOP;

  CLOSE curseur;

  -- Récupérer l'unité du produit fini
  SELECT idU INTO uniteProduit
  FROM avoir
  WHERE idArt = NEW.idArt
  LIMIT 1;

  -- Vérifier si le stock existe déjà pour le produit fini dans le magasin destination
  SELECT COUNT(*), IFNULL(SUM(qteS), 0) INTO stockExiste, qteStockAncienne
  FROM stocker
  WHERE idArt = NEW.idArt AND idU = uniteProduit AND idmag = NEW.idMagDest;

  IF stockExiste > 0 THEN
    -- Récupérer l'ancien CMUP du produit fini
    SELECT cmup INTO cmupAncien FROM stocker WHERE idArt = NEW.idArt AND idU = uniteProduit AND idmag = NEW.idMagDest LIMIT 1;

    -- Calculer le nouveau CMUP pondéré
    SET cmupNouveau = ((cmupAncien * qteStockAncienne) + coutTotalMP) / (qteStockAncienne + NEW.qteP);

    -- Mettre à jour le stock et le CMUP
    UPDATE stocker
    SET qteS = qteS + NEW.qteP,
        cmup = cmupNouveau
    WHERE idArt = NEW.idArt AND idU = uniteProduit AND idmag = NEW.idMagDest;
  ELSE
    -- Pas de stock existant, insertion avec CMUP calculé
    INSERT INTO stocker(qteS, cmup, idArt, idU, idmag)
    VALUES (NEW.qteP, coutTotalMP / NEW.qteP, NEW.idArt, uniteProduit, NEW.idMagDest);
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `familleart`
--

CREATE TABLE `familleart` (
  `idFam` int(11) NOT NULL,
  `intituleFam` varchar(50) NOT NULL,
  `abreviationFam` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `familleart`
--

INSERT INTO `familleart` (`idFam`, `intituleFam`, `abreviationFam`) VALUES
(6, 'jus', 'jus'),
(7, 'mangue', 'mang'),
(8, 'croquette', 'croq'),
(9, 'farine', 'far'),
(10, 'sucre', 'suc'),
(11, 'divers', 'div'),
(12, 'beurre', 'beur');

-- --------------------------------------------------------

--
-- Table structure for table `fonction`
--

CREATE TABLE `fonction` (
  `idfonc` int(11) NOT NULL,
  `intituleFonc` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `fonction`
--

INSERT INTO `fonction` (`idfonc`, `intituleFonc`) VALUES
(1, 'Directeur'),
(2, 'Comptable');

-- --------------------------------------------------------

--
-- Table structure for table `fournisseur`
--

CREATE TABLE `fournisseur` (
  `idfour` int(11) NOT NULL,
  `codefour` varchar(8) NOT NULL,
  `nomfour` varchar(50) NOT NULL,
  `prenomfour` varchar(30) DEFAULT NULL,
  `tel1four` int(11) NOT NULL,
  `tel2four` int(11) DEFAULT NULL,
  `adressefour` varchar(30) DEFAULT NULL,
  `soldefour` double DEFAULT NULL,
  `cafour` double DEFAULT NULL,
  `soldeinitfour` double DEFAULT NULL,
  `supprimer` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `fournisseur`
--

INSERT INTO `fournisseur` (`idfour`, `codefour`, `nomfour`, `prenomfour`, `tel1four`, `tel2four`, `adressefour`, `soldefour`, `cafour`, `soldeinitfour`, `supprimer`) VALUES
(1, 'four01', 'regal', 'regal', 4567890, 23456789, 'tougan', 23456789, 34567, 98654, 0),
(2, 'four02', 'sogeco', 'ref', 671554034, 89077, 'marche', 1000000, 53678, 564872, 0);

-- --------------------------------------------------------

--
-- Table structure for table `ligneproduction`
--

CREATE TABLE `ligneproduction` (
  `idprod` int(11) NOT NULL,
  `idArt` int(11) NOT NULL,
  `qteL` double DEFAULT NULL,
  `puL` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ligneproduction`
--

INSERT INTO `ligneproduction` (`idprod`, `idArt`, `qteL`, `puL`) VALUES
(17, 11, 3, 10),
(17, 13, 0.2, 45),
(18, 10, 1.8, 10),
(18, 11, 40, 10),
(19, 11, 30, 10),
(19, 13, 2, 45),
(20, 16, 0.011574074, 450),
(20, 17, 0.011574074, 1000),
(20, 18, 0.001736111111, 700),
(20, 19, 0.002893518519, 1250),
(20, 20, 0.000347222222, 10000),
(20, 21, 0.000006365740741, 375),
(20, 22, 0.011574074, 1350),
(20, 23, 1, 5),
(20, 24, 1, 15),
(20, 25, 1, 1.85879628),
(20, 26, 1, 1.157407407),
(20, 27, 1, 0.03295396),
(21, 16, 0.138888888, 450),
(21, 17, 0.138888888, 1000),
(21, 18, 0.020833333332, 700),
(21, 19, 0.034722222228, 1250),
(21, 20, 0.004166666664, 10000),
(21, 21, 0.000076388888892, 375),
(21, 22, 0.138888888, 1350),
(21, 23, 12, 5),
(21, 24, 12, 15),
(21, 25, 12, 1.85879628),
(21, 26, 12, 1.157407407),
(21, 27, 12, 0.03295396),
(22, 16, 0.011574074, 450),
(22, 17, 0.011574074, 1000),
(22, 18, 0.001736111111, 700),
(22, 19, 0.002893518519, 1250),
(22, 20, 0.000347222222, 10000),
(22, 21, 0.000006365740741, 375),
(22, 22, 0.011574074, 1350),
(22, 23, 1, 5),
(22, 24, 1, 15),
(22, 25, 1, 1.85879628),
(22, 26, 1, 1.157407407),
(22, 27, 1, 0.03295396);

-- --------------------------------------------------------

--
-- Table structure for table `lignetransfert`
--

CREATE TABLE `lignetransfert` (
  `idT` int(11) NOT NULL,
  `idArt` int(11) NOT NULL,
  `qteT` int(11) NOT NULL,
  `puT` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lignetransfert`
--

INSERT INTO `lignetransfert` (`idT`, `idArt`, `qteT`, `puT`) VALUES
(1, 13, 2, '45.00');

--
-- Triggers `lignetransfert`
--
DELIMITER $$
CREATE TRIGGER `trg_apres_transfert` AFTER INSERT ON `lignetransfert` FOR EACH ROW BEGIN
  DECLARE magSource INT;
  DECLARE magDest INT;
  DECLARE qteAncienne INT;
  DECLARE cmupAncien double;
  DECLARE qteTotale INT;
  DECLARE cmupNouveau double;

    SELECT idMagSrc, idMagDest INTO magSource, magDest
  FROM transfert
  WHERE idT = NEW.idT;

    UPDATE stocker
  SET qteS = qteS - NEW.qteT
  WHERE idmag = magSource AND idArt = NEW.idArt;

    SELECT qteS, cmup INTO qteAncienne, cmupAncien
  FROM stocker
  WHERE idmag = magDest AND idArt = NEW.idArt
  LIMIT 1;

    IF qteAncienne IS NULL THEN
        INSERT INTO stocker(idmag, idArt, qteS, cmup)
    VALUES (magDest, NEW.idArt, NEW.qteT, NEW.puT);
  ELSE
        SET qteTotale = qteAncienne + NEW.qteT;
    SET cmupNouveau = ((qteAncienne * cmupAncien) + (NEW.qteT * NEW.puT)) / qteTotale;

        UPDATE stocker
    SET qteS = qteTotale,
        cmup = cmupNouveau
    WHERE idmag = magDest AND idArt = NEW.idArt;
  END IF;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `magasin`
--

CREATE TABLE `magasin` (
  `idmag` int(11) NOT NULL,
  `codeMag` varchar(10) DEFAULT NULL,
  `nomMag` varchar(50) DEFAULT NULL,
  `adresseMag` varchar(40) DEFAULT NULL,
  `telMag` int(11) DEFAULT NULL,
  `supprimer` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `magasin`
--

INSERT INTO `magasin` (`idmag`, `codeMag`, `nomMag`, `adresseMag`, `telMag`, `supprimer`) VALUES
(1, 'mag01', 'magasin1', 'TPO', 683447149, 0),
(3, 'mag02', 'magasin2', 'cami toyota', 671554034, 0),
(7, 'mag03', 'magasin3', 'maison', 23456789, 1),
(19, 'MAG00', 'ertyuio', 'tdgjk', 3456789, 1),
(20, 'magF01', 'flutter', 'douala', 23412345, 0),
(21, 'test01', 'recherche', 'baf', 3456, 1),
(22, 'cmg345', 'test', 'vice', 4567, 1),
(23, 'cmg34', 'test', 'terre', 67543423, 0);

-- --------------------------------------------------------

--
-- Table structure for table `nomenclature`
--

CREATE TABLE `nomenclature` (
  `idArt` int(11) NOT NULL,
  `idArtFils` int(11) NOT NULL,
  `qteN` double NOT NULL,
  `puN` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `nomenclature`
--

INSERT INTO `nomenclature` (`idArt`, `idArtFils`, `qteN`, `puN`) VALUES
(4, 10, 1, 1),
(8, 10, 0.45, 10),
(8, 11, 10, 11),
(14, 11, 15, 10),
(14, 13, 1, 45),
(15, 16, 0.011574074, 450),
(15, 17, 0.011574074, 1000),
(15, 18, 0.001736111111, 700),
(15, 19, 0.002893518519, 1250),
(15, 20, 0.000347222222, 10000),
(15, 21, 0.000006365740741, 375),
(15, 22, 0.011574074, 1350),
(15, 23, 1, 5),
(15, 24, 1, 15),
(15, 25, 1, 1.85879628),
(15, 26, 1, 1.157407407),
(15, 27, 1, 0.03295396);

-- --------------------------------------------------------

--
-- Table structure for table `participer`
--

CREATE TABLE `participer` (
  `idprod` int(11) DEFAULT NULL,
  `idpers` int(11) DEFAULT NULL,
  `datePa` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `participer`
--

INSERT INTO `participer` (`idprod`, `idpers`, `datePa`) VALUES
(3, 2, '2025-06-19'),
(5, 2, '2025-06-19'),
(6, 2, '2025-06-19'),
(7, 2, '2025-06-19'),
(9, 2, '2025-06-19'),
(10, 2, '2025-06-19'),
(17, 2, '2025-06-19'),
(18, 2, '2025-06-22'),
(19, 2, '2025-06-22'),
(20, 2, '2025-06-23'),
(21, 2, '2025-06-23'),
(22, 2, '2025-06-23');

-- --------------------------------------------------------

--
-- Table structure for table `personnel`
--

CREATE TABLE `personnel` (
  `idpers` int(11) NOT NULL,
  `matriculePers` varchar(10) NOT NULL,
  `nompers` varchar(50) NOT NULL,
  `prenompers` varchar(50) DEFAULT NULL,
  `datenaispers` date DEFAULT NULL,
  `lieunaispers` varchar(50) DEFAULT NULL,
  `numtelpers` varchar(15) DEFAULT NULL,
  `numcnipers` varchar(10) DEFAULT NULL,
  `datevalidite` date DEFAULT NULL,
  `sexepers` char(1) DEFAULT NULL,
  `statutpers` varchar(15) DEFAULT NULL,
  `idfonc` int(11) DEFAULT NULL,
  `idserv` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL,
  `supprimer` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `personnel`
--

INSERT INTO `personnel` (`idpers`, `matriculePers`, `nompers`, `prenompers`, `datenaispers`, `lieunaispers`, `numtelpers`, `numcnipers`, `datevalidite`, `sexepers`, `statutpers`, `idfonc`, `idserv`, `id`, `supprimer`) VALUES
(1, 'vald001', 'Ndjikend', 'valdo', '2002-07-04', 'Nteingue', '676731980', 'kit258', '2028-12-30', 'M', 'marié', 2, 4, 0, 0),
(2, 'admin01', 'admin', 'admin', '2019-12-19', 'bafoussam', '672722765', 'kit435', '2036-11-12', 'M', 'divers', 1, 5, 1, 0),
(3, 'lea001', 'lea', 'lea', '2002-07-04', 'fombap', '56789876', 'kit258', '2028-12-30', 'f', 'marié', 2, 4, 2, 0);

-- --------------------------------------------------------

--
-- Table structure for table `production`
--

CREATE TABLE `production` (
  `idprod` int(11) NOT NULL,
  `numprod` varchar(10) NOT NULL,
  `refprod` varchar(50) DEFAULT NULL,
  `dateprod` date DEFAULT NULL,
  `coutTprod` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `production`
--

INSERT INTO `production` (`idprod`, `numprod`, `refprod`, `dateprod`, `coutTprod`) VALUES
(3, 'PROD001', '1ere productio', '2025-06-19', 0.1),
(5, 'PROD002', 'asdfg', '2025-06-19', 0.1),
(6, 'PROD003', 'asdfg', '2025-06-19', 0.1),
(7, 'PROD004', 'biscuit', '2025-06-19', 195),
(9, 'PROD005', 'prod biscuit', '2025-06-19', 97.5),
(10, 'PROD006', 'bonbon', '2025-06-19', 52.25),
(17, 'PROD007', 'pro bon', '2025-06-19', 975),
(18, 'PROD008', 'bon', '2025-06-22', 26.125),
(19, 'PROD009', 'test', '2025-06-22', 390),
(20, 'PROD010', 'prodution chinchin', '2025-06-23', 63.763350146228),
(21, 'PROD011', 'chinchin', '2025-06-23', 765.16020175473),
(22, 'PROD012', 'pro chinchin', '2025-06-23', 63.763350146228);

-- --------------------------------------------------------

--
-- Table structure for table `service`
--

CREATE TABLE `service` (
  `idserv` int(11) NOT NULL,
  `intituleServ` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `service`
--

INSERT INTO `service` (`idserv`, `intituleServ`) VALUES
(4, 'Comtabilite'),
(5, 'Direction generale');

-- --------------------------------------------------------

--
-- Table structure for table `stocker`
--

CREATE TABLE `stocker` (
  `qteS` double DEFAULT NULL,
  `cmup` double DEFAULT NULL,
  `idArt` int(11) NOT NULL,
  `idU` int(11) DEFAULT NULL,
  `idmag` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `stocker`
--

INSERT INTO `stocker` (`qteS`, `cmup`, `idArt`, `idU`, `idmag`) VALUES
(38, 54.21, 9, 3, 1),
(114.3, 21.48, 10, 3, 1),
(2, 10, 11, 2, 1),
(24.8, 45, 13, 2, 1),
(10, NULL, 4, NULL, NULL),
(10, 0, 4, NULL, 3),
(10, 0, 4, NULL, 3),
(5.2, 75, 14, 2, 3),
(6, 0, 8, 2, 3),
(49.858425926, 450, 16, 2, 1),
(49.858425926, 1000, 17, 2, 1),
(49.998263888889, 700, 18, 2, 1),
(49.997106481481, 1250, 19, 2, 1),
(49.999652777778, 10000, 20, 2, 1),
(49.858425926, 1350, 22, 3, 1),
(49.99999363425926, 375, 21, 3, 1),
(36, 5, 23, 4, 1),
(36, 15, 24, 4, 1),
(14, 63.90815660708771, 15, 4, 3),
(2, 45, 13, NULL, 3);

-- --------------------------------------------------------

--
-- Table structure for table `transfert`
--

CREATE TABLE `transfert` (
  `idT` int(11) NOT NULL,
  `numT` varchar(15) NOT NULL,
  `dateT` date NOT NULL,
  `idMagSrc` int(11) NOT NULL,
  `idMagDest` int(11) NOT NULL,
  `idpers` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `transfert`
--

INSERT INTO `transfert` (`idT`, `numT`, `dateT`, `idMagSrc`, `idMagDest`, `idpers`) VALUES
(1, 'COM009', '2025-06-16', 1, 3, 2);

-- --------------------------------------------------------

--
-- Table structure for table `uniteart`
--

CREATE TABLE `uniteart` (
  `idU` int(11) NOT NULL,
  `intituleU` varchar(30) NOT NULL,
  `QteU` double NOT NULL,
  `PuU` double NOT NULL,
  `supprimer` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `uniteart`
--

INSERT INTO `uniteart` (`idU`, `intituleU`, `QteU`, `PuU`, `supprimer`) VALUES
(1, 'sac', 1, 1000, 1),
(2, 'Kg*1', 1, 1, 0),
(3, 'L*1', 1, 1, 0),
(4, 'piece*1', 1, 100, 0),
(5, 'CMT', 1, 1, 0),
(6, 'CRH', 1, 1, 0),
(7, 'CACh', 1, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `passwords` varchar(255) NOT NULL,
  `role` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `nom`, `email`, `passwords`, `role`) VALUES
(1, 'admin', 'admin@gmail.com', '2019', 'directeur'),
(2, 'Lea', 'lea@gmail.com', '1234', 'comptable'),
(3, 'regal', 'regal@gmail.com', 'regal', 'directeur');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `article`
--
ALTER TABLE `article`
  ADD PRIMARY KEY (`idArt`),
  ADD UNIQUE KEY `refArt` (`refArt`),
  ADD KEY `idFam` (`idFam`);

--
-- Indexes for table `avoir`
--
ALTER TABLE `avoir`
  ADD KEY `idU` (`idU`),
  ADD KEY `idArt` (`idArt`);

--
-- Indexes for table `commande`
--
ALTER TABLE `commande`
  ADD PRIMARY KEY (`idcom`),
  ADD UNIQUE KEY `numcom` (`numcom`),
  ADD KEY `idfour` (`idfour`),
  ADD KEY `id` (`idpers`);

--
-- Indexes for table `concerner`
--
ALTER TABLE `concerner`
  ADD KEY `idcom` (`idcom`),
  ADD KEY `idArt` (`idArt`);

--
-- Indexes for table `detailproduction`
--
ALTER TABLE `detailproduction`
  ADD KEY `idprod` (`idprod`),
  ADD KEY `idArt` (`idArt`);

--
-- Indexes for table `familleart`
--
ALTER TABLE `familleart`
  ADD PRIMARY KEY (`idFam`);

--
-- Indexes for table `fonction`
--
ALTER TABLE `fonction`
  ADD PRIMARY KEY (`idfonc`);

--
-- Indexes for table `fournisseur`
--
ALTER TABLE `fournisseur`
  ADD PRIMARY KEY (`idfour`),
  ADD UNIQUE KEY `codefour` (`codefour`);

--
-- Indexes for table `ligneproduction`
--
ALTER TABLE `ligneproduction`
  ADD PRIMARY KEY (`idprod`,`idArt`),
  ADD KEY `idArt` (`idArt`);

--
-- Indexes for table `lignetransfert`
--
ALTER TABLE `lignetransfert`
  ADD PRIMARY KEY (`idT`,`idArt`),
  ADD KEY `idArt` (`idArt`);

--
-- Indexes for table `magasin`
--
ALTER TABLE `magasin`
  ADD PRIMARY KEY (`idmag`),
  ADD UNIQUE KEY `codeMag` (`codeMag`);

--
-- Indexes for table `nomenclature`
--
ALTER TABLE `nomenclature`
  ADD PRIMARY KEY (`idArt`,`idArtFils`),
  ADD KEY `fk_article_composant` (`idArtFils`);

--
-- Indexes for table `participer`
--
ALTER TABLE `participer`
  ADD KEY `idprod` (`idprod`),
  ADD KEY `idpers` (`idpers`);

--
-- Indexes for table `personnel`
--
ALTER TABLE `personnel`
  ADD PRIMARY KEY (`idpers`),
  ADD UNIQUE KEY `matriculePers` (`matriculePers`),
  ADD KEY `idfonc` (`idfonc`),
  ADD KEY `idserv` (`idserv`);

--
-- Indexes for table `production`
--
ALTER TABLE `production`
  ADD PRIMARY KEY (`idprod`),
  ADD UNIQUE KEY `numprod` (`numprod`);

--
-- Indexes for table `service`
--
ALTER TABLE `service`
  ADD PRIMARY KEY (`idserv`);

--
-- Indexes for table `stocker`
--
ALTER TABLE `stocker`
  ADD KEY `idU` (`idU`),
  ADD KEY `idmag` (`idmag`);

--
-- Indexes for table `transfert`
--
ALTER TABLE `transfert`
  ADD PRIMARY KEY (`idT`),
  ADD UNIQUE KEY `numT` (`numT`),
  ADD KEY `idMagSrc` (`idMagSrc`),
  ADD KEY `idMagDest` (`idMagDest`),
  ADD KEY `idpers` (`idpers`);

--
-- Indexes for table `uniteart`
--
ALTER TABLE `uniteart`
  ADD PRIMARY KEY (`idU`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `article`
--
ALTER TABLE `article`
  MODIFY `idArt` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;
--
-- AUTO_INCREMENT for table `commande`
--
ALTER TABLE `commande`
  MODIFY `idcom` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;
--
-- AUTO_INCREMENT for table `familleart`
--
ALTER TABLE `familleart`
  MODIFY `idFam` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT for table `fonction`
--
ALTER TABLE `fonction`
  MODIFY `idfonc` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `fournisseur`
--
ALTER TABLE `fournisseur`
  MODIFY `idfour` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `magasin`
--
ALTER TABLE `magasin`
  MODIFY `idmag` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;
--
-- AUTO_INCREMENT for table `personnel`
--
ALTER TABLE `personnel`
  MODIFY `idpers` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `production`
--
ALTER TABLE `production`
  MODIFY `idprod` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;
--
-- AUTO_INCREMENT for table `service`
--
ALTER TABLE `service`
  MODIFY `idserv` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `transfert`
--
ALTER TABLE `transfert`
  MODIFY `idT` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `uniteart`
--
ALTER TABLE `uniteart`
  MODIFY `idU` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `article`
--
ALTER TABLE `article`
  ADD CONSTRAINT `article_ibfk_1` FOREIGN KEY (`idFam`) REFERENCES `familleart` (`idFam`);

--
-- Constraints for table `avoir`
--
ALTER TABLE `avoir`
  ADD CONSTRAINT `avoir_ibfk_1` FOREIGN KEY (`idU`) REFERENCES `uniteart` (`idU`),
  ADD CONSTRAINT `avoir_ibfk_2` FOREIGN KEY (`idArt`) REFERENCES `article` (`idArt`);

--
-- Constraints for table `commande`
--
ALTER TABLE `commande`
  ADD CONSTRAINT `commande_ibfk_1` FOREIGN KEY (`idpers`) REFERENCES `personnel` (`idpers`),
  ADD CONSTRAINT `commande_ibfk_2` FOREIGN KEY (`idfour`) REFERENCES `fournisseur` (`idfour`);

--
-- Constraints for table `concerner`
--
ALTER TABLE `concerner`
  ADD CONSTRAINT `concerner_ibfk_1` FOREIGN KEY (`idcom`) REFERENCES `commande` (`idcom`),
  ADD CONSTRAINT `concerner_ibfk_2` FOREIGN KEY (`idArt`) REFERENCES `article` (`idArt`);

--
-- Constraints for table `detailproduction`
--
ALTER TABLE `detailproduction`
  ADD CONSTRAINT `detailproduction_ibfk_1` FOREIGN KEY (`idprod`) REFERENCES `production` (`idprod`),
  ADD CONSTRAINT `detailproduction_ibfk_2` FOREIGN KEY (`idArt`) REFERENCES `article` (`idArt`);

--
-- Constraints for table `ligneproduction`
--
ALTER TABLE `ligneproduction`
  ADD CONSTRAINT `ligneproduction_ibfk_1` FOREIGN KEY (`idprod`) REFERENCES `production` (`idprod`),
  ADD CONSTRAINT `ligneproduction_ibfk_2` FOREIGN KEY (`idArt`) REFERENCES `article` (`idArt`);

--
-- Constraints for table `lignetransfert`
--
ALTER TABLE `lignetransfert`
  ADD CONSTRAINT `lignetransfert_ibfk_1` FOREIGN KEY (`idT`) REFERENCES `transfert` (`idT`),
  ADD CONSTRAINT `lignetransfert_ibfk_2` FOREIGN KEY (`idArt`) REFERENCES `article` (`idArt`);

--
-- Constraints for table `nomenclature`
--
ALTER TABLE `nomenclature`
  ADD CONSTRAINT `fk_article_composant` FOREIGN KEY (`idArtFils`) REFERENCES `article` (`idArt`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_article_parent` FOREIGN KEY (`idArt`) REFERENCES `article` (`idArt`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `participer`
--
ALTER TABLE `participer`
  ADD CONSTRAINT `participer_ibfk_1` FOREIGN KEY (`idprod`) REFERENCES `production` (`idprod`),
  ADD CONSTRAINT `participer_ibfk_2` FOREIGN KEY (`idpers`) REFERENCES `personnel` (`idpers`);

--
-- Constraints for table `personnel`
--
ALTER TABLE `personnel`
  ADD CONSTRAINT `personnel_ibfk_1` FOREIGN KEY (`idfonc`) REFERENCES `fonction` (`idfonc`),
  ADD CONSTRAINT `personnel_ibfk_2` FOREIGN KEY (`idserv`) REFERENCES `service` (`idserv`);

--
-- Constraints for table `stocker`
--
ALTER TABLE `stocker`
  ADD CONSTRAINT `stocker_ibfk_1` FOREIGN KEY (`idU`) REFERENCES `uniteart` (`idU`),
  ADD CONSTRAINT `stocker_ibfk_2` FOREIGN KEY (`idmag`) REFERENCES `magasin` (`idmag`);

--
-- Constraints for table `transfert`
--
ALTER TABLE `transfert`
  ADD CONSTRAINT `transfert_ibfk_1` FOREIGN KEY (`idMagSrc`) REFERENCES `magasin` (`idmag`),
  ADD CONSTRAINT `transfert_ibfk_2` FOREIGN KEY (`idMagDest`) REFERENCES `magasin` (`idmag`),
  ADD CONSTRAINT `transfert_ibfk_3` FOREIGN KEY (`idpers`) REFERENCES `personnel` (`idpers`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
