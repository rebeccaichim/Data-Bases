CREATE TABLE Mitarbeiter (
    ID_Mitarbeiter INT PRIMARY KEY,
    Name VARCHAR(40),
    Adresse VARCHAR(40),
    Einstellungsdatum DATE,
    Telefonnummer VARCHAR(40),
	Beruf VARCHAR(40)
);

CREATE TABLE Kunden (
    ID_Kunde INT PRIMARY KEY,
    Name VARCHAR(50),
	Adresse VARCHAR(40),
    Telefonnummer VARCHAR(50)
);

CREATE TABLE Feedback (
    ID_Feedback INT PRIMARY KEY,
    Anzahl_der_Sterne INT,
    Datum DATE,
	ID_Kunde INT,
    ID_Mitarbeiter INT,
	FOREIGN KEY (ID_Kunde) REFERENCES Kunden(ID_Kunde),
    FOREIGN KEY (ID_Mitarbeiter) REFERENCES Mitarbeiter(ID_Mitarbeiter)
);

CREATE TABLE Gerichten (
    ID_Gericht INT PRIMARY KEY,
    Name VARCHAR(50),
	Typ VARCHAR(50),
	Preis FLOAT
);
CREATE TABLE Tische (
    ID_Tisch INT PRIMARY KEY,
    Anzahl_der_Personen INT,
);

CREATE TABLE Bestellung_im_Restaurant (
    ID_Bestellung_im_Restaurant INT PRIMARY KEY,
    Preis FLOAT,
    ID_Mitarbeiter INT,
	ID_Tisch INT,
	ID_Gericht INT,
    FOREIGN KEY (ID_Mitarbeiter) REFERENCES Mitarbeiter(ID_Mitarbeiter),
	FOREIGN KEY (ID_Tisch) REFERENCES Tische(ID_Tisch),
	FOREIGN KEY (ID_Gericht) REFERENCES Gerichten(ID_Gericht)
);


CREATE TABLE Kurierfirma (
    ID_Kurierfirma INT PRIMARY KEY,
    Kuriername VARCHAR(50),
	ID_Kurier INT
);

CREATE TABLE Lebensmittel (
    Quantität INT,
    Name_Lebensmittel VARCHAR(50) PRIMARY KEY
);

CREATE TABLE Lebensmittel_im_Essen (
    ID_Gericht INT,
    Name_Lebensmittel VARCHAR(50),
	PRIMARY KEY(ID_Gericht, Name_Lebensmittel),
	FOREIGN KEY (ID_Gericht) REFERENCES Gerichten(ID_Gericht),
	FOREIGN KEY (Name_Lebensmittel) REFERENCES Lebensmittel(Name_Lebensmittel)
);

CREATE TABLE Online_Bestellungen (
    ID_Online_Bestellung INT PRIMARY KEY,
    Adresse VARCHAR(40),
	Preis FLOAT,
	ID_Kunde INT,
	ID_Gericht INT,
	ID_Kurierfirma INT,
	FOREIGN KEY (ID_Kunde) REFERENCES Kunden(ID_Kunde),
	FOREIGN KEY (ID_Gericht) REFERENCES Gerichten(ID_Gericht),
	FOREIGN KEY (ID_Kurierfirma) REFERENCES Kurierfirma(ID_Kurierfirma)
);

CREATE TABLE Spende (
    ID_Spende INT PRIMARY KEY,
    Adresse VARCHAR(40),
	ID_Gericht INT,
	Portionenanzahl INT,
	FOREIGN KEY (ID_Gericht) REFERENCES Gerichten(ID_Gericht)
);

