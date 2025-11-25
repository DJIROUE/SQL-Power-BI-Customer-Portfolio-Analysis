# Projet SQL → Power BI : Analyse du portefeuille clients

## Objectif du projet
Créer un tableau de bord interactif permettant de suivre l’activité commerciale : volume de contrats, chiffre d’affaires, sinistralité, performances commerciales par produit et par agence.  

---

## 1. Bases de données nécessaires
Le projet contient plusieurs (7) tables pour refléter la réalité opérationnelle :

- **Clients** : ClientID, Nom, Prénom, DateNaissance, Sexe, Adresse, AgenceID  
- **Produits** : ProduitID, NomProduit, TypeProduit (auto, habitation, santé, etc.)  
- **Contrats** : ContratID, ClientID, ProduitID, DateSouscription, DateFin, PrimeAnnuelle, Statut (actif, résilié)  
- **Sinistres** : SinistreID, ContratID, DateSinistre, MontantIndemnisé, TypeSinistre  
- **Agences** : AgenceID, NomAgence, Région, Responsable  
- **Ventes** : VenteID, AgentID, ContratID, DateVente, MontantVente  
- **Agents** : AgentID, NomAgent, AgenceID, DateEmbauche  

---

## 2. Étapes du projet

### Étape 1 : Compréhension et préparation des données
- Comprendre la structure des tables et leurs relations (ClientID, ContratID, AgenceID…).  
- Nettoyer les données : valeurs manquantes, doublons, formats de dates, incohérences.  

### Étape 2 : Requêtes SQL
- Analyse exploratoire :  
  - Nombre de clients par région / agence  
  - Nombre de contrats par produit et par statut  
  - Chiffre d’affaires annuel et mensuel  
  - Nombre et montant des sinistres par produit / région  
  - Taux de résiliation par produit  
- Jointures et agrégations :  
  - Clients + Contrats + Produits → détail du portefeuille client  
  - Contrats + Sinistres → calcul de la sinistralité  
  - Calculs : montant total primes / sinistres, ratio sinistre / prime, taux de conversion ventes / souscriptions  

### Étape 3 : Export SQL → Power BI
- Connexion à la base SQL depuis Power BI (DirectQuery ou Import)  
- Charger les tables et créer le data model  
- Vérifier les relations entre tables  

### Étape 4 : Création des visualisations
- Carte géographique : clients / ventes / sinistres par région  
- Graphique temporel : évolution mensuelle du chiffre d’affaires et des sinistres  
- Histogrammes : répartition des contrats par produit et par agence  
- KPI : chiffre d’affaires total, nombre de contrats actifs, sinistralité globale, taux de résiliation  
- Filtres et slicers : produits, agences, période  

### Étape 5 : Analyse et insights
- Identifier les agences les plus performantes  
- Repérer les produits avec forte sinistralité ou taux de résiliation élevé  
- Identifier les clients ou segments à potentiel de vente  
---
![Tableau de bord Power BI] https://github.com/DJIROUE/SQL-Power-BI-Customer-Portfolio-Analysis/blob/main/Performance%20Globale.png?raw=true

## 3. Questions à résoudre
1. Évolution du chiffre d’affaires par produit et par agence  
2. Produits générant le plus de sinistres et leurs montants moyens  
3. Agences les plus performantes en termes de ventes et de fidélisation  
4. Taux de résiliation global et par produit  
5. Segments clients les plus rentables  
6. Corrélations entre montant prime et sinistralité  
---

## 4. Questionnaire pour guider les requêtes et visualisations

**A. Analyse du portefeuille client**  
- Combien de clients par région et par agence ?  
- Répartition des clients par âge et sexe  
- Clients avec plusieurs contrats actifs  

**B. Analyse des contrats et produits**  
- Nombre de contrats actifs / résiliés par produit  
- Prime totale par produit et agence  
- Produits générant le plus / moins de chiffre d’affaires  

**C. Analyse des ventes et des agents**  
- Chiffre d’affaires par agent et agence  
- Agents avec le plus de contrats signés  
- Évolution des ventes par mois / trimestre  

**D. Analyse des sinistres**  
- Nombre de sinistres par produit et agence  
- Montant moyen des sinistres par produit  
- Contrats générant le plus de sinistres  
- Ratio sinistre / prime par produit et agence  

**E. KPIs et tableaux de bord Power BI**  
- Chiffre d’affaires total et par produit/agence  
- Nombre de contrats actifs / résiliés  
- Taux de sinistralité  
- Montant total des sinistres  
- Performance des agents et agences  
- Graphiques temporels : évolution mensuelle du chiffre d’affaires et des sinistres  

---

## 5. Compétences techniques
PostgreSQL,
POWER BI,
Power Query,
Power Pivot
