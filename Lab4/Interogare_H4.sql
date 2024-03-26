CREATE OR ALTER VIEW vw_OnlineOrderDetails
AS
SELECT
    ob.ID_Online_Bestellung,
    ob.Adresse,
    ob.Preis,
    k.Name
FROM
    Online_Bestellungen ob
JOIN
    Kunden k ON ob.ID_Kunde = k.ID_Kunde
JOIN
    Gericht_im_Online_Bestellung go ON ob.ID_Online_Bestellung = go.ID_Online_Bestellung;

CREATE OR ALTER FUNCTION fn_GetOnlineOrderDetails
(
    @GerichtTyp VARCHAR(50)
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        ob.ID_Online_Bestellung,
        go.Lieferzeit,
        g.Typ AS GerichtTyp
    FROM
        Online_Bestellungen ob
    JOIN
        Gericht_im_Online_Bestellung go ON ob.ID_Online_Bestellung = go.ID_Online_Bestellung
    JOIN
        Gerichten g ON go.ID_Gericht = g.ID_Gericht
    WHERE
        g.Typ = @GerichtTyp
);

DECLARE @GerichtTyp VARCHAR(50) = 'Suppe';

SELECT DISTINCT
    v.ID_Online_Bestellung AS ID,
    v.Adresse AS Adresse,
    v.Preis AS Preis,
    v.Name AS KundeName,
    f.GerichtLieferzeit AS GerichtLieferzeit,
    f.GerichtTyp AS GerichtTyp
FROM
    vw_OnlineOrderDetails v
JOIN
    fn_GetOnlineOrderDetails(@GerichtTyp) f ON v.ID_Online_Bestellung = f.ID_Online_Bestellung
WHERE
    f.GerichtTyp = @GerichtTyp AND f.GerichtTyp IS NOT NULL;
