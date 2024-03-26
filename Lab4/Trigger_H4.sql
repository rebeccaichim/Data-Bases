CREATE TABLE LogTable (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    ExecutionDateTime DATETIME,
    StatementType CHAR(1), -- 'I' for INSERT, 'U' for UPDATE, 'D' for DELETE
    TableName NVARCHAR(255),
    AffectedRows INT
);



CREATE OR ALTER TRIGGER tr_LogChanges_Feedback
ON Feedback
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @StatementType CHAR(1);
    DECLARE @AffectedRows INT;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        IF EXISTS (SELECT * FROM deleted)
        BEGIN
            SET @StatementType = 'U';
        END
        ELSE
        BEGIN
            SET @StatementType = 'I';
        END

        SET @AffectedRows = (SELECT COUNT(*) FROM inserted);
    END
    ELSE IF EXISTS (SELECT * FROM deleted)
    BEGIN
        SET @StatementType = 'D';
        SET @AffectedRows = (SELECT COUNT(*) FROM deleted);
    END

    INSERT INTO LogTable (ExecutionDateTime, StatementType, TableName, AffectedRows)
    VALUES (GETDATE(), @StatementType, 'Feedback', @AffectedRows);
END;




SELECT * FROM LogTable;
SELECT  * FROM Feedback;


INSERT INTO Feedback(ID_Feedback, Anzahl_der_Sterne, Datum, ID_Kunde, ID_Mitarbeiter)
VALUES (21, 4, '2005-02-04', 4, 1);

INSERT INTO Feedback(ID_Feedback, Anzahl_der_Sterne, Datum, ID_Kunde, ID_Mitarbeiter)
VALUES (24, 3, '2011-05-04', 6, 4),
		(25, 1, '2003-03-16', 8, 2);




UPDATE Feedback
SET Anzahl_der_Sterne = 5
WHERE ID_Feedback = 25;



DELETE FROM Feedback
WHERE ID_Feedback =23 OR ID_Feedback=24;


SELECT * FROM LogTable;