INSERT INTO Mitarbeiter(ID_Mitarbeiter, Name, Adresse, Einstellungsdatum, Telefonnummer, Beruf)
VALUES (1, 'Costica', 'Strada Gustului', '2020-01-01', '0789234281', 'Koch'),
	   (2, 'Mara', 'Strada Curateniei', '2019-03-16', '0725361728', 'Putzfrau'),
	   (3, 'Marcel', 'Strada Bauturii', '2022-12-19', '0731324122', 'Barmann'),
	   (4, 'Ana', 'Strada Servirii', '2021-11-21', '0792123121', 'Kellnerin'),
	   (5, 'Radu', 'Strada Organizarii', '2018-10-16', '0738291745', 'Manager'),
	   (6, 'Mihai', 'Strada Servirii', '2022-11-13', '0738136270', 'Kellner'),
	   (7, 'Aurel', 'Strada Ajutorului', '2020-08-29', '0738172637', 'Kochgehilfe'),
	   (8, 'Maria', 'Strada Servirii', '2021-07-19', '0735462791', 'Kellnerin');

	  
INSERT INTO Kunden(ID_Kunde, Name, Adresse,Telefonnummer)
VALUES (1, 'Iliescu', 'Strada Sperantei', '0721331313'),
	   (2, 'Margeleanu', 'Strada Florii', '0721345672'),
	   (3, 'Popescu', 'Strada Copacului', '0766453918'),
	   (4, 'Vasile', 'Strada Ploii', '0789231980'),
	   (5, 'Marinescu', 'Strada Copiilor', '0788928364'),
	   (6, 'Popa', 'Strada Nucului', '0766389012');

INSERT INTO Feedback(ID_Feedback, Anzahl_der_Sterne, Datum, ID_Kunde, ID_Mitarbeiter)
VALUES (1, 3, '2020-09-19', 1, 5),
	   (2, 5, '2021-08-12', 6, 7),
	   (3, 2, '2023-10-16', 5, 4),
	   (4, 5, '2021-09-08', 4, 2);
	  
INSERT INTO Gerichten(ID_Gericht, Name, Typ, Preis)
VALUES (1, 'Lava cake', 'Dessert', 32),
	   (2, 'Supa de pui', 'Suppe', 21),
	   (3, 'Bruschete', 'Vorspeise', 15),
	   (4, 'Gulasch', 'Hauptgericht', 41),
	   (5, 'Tocanita', 'Hauptgericht', 35),
	   (6, 'Apa', 'Getränke', 7),
	   (7, 'Cola', 'Getränke', 9);

INSERT INTO Kurierfirma(ID_Kurierfirma, Kuriername, ID_Kurier)
VALUES (1, 'Vasile', 3),
	   (2, 'Marcel', 2),
	   (3, 'Costel', 1);

INSERT INTO Lebensmittel(Quantität, Name_Lebensmittel)
VALUES (1, 'apa'),
	   (5, 'bors'),
	   (4.5, 'ciocolata'),
	   (12, 'cola'),
	   (10, 'pui'),
	   (0.5, 'somon'),
	   (6, 'vita');

INSERT INTO Lebensmittel_im_Essen(ID_Gericht, Name_Lebensmittel)
VALUES (1, 'ciocolata'),
	   (2, 'somon'),
	   (3, 'bors'),
	   (4, 'vita'),
	   (5, 'pui'),
	   (6, 'apa'),
	   (7, 'cola');

INSERT INTO Bestellung_im_Restaurant(ID_Bestellung_im_Restaurant, Preis, ID_Mitarbeiter, ID_Tisch, ID_Gericht)
VALUES (1, 26, 6, 1, 3),
	   (2, 35, 4, 2, 5),
	   (3, 109, 2, 3, 2),
	   (4, 48, 2, 6, 1),
	   (5, 278, 4, 7, 4),
	   (6, 321, 6, 2, 2);

INSERT INTO Online_Bestellungen(ID_Online_Bestellung, Adresse, Preis, ID_Kunde, ID_Gericht, ID_Kurierfirma)
VALUES (1, 'Strada Sperantei', 100, 3, 2, 2),
	   (2, 'Strada Client', 289, 1, 6, 1),
	   (3, 'Strada Nucului', 54, 6, 3, 3),
	   (4, 'Strada Joc', 130, 2, 5, 2);

INSERT INTO Spende(ID_Spende, Adresse, ID_Gericht, Portionenanzahl)
VALUES (1, 'Strada Donatiei', 4, 21),
	   (2, 'Strada Bunatatii', 5, 40),
	   (3, 'Strada Donatiei', 1, 10),
	   (4, 'Strada Sperantei', 3, 60);

INSERT INTO Tische(ID_Tisch, Anzahl_der_Personen)
VALUES (1, 2),
	   (2, 4),
	   (3, 6),
	   (4, 10),
	   (5, 8),
	   (6, 2),
	   (7, 2),
	   (8, 4),
	   (9, 4),
	   (10, 6);

--ID_Kunde gresit
	   
INSERT INTO Feedback (ID_Feedback, Anzahl_der_Sterne, Datum, ID_Kunde, ID_Mitarbeiter)
VALUES (2, 3, '2023-03-17', 9, 1);