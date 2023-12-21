-- Create the database
CREATE DATABASE IF NOT EXISTS elearning;

use elearning;

CREATE TABLE Kelas (
    id_kelas INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nama_kelas VARCHAR(255)
);


CREATE TABLE ModePembelajaran (
    id_mode_pembelajaran INT PRIMARY KEY AUTO_INCREMENT,
    nama_mode_pembelajaran VARCHAR(255)
);

-- Bridging Table
CREATE TABLE Kelas_ModePembelajaran (
    id_kelas INT,
    id_mode_pembelajaran INT,
    PRIMARY KEY (id_kelas, id_mode_pembelajaran),
    FOREIGN KEY (id_kelas) REFERENCES Kelas(id_kelas),
    FOREIGN KEY (id_mode_pembelajaran) REFERENCES ModePembelajaran(id_mode_pembelajaran)
);


CREATE TABLE MataPelajaran (
    id_mata_pelajaran INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nama_mata_pelajaran VARCHAR(255)
);

-- Create Kelas_Mode_Mata bridging table
CREATE TABLE Kelas_Mode_Mata (
    id_kmm INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    id_kelas INT,
    id_mode_pembelajaran INT,
    id_mata_pelajaran INT,
    FOREIGN KEY (id_kelas) REFERENCES Kelas(id_kelas),
    FOREIGN KEY (id_mode_pembelajaran) REFERENCES ModePembelajaran(id_mode_pembelajaran),
    FOREIGN KEY (id_mata_pelajaran) REFERENCES MataPelajaran(id_mata_pelajaran)
);


-- Create Bab table
CREATE TABLE Bab (
    id_bab INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nama_bab VARCHAR(255),
    thumbnail_bab VARCHAR(255),
    count_subbab_gratis INT default 0,
    progression_bar INT default 0
    
);

-- Create Subbab table with a foreign key referencing Bab
CREATE TABLE Subbab (
    id_subbab INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nama_subbab VARCHAR(255),
    thumbnail_subbab VARCHAR(255),
    is_gratis BOOLEAN default 0,
	progression_bar INT default 0,
    id_bab INT,
    FOREIGN KEY (id_bab) REFERENCES Bab(id_bab)
);

-- Create Materi table with a foreign key referencing Subbab
CREATE TABLE Materi (
    id_materi INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nama_materi VARCHAR(255),
    tipe_materi VARCHAR(20) DEFAULT 'Video' CHECK (tipe_materi IN ('End Quiz', 'Single Quiz', 'Summary', 'Video')),
	thumbnail_materi VARCHAR(255),
    reward_xp INT default 0,
    reward_gold INT default 0,
    is_completed BOOLEAN default 0,
    id_subbab INT,
    FOREIGN KEY (id_subbab) REFERENCES Subbab(id_subbab)
);

-- Create KMM_Babs table, to associate kelas_mode_mata (KMM) combinations to babs 
CREATE TABLE KMM_Babs (
    id_kmm INT,
    id_bab INT,
    PRIMARY KEY (id_kmm, id_bab),
    FOREIGN KEY (id_kmm) REFERENCES Kelas_Mode_Mata(id_kmm),
    FOREIGN KEY (id_bab) REFERENCES Bab(id_bab)
);







