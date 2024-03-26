CREATE TABLE Ta (
    idA INT PRIMARY KEY,
    a2 INT UNIQUE,
	a3 INT
);

CREATE TABLE Tb (
    idB INT PRIMARY KEY,
    b2 INT,
    b3 INT
);


CREATE TABLE Tc (
    idC INT PRIMARY KEY,
    idA INT FOREIGN KEY REFERENCES Ta(idA),
    idB INT FOREIGN KEY REFERENCES Tb(idB)
);


CREATE OR ALTER PROCEDURE InsertData
AS
BEGIN
    DECLARE @count INT = 1;

    WHILE @count <= 10000
    BEGIN
        INSERT INTO Ta (idA, a2,a3)
        VALUES (@count, @count * 2, @count * 5);

        SET @count = @count + 1;
    END

    SET @count = 1;

    WHILE @count <= 3000
    BEGIN
        INSERT INTO Tb (idB, b2, b3)
        VALUES (@count, @count * 3, @count * 4);

        SET @count = @count + 1;
    END

    SET @count = 1;

    WHILE @count <= 30000
    BEGIN
        DECLARE @idA INT, @idB INT;

        SELECT TOP 1 @idA = idA FROM Ta ORDER BY NEWID();
        SELECT TOP 1 @idB = idB FROM Tb ORDER BY NEWID();

        INSERT INTO Tc (idC, idA, idB)
        VALUES (@count, @idA, @idB);

        SET @count = @count + 1;
    END
END;

EXEC InsertData;


SELECT *
FROM Ta
WHERE idA > 0;

SELECT COUNT(*)
FROM Tc

SELECT *
FROM Tb
WHERE idB > 0;

SELECT *
FROM Tc
WHERE idC > 0;

SELECT * FROM Tc WHERE idA = idB;


-- Teil 2

-- a)

EXEC sp_helpindex 'Ta';

SELECT * FROM Ta WHERE idA =2;

SELECT * FROM Ta ORDER BY idA;

SELECT * FROM Ta WHERE a2 BETWEEN 1 AND 10;

SELECT a2 FROM Ta WHERE a2 % 3 =0;



-- b)

SELECT * FROM Ta WHERE idA = 1;


-- c)

SELECT * FROM Tb WHERE b2 = 1212;


DROP INDEX IX_Tb_b2 ON Tb;

CREATE NONCLUSTERED INDEX IX_Tb_b2 ON Tb(b2);


SELECT * FROM Tb WHERE b2 = 1212;

-- d)

SELECT * FROM Tc
INNER JOIN Ta ON Tc.idA = Ta.idA
WHERE Ta.idA = 5660;


SELECT * FROM Tc
INNER JOIN Tb ON Tc.idB = Tb.idB
WHERE Tb.idB = 36; 

DROP INDEX IX_Tc_idA ON Tc;

DROP INDEX IX_Tc_idB ON Tc;


CREATE NONCLUSTERED INDEX IX_Tc_idA ON Tc(idA);

CREATE NONCLUSTERED INDEX IX_Tc_idB ON Tc(idB);


SELECT * FROM Tc
INNER JOIN Ta ON Tc.idA = Ta.idA
WHERE Ta.idA = 5660;


SELECT * FROM Tc
INNER JOIN Tb ON Tc.idB = Tb.idB
WHERE Tb.idB = 36;
