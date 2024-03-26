--1
SELECT k.Name, COUNT(o.ID_Online_Bestellung) AS Anzahl_der_Bestellungen
FROM Kunden k
JOIN Online_Bestellungen o ON k.ID_Kunde = o.ID_Kunde
GROUP BY k.ID_Kunde, k.Name
HAVING COUNT(o.ID_Online_Bestellung) = (
   SELECT MIN(Anzahl_der_Bestellungen)
   FROM (
      SELECT COUNT(ID_Online_Bestellung) AS Anzahl_der_Bestellungen
      FROM Online_Bestellungen
      GROUP BY ID_Kunde
   ) AS Subquery
);

--2
SELECT m.Name, COUNT(br.ID_Bestellung_im_Restaurant) AS Anzahl_der_Bestellungen
FROM Mitarbeiter m
JOIN Bestellung_im_Restaurant br ON m.ID_Mitarbeiter = br.ID_Mitarbeiter
GROUP BY m.ID_Mitarbeiter,m.Name
HAVING COUNT(br.ID_Bestellung_im_Restaurant) >= (
    SELECT AVG(Bestellungsanzahl) FROM (
        SELECT m.ID_Mitarbeiter, COUNT(br.ID_Bestellung_im_Restaurant) AS Bestellungsanzahl
        FROM Mitarbeiter m
        JOIN Bestellung_im_Restaurant br ON m.ID_Mitarbeiter = br.ID_Mitarbeiter
        GROUP BY m.ID_Mitarbeiter
    ) AS Subquery
);

--3
SELECT G.Name
FROM Gerichten G
WHERE G.ID_Gericht IN (
    SELECT ID_Gericht
    FROM Gericht_im_Online_Bestellung
) AND G.ID_Gericht NOT IN (
    SELECT ID_Gericht
    FROM Gericht_im_Bestellung_im_Restaurant
);

--4
SELECT M.Beruf, M.Name, COUNT(BR.ID_Bestellung_im_Restaurant) AS Anzahl_der_Bestellungen
FROM Mitarbeiter M
JOIN Bestellung_im_Restaurant BR ON M.ID_Mitarbeiter = BR.ID_Mitarbeiter
GROUP BY M.Beruf, M.Name
HAVING COUNT(BR.ID_Bestellung_im_Restaurant) = (
    SELECT MAX(Anzahl_der_Bestellungen)
    FROM (
        SELECT COUNT(ID_Bestellung_im_Restaurant) AS Anzahl_der_Bestellungen
        FROM Bestellung_im_Restaurant
        GROUP BY ID_Mitarbeiter
    ) AS Subquery
);

--5
(SELECT K.Name
 FROM Kunden K
 JOIN Feedback F ON K.ID_Kunde = F.ID_Kunde)
UNION
(SELECT K.Name
 FROM Kunden K
 JOIN Online_Bestellungen O ON K.ID_Kunde = O.ID_Kunde);


--6
 (SELECT G.Name
 FROM Gerichten G
 JOIN Gericht_im_Bestellung_im_Restaurant BR ON G.ID_Gericht = BR.ID_Gericht)
INTERSECT
(SELECT G.Name
 FROM Gerichten G
 JOIN Gericht_im_Online_Bestellung BO ON G.ID_Gericht = BO.ID_Gericht);

 --7
SELECT DISTINCT G.Name
FROM Gerichten G
LEFT JOIN Gericht_im_Bestellung_im_Restaurant R ON G.ID_Gericht = R.ID_Gericht
FULL JOIN Gericht_im_Online_Bestellung O ON G.ID_Gericht = O.ID_Gericht;

SELECT DISTINCT G.Name
FROM Gerichten G
INNER JOIN Gericht_im_Bestellung_im_Restaurant R ON G.ID_Gericht = R.ID_Gericht
INNER JOIN Gericht_im_Online_Bestellung O ON G.ID_Gericht = O.ID_Gericht;

--8
SELECT K.Name, OB.Adresse, OB.Preis
FROM Kunden K
JOIN Online_Bestellungen OB ON K.ID_Kunde = OB.ID_Kunde
WHERE OB.Preis >= ALL (SELECT Preis FROM Bestellung_im_Restaurant)
   AND OB.Adresse = ANY (SELECT Adresse FROM Mitarbeiter)
ORDER BY OB.Preis;


--9
SELECT TOP 3 Mitarbeiter.Name
FROM Mitarbeiter
WHERE Mitarbeiter.Beruf = 'Koch'
   OR Mitarbeiter.ID_Mitarbeiter IN (SELECT Feedback.ID_Mitarbeiter FROM Feedback WHERE Anzahl_der_Sterne >= 4)
ORDER BY Mitarbeiter.Name
--10
SELECT M.Name
FROM Mitarbeiter M
JOIN Feedback F ON M.ID_Mitarbeiter = F.ID_Mitarbeiter
WHERE M.Beruf = 'Koch'
   OR M.ID_Mitarbeiter IN (
      SELECT DISTINCT ID_Mitarbeiter
      FROM Feedback
      WHERE Anzahl_der_Sterne > 1
   )
EXCEPT
SELECT M.Name
FROM Mitarbeiter M
JOIN Feedback F ON M.ID_Mitarbeiter = F.ID_Mitarbeiter
WHERE Datum >= '2018-12-12';
