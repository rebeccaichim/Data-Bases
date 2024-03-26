CREATE OR ALTER FUNCTION dbo.ValidateFeedbackID
(
    @ID_Feedback INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @isValid BIT = 0

    IF @ID_Feedback > 0
        SET @isValid = 1

    RETURN @isValid
END
GO


CREATE OR ALTER FUNCTION dbo.ValidateAnzahlDerSterne
(
    @Anzahl_der_Sterne INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @isValid BIT = 0

    IF @Anzahl_der_Sterne >= 0 AND @Anzahl_der_Sterne <= 5
        SET @isValid = 1

    RETURN @isValid
END
GO

CREATE OR ALTER PROCEDURE InsertIntoFeedback
    @ID_Feedback INT,
    @Datum DATE,
	@Anzahl_der_Sterne INT,
	@ID_Kunde INT,
	@ID_Mitarbeiter INT
AS
BEGIN
    IF dbo.ValidateFeedbackID(@ID_Feedback) = 0
    BEGIN
        PRINT 'ID-ul feedback-ului nu este valid!'
        RETURN
    END

    IF dbo.ValidateAnzahlDerSterne(@Anzahl_der_Sterne) = 0 
    BEGIN
        PRINT 'Anzahl der Sterne trebuie sa fie intre 0 si 5'
        RETURN
	END

    INSERT INTO Feedback (ID_Feedback, Datum, Anzahl_der_Sterne, ID_Kunde, ID_Mitarbeiter )
    VALUES (@ID_Feedback, @Datum, @Anzahl_der_Sterne, @ID_Kunde, @ID_Mitarbeiter)

    PRINT 'Datele au fost inserate cu succes in tabelul Feedback!'
END
GO

-- Test the stored procedure
EXEC InsertIntoFeedback @ID_Feedback = 26, @Datum = '2023-12-07', @Anzahl_der_Sterne = 3, @ID_Kunde = 2, @ID_Mitarbeiter = 4;

-- View the inserted data
SELECT * FROM Feedback;
SELECT COUNT(*) FROM Feedback;
