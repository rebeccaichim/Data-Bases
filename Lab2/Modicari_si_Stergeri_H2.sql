-- Modifica adresa pentru Mitarbeiter cu ID 2, care au numele "Mara" sau "Costica"
UPDATE Mitarbeiter
SET Adresse = 'Noua Adresa'
WHERE (Name = 'Mara' OR Name = 'Costica') AND ID_Mitarbeiter = 2;

-- Sterge donatia care are una din cele doua adrese si acel ID
DELETE FROM Spende
WHERE (Adresse = 'Strada Bunatatii' OR Adresse = 'Strada Sperantei') AND ID_Spende=2;

-- Update Feedback cu data 2020-05-03 care are nr de stele != 0
UPDATE Feedback
SET Datum = '2021-03-16'
WHERE Datum = '2020-05-03' AND Anzahl_der_Sterne IS NOT NULL;

-- Sterge Feedbackurile unde data exista si numarul de stele este 5
DELETE FROM Online_Bestellungen
WHERE Preis IS NOT NULL AND ID_Gericht= 2; 

-- Modifica Feedbackurile care au ID 1, 2, 3 astfel incat sa aiba 5 stele
UPDATE Feedback
SET Anzahl_der_Sterne = 5
WHERE ID_Feedback IN (1, 2, 3);

-- Sterge Feedbackurile cu Id 1, 2, 3
DELETE FROM Feedback
WHERE ID_Feedback IN (1, 2, 3);

-- Modifica pretul comenzilor cu ID 4, 5, 6 in 120 
UPDATE Bestellung_im_Restaurant
SET Preis = 120
WHERE ID_Bestellung_im_Restaurant BETWEEN 4 AND 6;

-- Sterge Donatiile cu numarul de portii intre 10 si 30
DELETE FROM Spende
WHERE Portionenanzahl BETWEEN 10 AND 30;

-- Modifica adresa daca numele e Iliescu
UPDATE Kunden
SET Adresse = 'Adresa nouă'
WHERE Name LIKE 'Iliescu%';

-- Sterge clientii cu adresa Strada Copiilor
DELETE FROM Kunden
Where Adresse LIKE 'Strada Copiilor%'