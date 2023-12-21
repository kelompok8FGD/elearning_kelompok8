-- to check
select * from Kelas;
select * from ModePembelajaran;
select * from MataPelajaran;
select * from Bab;
select * from Subbab;
select * from Materi;

-- Insert data into Kelas table
INSERT INTO Kelas (nama_kelas) VALUES 
("Kelas 1"), ("Kelas 2"), ("Kelas 7");


-- Insert data into ModePembelajaran table
INSERT INTO ModePembelajaran (nama_mode_pembelajaran) VALUES 
("Kurikulum Merdeka"), ("Pembelajaran Tematik");

-- Insert data into ModePembelajaran table
INSERT INTO ModePembelajaran (nama_mode_pembelajaran) VALUES 
("K13 Revisi");

-- Insert data into MataPelajaran table
INSERT INTO MataPelajaran (nama_mata_pelajaran) VALUES 
("Bahasa Indonesia"), ("Pendidikan Karakter");

-- Insert data into Bab table
INSERT INTO Bab (nama_bab) VALUES 
("Mengenal Perasaan"), ("Menjaga Kesehatan"), ("Motivasi");

-- Insert data into Subbab table, associating each Subbab with a Bab
INSERT INTO Subbab (nama_subbab, id_bab) VALUES
('SubBab Example 1', 1), -- Associated with Bab with id 1
('SubBab Example 2', 1), -- Associated with Bab with id 1
('SubBab Example 3', 2); -- Associated with Bab with id 2


-- Insert data into Materi table, associating each Subbab with a Bab
INSERT INTO Materi (nama_materi, id_subbab, tipe_materi) VALUES
('Materi Example 1', 1, 'Summary'), -- Associated with Subbab 1
('Materi Example 2', 2, 'Single Quiz'), -- Associated with Subbab 2
('Materi Example xyz', 2, 'End Quiz'), -- Associated with Subbab 2
('Materi Example 3', 3, 'Video'); -- Associated with Subbab 3


-- Insert data into Kelas_ModePembelajaran table, associating kelas with modes

INSERT INTO Kelas_ModePembelajaran (id_kelas, id_mode_pembelajaran) VALUES
(1, 2), -- Kelas 1 - Pembelajaran Tematik
(2, 2), -- Kelas 2 - Pembelajaran Tematik
(3, 3), -- Kelas 7, - K13
(3, 1); -- Kelas 7, - Kurikulum Merdeka

--  Insert data into Kelas_ModePembelajaran_MataPelajaran table, associating kelas, mode, materi for combinations
INSERT INTO Kelas_Mode_Mata (id_kelas, id_mode_pembelajaran, id_mata_pelajaran) VALUES
(1, 1, 1), -- Kelas 1 - Kurikulum Merdeka - Bahasa Indonesia
(2, 1, 1), -- Kelas 2 - Kurikulum Merdeka - Bahasa Indonesia
(1, 2, 1); -- Kelas 1 - Pembelajaran Tematik - Bahasa Indonesia

INSERT INTO Kelas_Mode_Mata (id_kelas, id_mode_pembelajaran, id_mata_pelajaran) VALUES
(2, 2, 2); -- Kelas 2 - Pembelajaran Tematik - Pendidikan Karakter


-- Insert data into KMM_Babs table, associating each kelas_mode_materi (kmm) combinations with babs
INSERT INTO KMM_Babs (id_kmm, id_bab) VALUES
(3, 2), (1, 1), (2, 3);


-- Retrieving data

-- HALAMAN DEPAN

-- Retrieve list of all the Kelas and their associated modes 
SELECT
    k.nama_kelas,
    mp.nama_mode_pembelajaran
FROM
    Kelas_ModePembelajaran km
LEFT JOIN
    Kelas k ON km.id_kelas = k.id_kelas
LEFT JOIN
    ModePembelajaran mp ON km.id_mode_pembelajaran = mp.id_mode_pembelajaran;
   
 -- HALAMAN LIST OF MATA PELAJARAN  (EXAMPLE USER CHOSE A KELAS AND A MODE)

 -- Retrieve all/ the user's combination of Kelas_Mode and their mata pelajaran.
 -- The contents of materi will be different for every combination of kelas and mode.
SELECT
    km.id_kmm,
    k.nama_kelas,
    mp.nama_mode_pembelajaran,
    mt.nama_mata_pelajaran
FROM
    Kelas_Mode_Mata km
LEFT JOIN
    Kelas k ON km.id_kelas = k.id_kelas
LEFT JOIN
    ModePembelajaran mp ON km.id_mode_pembelajaran = mp.id_mode_pembelajaran
LEFT JOIN
    MataPelajaran mt ON km.id_mata_pelajaran = mt.id_mata_pelajaran
where km.id_kmm = 1;  
-- Example filtering, you can comment it out
   
   -- HALAMAN LIST OF BAB
   
-- Retrieve the mata pelajaran and their babs for all/ filtered kelas and mode combination
SELECT
    KMM_Babs.id_kmm,
    MataPelajaran.nama_mata_pelajaran,
    Bab.nama_bab, Bab.thumbnail_bab, Bab.count_subbab_gratis, Bab.progression_bar
FROM KMM_Babs
left JOIN Kelas_Mode_Mata ON KMM_Babs.id_kmm = Kelas_Mode_Mata.id_kmm
left JOIN MataPelajaran ON Kelas_Mode_Mata.id_mata_pelajaran = MataPelajaran.id_mata_pelajaran
left JOIN Bab ON KMM_Babs.id_bab = Bab.id_bab
where KMM_Babs.id_kmm = 1;  -- Example filtering, you can comment it out

-- HALAMAN LIST OF SUBBAB
-- Retrieve all / filtered SubBabs from their babs
SELECT
    b.nama_bab,
    sb.nama_subbab, sb.thumbnail_subbab, sb.is_gratis, sb.progression_bar
FROM Bab b
LEFT JOIN SubBab sb ON b.id_bab = sb.id_bab
where b.id_bab = 1;  -- Example filtering, you can comment it out


-- HALAMAN LIST OF MATERIAL
-- Retrieve materi info
SELECT
    m.nama_materi, m.thumbnail_materi, m.tipe_materi, m.reward_gold, m.reward_xp, is_completed
FROM SubBab sb
LEFT JOIN Materi m ON sb.id_subbab = m.id_subbab
-- where sb.id_subbab = 1;  -- Example filtering



-- MELAKUKAN PENGETESAN --

-- Contoh Menambahkan nilai 1 pada satu baris teratas pada table subbab kolom is_gratis
UPDATE Subbab
SET is_gratis = 1
WHERE id_subbab IN (1);

-- Update count_subbab_gratis pada table Bab 
UPDATE Bab
SET count_subbab_gratis = (
    SELECT COUNT(is_gratis)
    FROM Subbab
    WHERE Subbab.id_bab = Bab.id_bab and 
    Subbab.is_gratis = 1
);

-- Contoh Menambahkan nilai 1 pada dua baris pada 1 dan 3 table materi kolom is_complete
UPDATE materi
SET is_completed = 1
WHERE id_materi IN (1, 3);

-- Kalkulasi total nilai is_complete lalu dimasukan ke dalam table subbab kolom progression_bar
UPDATE Subbab sb
SET sb.progression_bar = (
    SELECT IFNULL(ROUND((SUM(m.is_completed) / COUNT(m.id_materi)) * 100), 0)
    FROM Materi m
    WHERE m.id_subbab = sb.id_subbab
);

-- Kalkulasi total nilai progresion_bar pada table subbab lalu dimasukan ke dalam table bab kolom progression_bar
UPDATE bab
SET bab.progression_bar = (
    SELECT IFNULL(ROUND((SUM(sb.progression_bar) / COUNT(sb.id_subbab)) * 1), 0)
    FROM subbab sb
    WHERE sb.id_bab = bab.id_bab
);

