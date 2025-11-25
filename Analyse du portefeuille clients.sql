-- Arsène DJIROUE ,Diplomé Master 2 Finance Quantitative & Data Science

/************************************ ANALYSE DU PORTEFEUILLE CLIENTS ***************************************/

/* OBJECTIF DU PROJET : C'est d'évaluer la performance commerciale et construire un tableau de bord pour le suivi des indicateurs sous POWERBI ****/

/*********************************************** Creation des tables et importation des bases de données**************************************************** */

----------------------------------------------Table Clients
DROP TABLE IF EXISTS Clients;

CREATE TABLE Clients (
    ClientID VARCHAR(10) PRIMARY KEY,
    Nom VARCHAR(100) NOT NULL,
    Prenom VARCHAR(100) NOT NULL,
    DateNaissance DATE,
    Sexe CHAR(1),
    Adresse VARCHAR(255),
    AgenceID VARCHAR(10),
    Profession VARCHAR(100)
);

-- Importer le CSV (séparateur ;)
COPY Clients(ClientID, Nom, Prenom, DateNaissance, Sexe, Adresse, AgenceID, Profession)
FROM 'C:/SQL_PostgreSQL/projet/Clients.csv'
DELIMITER ','
CSV HEADER
ENCODING 'LATIN1';

-- J'affiche la table Clients

SELECT *
FROM Clients;

--------------------------------------------- Table Agences

-- Table Agences
DROP TABLE IF EXISTS Agences;

CREATE TABLE Agences (
    AgenceID VARCHAR(10) PRIMARY KEY,
    NomAgence VARCHAR(150) NOT NULL,
    Region VARCHAR(100),
    Responsable VARCHAR(100)
);

-- Importer le CSV (séparateur ;)
COPY Agences(AgenceID, NomAgence, Region,Responsable)
FROM 'C:\SQL_PostgreSQL\projet\Agences.csv'
DELIMITER ','
CSV HEADER
ENCODING 'LATIN1';

-- J'affiche la table Clients

SELECT *
FROM Agences;

-- -------------------------------------Table Produits
-- Table Produits
DROP TABLE IF EXISTS Produits;

CREATE TABLE Produits (
    ProduitID VARCHAR(10) PRIMARY KEY,
    NomProduit VARCHAR(150) NOT NULL,
    TypeProduit VARCHAR(50),
    PrixBase NUMERIC(10,2)
);

-- Importer le CSV (séparateur ;)
COPY Produits(ProduitID, NomProduit, TypeProduit, PrixBase)
FROM 'C:/SQL_PostgreSQL/projet/Produits.csv'
DELIMITER ','
CSV HEADER
ENCODING 'LATIN1';

-- Affiche la table Produits

SELECT *
FROM Produits;

----------------------------------------------Table Contrats
DROP TABLE IF EXISTS Contrats;

CREATE TABLE Contrats (
    ContratID VARCHAR(10) PRIMARY KEY,
    ClientID VARCHAR(10) REFERENCES Clients(ClientID),
    ProduitID VARCHAR(10) REFERENCES Produits(ProduitID),
    DateSouscription DATE NOT NULL,
    DateExpiration DATE,
    Statut VARCHAR(50) CHECK (Statut IN ('Actif','Résilié','Expiré')),
    PrimeAnnuelle NUMERIC(12,2),
    AgenceID VARCHAR(10) REFERENCES Agences(AgenceID)
);
INSERT INTO Clients (ClientID, Nom, Prenom, DateNaissance, Sexe, Adresse, AgenceID, Profession)
VALUES ('C101', 'NomExemple', 'PrenomExemple', '1990-01-01', 'M', 'Adresse Exemple', 'A001', 'Profession Exemple');
INSERT INTO Contrats (ContratID, ClientID, ProduitID, DateSouscription, DateExpiration, Statut, PrimeAnnuelle, AgenceID)
VALUES ('CT141', 'C101', 'P006', '2020-01-01', '2021-01-01', 'Actif', 480, 'A001');

COPY Contrats(ContratID, ClientID, ProduitID, DateSouscription, DateExpiration, Statut, PrimeAnnuelle, AgenceID)
FROM 'C:\SQL_PostgreSQL\projet\Contrats.csv'
DELIMITER ','
CSV HEADER
ENCODING 'LATIN1';

SELECT *
FROM Contrats;

-- -------------------------------------------------Table Sinistres

CREATE TEMP TABLE tmp_sinistres AS
SELECT * FROM Sinistres LIMIT 0;

COPY tmp_sinistres(SinistreID, ContratID, DateSinistre, TypeSinistre, Montant, Statut, AgenceID)
FROM 'C:/SQL_PostgreSQL/projet/Sinistres.csv'
DELIMITER ','
CSV HEADER
ENCODING 'LATIN1';

INSERT INTO Sinistres
SELECT *
FROM tmp_sinistres
WHERE ContratID IN (SELECT ContratID FROM Contrats);

SELECT *
FROM Sinistres;

---------------------------------------------------------------- Table Agents
DROP TABLE IF EXISTS Agents;

CREATE TABLE Agents (
    AgentID VARCHAR(10) PRIMARY KEY,
    Nom VARCHAR(100) NOT NULL,
    Prenom VARCHAR(100) NOT NULL,
    AgenceID VARCHAR(10) REFERENCES Agences(AgenceID),
    DateEmbauche DATE,
    Specialite VARCHAR(100),
    Statut VARCHAR(50)
);

COPY Agents(AgentID, Nom, Prenom, AgenceID, DateEmbauche, Specialite, Statut)
FROM 'C:/SQL_PostgreSQL/projet/Agents.csv'
DELIMITER ','
CSV HEADER
ENCODING 'LATIN1';

SELECT *
FROM Agents;

------------------------------------------------------------------------ Table Ventes
INSERT INTO Clients (ClientID, Nom, Prenom, DateNaissance, Sexe, Adresse, AgenceID, Profession)
VALUES ('C201', 'NomExemple', 'PrenomExemple', '1985-06-15', 'F', 'Adresse Exemple', 'A001', 'Profession Exemple');

CREATE TEMP TABLE tmp_ventes AS
SELECT * FROM Ventes LIMIT 0;

COPY tmp_ventes(VenteID, ClientID, ProduitID, DateVente, Quantite, PrixUnitaire, Montant, AgenceID)
FROM 'C:/SQL_PostgreSQL/projet/Ventes.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'LATIN1');

INSERT INTO Ventes
SELECT *
FROM tmp_ventes
WHERE ClientID IN (SELECT ClientID FROM Clients);


SELECT *
FROM Ventes ;

/*******************************************************************************************************************************************************************/
/***************************************************************•	Analyse exploratoire et statistique en SQL :**************************************************************/
/*******************************************************************************************************************************************************************/

/****Affichage des bases ******************/

SELECT *
FROM Clients;

SELECT *
FROM Agences;

SELECT *
FROM Produits;

SELECT *
FROM Sinistres;

SELECT *
FROM Contrats;

--le Nombre de clients par région

SELECT a.region,
		COUNT(c.clientid) AS Nbre_clients
FROM Agences a
LEFT JOIN Clients c
	ON c.agenceid = a.agenceid
GROUP BY a.region
ORDER BY COUNT(c.clientid) DESC;

--le Nombre de clients par agence

SELECT a.nomagence,
		COUNT(a.agenceid) AS nbre_clients
FROM Agences a
LEFT JOIN Clients c
	ON a.agenceid = c.agenceid
GROUP BY a.nomagence
ORDER BY nbre_clients DESC;

-- Le Nombre de contrats par produit 

SELECT *
FROM Contrats;

SELECT *
FROM Produits;

SELECT p.nomproduit,
		COUNT(c.contratid) AS Nbre_contrats_produit
FROM Contrats c
INNER JOIN Produits p
	ON p.produitid = c.produitid
GROUP BY p.nomproduit
ORDER BY COUNT(c.contratid) DESC;

--Le Nombre de contrats par statut

SELECT statut,
		COUNT(contratid) AS Nbre_contrats_par statuts
FROM Contrats
GROUP BY statut
ORDER BY COUNT(*)DESC;

--Le Chiffre d’affaires annuel et mensuel
--vue de la table Ventes
SELECT *
FROM Ventes;

--Le Chiffre d’affaires annuel

SELECT EXTRACT(YEAR FROM datevente) AS Annuel,
		ROUND(COALESCE(SUM(montant),0),2) AS CA
FROM Ventes
GROUP BY EXTRACT(YEAR FROM datevente)
ORDER BY SUM(montant) DESC;

--Le Chiffre d’affaires mensuel

SELECT EXTRACT (MONTH FROM datevente) AS Mois,
		ROUND(COALESCE(SUM(montant),0),2) AS CA
FROM Ventes
GROUP BY EXTRACT (MONTH FROM datevente)
ORDER BY SUM(montant) DESC;

-- Le Nombre et montant des sinistres par produit

SELECT p.nomproduit,
       COUNT(s.sinistreid) AS nbre_sinistre,
       SUM(s.montant) AS montant_sinistre
FROM Produits p
JOIN Contrats c
       ON c.produitid = p.produitid
JOIN Sinistres s
       ON s.contratid = c.contratid
GROUP BY p.nomproduit
ORDER BY nbre_sinistre DESC, montant_sinistre DESC;
	
-- Le Nombre et montant des sinistres par région

SELECT a.region,
       COUNT(s.sinistreid) AS nbre_sinistres,
       SUM(s.montant) AS montant_sinistres
FROM Agences a
JOIN Clients c
       ON c.agenceid = a.agenceid
JOIN Contrats ct
       ON ct.clientid = c.clientid
JOIN Sinistres s
       ON s.contratid = ct.contratid
GROUP BY a.region
ORDER BY nbre_sinistres DESC, montant_sinistres DESC;

--Le Taux de résiliation par produit

--Définition
/* Le taux de résiliation mesure la proportion de contats résiliés par rapport au nombre total de contrats
souscrits pour un produit donné */

SELECT p.nomproduit,
       ROUND(COUNT(*) FILTER (WHERE c.statut = 'Résilié')::decimal 
         / COUNT(*) * 100,2) AS taux_resiliation
FROM Contrats c
JOIN Produits p
     ON c.produitid = p.produitid
GROUP BY p.nomproduit
ORDER BY taux_resiliation DESC;

--Top produits par montant de sinistres

SELECT p.nomproduit,
       SUM(s.montant) AS montant_sinistres,
       COUNT(s.sinistreid) AS nb_sinistres
FROM Produits p
JOIN Contrats c ON c.produitid = p.produitid
JOIN Sinistres s ON s.contratid = c.contratid
GROUP BY p.nomproduit
ORDER BY montant_sinistres DESC
LIMIT 10;

--Top clients par montant de sinistres

SELECT cl.clientid,
       cl.nom || ' ' || cl.prenom AS client,
       SUM(s.montant) AS montant_sinistres,
       COUNT(s.sinistreid) AS nb_sinistres
FROM Clients cl
JOIN Contrats c ON cl.clientid = c.clientid
JOIN Sinistres s ON s.contratid = c.contratid
GROUP BY cl.clientid, cl.nom, cl.prenom
ORDER BY montant_sinistres DESC
LIMIT 10;

--Top agences par montant de sinistres

SELECT a.nomagence,
       SUM(s.montant) AS montant_sinistres,
       COUNT(s.sinistreid) AS nb_sinistres
FROM Agences a
JOIN Contrats c ON a.agenceid = c.agenceid
JOIN Sinistres s ON s.contratid = c.contratid
GROUP BY a.nomagence
ORDER BY montant_sinistres DESC
LIMIT 10;

-- Le Montant total primes par période de souscription

SELECT EXTRACT(YEAR FROM datesouscription) AS Annee_soiscription,
				SUM(primeannuelle) AS montant_total_prime
FROM Contrats
GROUP BY EXTRACT(YEAR FROM datesouscription)
ORDER BY SUM(primeannuelle) DESC;

-- Le Montant total de sinistres par période de sortie

SELECT EXTRACT(YEAR FROM dateexpiration) AS Annee_expiration,
				SUM(primeannuelle) AS montant_total_prime
FROM Contrats
GROUP BY EXTRACT(YEAR FROM dateexpiration)
ORDER BY SUM(primeannuelle) DESC;

-- Quels contrats ont généré le plus de sinistres 

SELECT 
    c.contratid,
    SUM(s.montant) AS total_sinistres
FROM contrats c
JOIN sinistres s 
      ON c.contratid = s.contratid
GROUP BY c.contratid
ORDER BY total_sinistres DESC
LIMIT 10;

--Fréquence des sinistres (nombre de sinistres / nombre de contrats actifs)

SELECT 
    ROUND(COUNT(s.sinistreid)::decimal / COUNT(DISTINCT c.contratid),2) AS frequence_sinistres
FROM Contrats c
LEFT JOIN Sinistres s ON s.contratid = c.contratid
WHERE c.statut = 'Actif';

--Coût moyen des sinistres (Severity)

SELECT 
    ROUND(AVG(s.montant),2) AS cout_moyen_sinistre
FROM Sinistres s;

----Coût moyen des sinistres (Severity) par produit

SELECT 
    p.nomproduit,
    ROUND(AVG(s.montant),2) AS cout_moyen_sinistre
FROM Produits p
JOIN Contrats c ON c.produitid = p.produitid
JOIN Sinistres s ON s.contratid = c.contratid
GROUP BY p.nomproduit
ORDER BY cout_moyen_sinistre DESC;

--Ratio sinistres / primes 

SELECT 
    ROUND(SUM(s.montant) / SUM(c.primeannuelle),2) AS sp_ratio
FROM Contrats c
LEFT JOIN Sinistres s ON s.contratid = c.contratid;

-- On observons le client et le produit, le nom du prdouit liés au contrat

SELECT 
    c.contratid,
    cl.nom || ' ' || cl.prenom AS client,
    p.nomproduit,
    SUM(s.montant) AS total_sinistres,
    COUNT(s.sinistreid) AS nb_sinistres
FROM Contrats c
JOIN Clients cl ON cl.clientid = c.clientid
JOIN Produits p ON p.produitid = c.produitid
JOIN Sinistres s ON s.contratid = c.contratid
GROUP BY c.contratid, cl.nom, cl.prenom, p.nomproduit
ORDER BY total_sinistres DESC
LIMIT 10;

--Quelles agences ont les contrats les plus sinistrés

SELECT 
    a.nomagence,
    c.contratid,
    SUM(s.montant) AS total_sinistres
FROM Contrats c
JOIN Sinistres s ON s.contratid = c.contratid
JOIN Agences a ON a.agenceid = c.agenceid
GROUP BY a.nomagence, c.contratid
ORDER BY total_sinistres DESC
LIMIT 10;

-- Evoluation par année de sinistre

SELECT 
    EXTRACT(YEAR FROM s.datesinistre) AS annee,
    c.contratid,
    SUM(s.montant) AS total_sinistres
FROM Contrats c
JOIN Sinistres s ON s.contratid = c.contratid
GROUP BY annee, c.contratid
ORDER BY annee, total_sinistres DESC;

/**************************************************************************************************************************************************/
-- Fin de l’analyse, mais nous pouvons approfondir la réflexion en fonction des demandes de la direction des risques.
/***************************************************************************************************************************************************/

