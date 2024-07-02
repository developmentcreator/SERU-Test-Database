//Menampilkan daftar siswa beserta kelas dan guru yang mengajar kelas tersebut
SELECT 
    s.name AS student_name,
    c.name AS class_name,
    t.name AS teacher_name
FROM 
    students s
    JOIN classes c ON s.class_id = c.id
    JOIN teachers t ON c.teacher_id = t.id;

//Menampilkan daftar kelas yang diajar oleh guru yang sama
SELECT 
    c.name AS class_name
FROM 
    classes c
    JOIN teachers t ON c.teacher_id = t.id
WHERE 
    t.name = 'Pak Anton';

//Membuat query view untuk siswa, kelas, dan guru yang mengajar
CREATE VIEW student_class_teacher AS
SELECT 
    s.name AS student_name,
    c.name AS class_name,
    t.name AS teacher_name
FROM 
    students s
    JOIN classes c ON s.class_id = c.id
    JOIN teachers t ON c.teacher_id = t.id;

//Membuat query yang sama tapi menggunakan store_procedure
DELIMITER //
CREATE PROCEDURE student_class_teacher_proc()
BEGIN
    SELECT 
        s.name AS student_name,
        c.name AS class_name,
        t.name AS teacher_name
    FROM 
        students s
        JOIN classes c ON s.class_id = c.id
        JOIN teachers t ON c.teacher_id = t.id;
END //
DELIMITER ;

//Membuat query input, yang akan memberikan warning error jika ada data yang sama pernah masuk
CREATE TRIGGER before_insert_students
BEFORE INSERT ON students
FOR EACH ROW
BEGIN
    DECLARE class_count INT;
    SELECT COUNT(*)
    INTO class_count
    FROM students
    WHERE name = NEW.name AND class_id = NEW.class_id;
    
    IF class_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Duplicate student name in the same class';
    END IF;
END;

