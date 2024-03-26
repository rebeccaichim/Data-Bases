CREATE OR ALTER PROCEDURE CalculeazaSiActualizeazaMediaPreturilor
AS
BEGIN
    CREATE TABLE #MediiPreturiTemp
    (
        ID_Kunde INT PRIMARY KEY,
        MediaPret FLOAT
    );

    DECLARE @ClientID INT;
    DECLARE @MediaPret FLOAT;

    DECLARE client_cursor CURSOR FOR
    SELECT DISTINCT ID_Kunde
    FROM OnlineBestellung;

    OPEN client_cursor;

    FETCH NEXT FROM client_cursor INTO @ClientID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @MediaPret = AVG(Preis)
        FROM OnlineBestellung
        WHERE ID_Kunde = @ClientID;

        INSERT INTO #MediiPreturiTemp (ID_Kunde, MediaPret)
        VALUES (@ClientID, @MediaPret);

        FETCH NEXT FROM client_cursor INTO @ClientID;
    END

    CLOSE client_cursor;
    DEALLOCATE client_cursor;

    UPDATE o
    SET o.Preis = m.MediaPret
    FROM OnlineBestellung o
    INNER JOIN #MediiPreturiTemp m ON o.ID_Kunde = m.ID_Kunde;

    -- Afișează rezultatele
    SELECT DISTINCT ID_Kunde, Preis
    FROM OnlineBestellung;

    -- Șterge temp table
    DROP TABLE #MediiPreturiTemp;
END;

EXEC CalculeazaSiActualizeazaMediaPreturilor;
