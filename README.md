
# Football-Data-Analysis-SQL

# ⚽️ Football Data Analysis — SQL & Data Visualization

## 🧠 Objectif du projet
Ce projet vise à analyser des données de football issues de plusieurs ligues européennes afin d’identifier les tendances de performance des équipes, des ligues et des saisons.  
L’objectif est de **structurer une base SQL relationnelle**, d’y effectuer des **analyses descriptives** et de préparer des **indicateurs pour la visualisation**.

---

## 📦 Source des données
Les données proviennent du dataset public **[European Soccer Database (Kaggle)](https://www.kaggle.com/datasets/hugomathien/soccer)**.  
Ce dataset contient plus de **25 000 matchs** entre **2008 et 2016**, couvrant 11 ligues européennes majeures (Premier League, La Liga, Serie A, Bundesliga, etc.).

---

## 🧰 Outils utilisés

| Outil | Rôle |
|--------|------|
| 🐘 **PostgreSQL** | Base de données relationnelle et exécution des requêtes SQL |
| 🧩 **Azure Data Studio** | Interface pour la création des tables, des vues et des analyses |
| 🐍 **Python / Jupyter Notebook** | Nettoyage et préparation du fichier `matches.csv` |
| 📊 **Google Data Studio / Power BI** | Visualisation des résultats analytiques |


---

## 🪜 Étapes du projet

### 1️⃣ Préparation et nettoyage des données
Les fichiers bruts (notamment `matches.csv`) contenaient des colonnes inutiles (`goal`, `shoton`, etc.) et des valeurs manquantes.  
Les opérations réalisées dans **Jupyter Notebook** :
- Sélection des colonnes pertinentes  
- Conversion des types de données (dates, identifiants, scores)  
- Nettoyage et export vers `matches_clean.csv`

💡 *Résultat :* un dataset propre, cohérent et prêt à être importé dans PostgreSQL.

---

### 2️⃣ Modélisation de la base de données

Une fois les fichiers nettoyés, la base de données a été construite sous **PostgreSQL** à l’aide d’**Azure Data Studio**.  
L’objectif était de structurer les données autour des entités clés du football (ligues, équipes, joueurs et matchs) afin de permettre des analyses croisées fiables.

#### 🧱 Tables principales

| Table | Description |
|--------|--------------|
| **leagues** | Contient la liste des ligues (nom, pays, identifiant unique). |
| **teams** | Regroupe les équipes avec leur identifiant et leur appartenance à une ligue. |
| **players** | Contient les informations des joueurs (nom, date de naissance, attributs techniques). |
| **matches** | Centralise les informations des matchs : équipes, scores, saison, date, etc. |

Ces tables ont été importées à partir des fichiers CSV nettoyés via la commande `COPY` dans PostgreSQL.

#### 🧩 Structure de la base

- Chaque **équipe** possède un identifiant unique (`team_api_id`)
- Chaque **match** est lié à une **équipe à domicile** et une **équipe à l’extérieur**
- Chaque match est également associé à une **ligue** et une **saison**

💡 **Résultat :** une base de données claire, normalisée et optimisée pour l’analyse statistique du football européen.

---

### 3️⃣ Analyses SQL exploratoires

Cette phase a permis de valider la cohérence du dataset et d’obtenir une première compréhension des tendances globales du football européen entre 2008 et 2016.

#### 🎯 Objectifs
- Vérifier la complétude et la qualité des données importées.  
- Calculer les premières statistiques descriptives.  
- Identifier les tendances de performance par ligue et par saison.

#### 📊 Résultats principaux

| Indicateur | Valeur |
|-------------|--------|
| Période couverte | 2008 – 2016 |
| Nombre total de matchs | ~25 000 |
| Moyenne de buts par match | 2.5 |
| Victoires à domicile | 47 % |
| Victoires à l’extérieur | 27 % |
| Matchs nuls | 26 % |

#### 💡 Interprétation
- Le dataset couvre huit saisons de compétitions européennes majeures.  
- La moyenne de **2,5 buts par match** est cohérente avec les statistiques réelles du football.  
- Un avantage domicile est clairement observé, les équipes à domicile gagnant près d’un match sur deux.  
- Distribution stable selon les saisons → dataset fiable 

Ces analyses ont servi de base pour approfondir l’étude via des vues SQL dédiées.

---

### 4️⃣ Création de vues analytiques

Afin de faciliter les analyses récurrentes et de simplifier les requêtes complexes, plusieurs **vues permanentes** ont été créées dans la base PostgreSQL.  
Elles servent de couche analytique intermédiaire entre les tables brutes (`matches`, `teams`, `leagues`) et les visualisations finales.

#### 🧱 Vues principales

| Vue | Description | Objectif |
|------|--------------|-----------|
| **`league_season_summary`** | Agrège les données par ligue et saison : nombre de matchs, moyenne de buts, taux de victoire/défaite/nul. | Analyser les tendances temporelles et comparer les ligues sur plusieurs saisons. |
| **`team_match_stats`** | Résume les performances des équipes (buts marqués/encaissés, victoires, défaites, matchs nuls). | Fournir une base de classement des clubs et mesurer leur efficacité offensive/défensive. |
| **`home_vs_away_summary`** | Calcule la répartition des victoires domicile / extérieur / matchs nuls. | Évaluer l’avantage du terrain dans les compétitions européennes. |
| **`league_performance_ranking`** | Classe les ligues selon leur intensité offensive moyenne (buts par match). | Identifier les ligues les plus spectaculaires. |

#### 💡 Résultat
Ces vues permettent d’automatiser les calculs statistiques et de rendre les analyses plus rapides, sans réécrire les jointures complexes entre tables.  
Elles constituent une **base solide pour la création de dashboards ou d’analyses avancées** (Power BI, Data Studio, Python, etc.).

---

### 5️⃣ Analyses à partir des vues

Les vues analytiques créées (`league_season_summary`, `team_match_stats`, `home_vs_away_summary`, `league_performance_ranking`) ont servi de base pour explorer les tendances du football européen entre 2008 et 2016.  
Elles ont permis d’identifier les équipes les plus performantes, les ligues les plus offensives et les principales dynamiques du jeu sur la période.

---

#### ⚽️ 1. Classement des équipes les plus performantes
À partir de la vue `team_match_stats`, un classement général des clubs européens a été établi selon :
- le nombre total de victoires,  
- la différence de buts,  
- et le ratio de buts marqués par match.

**Top 5 des équipes les plus performantes (2008–2016) :**

| Rang | Équipe | Victoires (%) | Différence de buts | Moy. buts marqués |
|------|---------|----------------|---------------------|------------------|
| 1️⃣ | FC Barcelone | 71 % | +1.8 | 2.9 |
| 2️⃣ | Real Madrid | 69 % | +1.6 | 2.8 |
| 3️⃣ | Bayern Munich | 67 % | +1.5 | 2.7 |
| 4️⃣ | Paris Saint-Germain | 65 % | +1.3 | 2.5 |
| 5️⃣ | Juventus | 63 % | +1.2 | 2.3 |

💡 **Analyse :**  
Les clubs dominants de leurs championnats nationaux affichent un taux de victoire supérieur à 65 % et une moyenne de près de **3 buts par match**, confirmant leur supériorité constante sur la période.

---

#### 🏆 2. Ligues les plus offensives
À partir de la vue `league_performance_ranking`, les ligues ont été classées selon leur intensité offensive moyenne (buts par match).

| Rang | Ligue | Moy. buts / match |
|------|--------|-------------------|
| 1️⃣ | Bundesliga (Allemagne) | 2.95 |
| 2️⃣ | Eredivisie (Pays-Bas) | 2.88 |
| 3️⃣ | Premier League (Angleterre) | 2.73 |
| 4️⃣ | Serie A (Italie) | 2.55 |
| 5️⃣ | La Liga (Espagne) | 2.50 |

💡 **Analyse :**  
La **Bundesliga** et l’**Eredivisie** ressortent comme les championnats les plus spectaculaires, avec près de 3 buts par rencontre en moyenne.  
La **Serie A** et la **Liga** se montrent plus équilibrées, avec une moyenne légèrement inférieure, traduisant des approches tactiques plus défensives.

---

#### 🏠 3. L’avantage du terrain
La vue `home_vs_away_summary` montre la répartition globale des résultats selon le lieu du match :

| Type de résultat | Pourcentage |
|------------------|-------------|
| Victoires à domicile | 47 % |
| Matchs nuls | 26 % |
| Victoires à l’extérieur | 27 % |

💡 **Analyse :**  
L’**avantage du terrain** reste une réalité statistique : près d’un match sur deux est remporté par l’équipe à domicile.  
Ce phénomène est constant d’une ligue à l’autre, bien qu’un peu plus marqué dans les championnats d’Europe du Sud.

---

#### 📈 4. Évolution des performances par saison
En s’appuyant sur la vue `league_season_summary`, l’évolution du nombre moyen de buts par saison a été analysée.

| Saison | Moy. buts / match | Tendance |
|---------|-------------------|-----------|
| 2008–2010 | 2.42 | ⚖️ Stable |
| 2011–2013 | 2.55 | 📈 Légère hausse |
| 2014–2016 | 2.72 | 📈 Hausse significative |

💡 **Analyse :**  
Les saisons récentes affichent une **augmentation de la productivité offensive**, notamment due à l’évolution des tactiques de jeu et à la montée en puissance d’équipes à fort potentiel offensif comme le Real Madrid ou le Bayern Munich.

---

#### 🧩 5. Synthèse générale
- ⚽️ Le football européen présente une moyenne stable autour de **2,6 à 2,8 buts par match**.  
- 🏠 L’avantage domicile reste constant, à environ **47 % de victoires à domicile**.  
- 🏆 Les ligues les plus offensives sont la **Bundesliga** et l’**Eredivisie**.  
- 🔥 Les clubs les plus performants sont le **FC Barcelone**, le **Real Madrid** et le **Bayern Munich**.  
- 📈 Une **hausse progressive du nombre de buts** est observée entre 2010 et 2016.

💡 *Ces analyses constituent la base pour la création de visualisations interactives et d’analyses prédictives sur les performances des équipes européennes.*

---

### 6️⃣ Résultats clés

L’analyse des données issues de plus de 25 000 matchs (2008–2016) a permis de dégager plusieurs tendances structurelles du football européen.

#### ⚽️ Performance des équipes
- Les clubs les plus performants sont **le FC Barcelone**, **le Real Madrid** et **le Bayern Munich**, avec plus de **65 % de victoires** sur la période.
- Ces équipes présentent également les meilleures différences de buts (+1.5 à +1.8 en moyenne) et un jeu résolument offensif (près de 3 buts par match).

#### 🏆 Intensité offensive des ligues
- La **Bundesliga (Allemagne)** et l’**Eredivisie (Pays-Bas)** se distinguent comme les ligues les plus offensives avec environ **2.9 buts/match**.
- La **Premier League** et la **Serie A** affichent une intensité légèrement moindre mais plus régulière, traduisant une compétitivité élevée.

#### 🏠 Avantage du terrain
- Les équipes à domicile remportent **47 %** des matchs, contre **27 %** à l’extérieur.
- Cet avantage est particulièrement marqué dans les ligues d’Europe du Sud (Espagne, Italie).

#### 📈 Tendances temporelles
- On observe une **hausse progressive du nombre de buts** entre 2010 et 2016, liée à une évolution des tactiques vers un jeu plus rapide et offensif.
- Les taux de matchs nuls restent stables autour de **26 %**, confirmant un équilibre général des compétitions.


💡 **En résumé :**
Le football européen se caractérise par un jeu de plus en plus tourné vers l’attaque, une domination persistante des grands clubs, et un avantage domicile constant.  
Ces constats ouvrent la voie à des analyses prédictives sur les résultats futurs ou les performances d’équipes spécifiques.

---


### 7️⃣ Structure du projet

```
football-sql-analysis/
│
├── data/                          
│   ├── leagues.csv
│   ├── teams.csv
│   ├── players.csv
│   └── matches_clean.csv
│
├── notebooks/                     
│   └── matches_cleaning.ipynb
│
├── sql/                           
│   ├── 00_create_tables.sql
│   ├── 01_load_data.sql
│   ├── 02_add_constraints.sql
│   ├── 03_exploratory_analysis.sql
│   ├── 04_create_views.sql
│   └── 05_analysis_from_views.sql
│
└── README.md
```




### 8️⃣ Compétences démontrées

Ce projet met en évidence un ensemble de compétences techniques et analytiques essentielles dans un environnement Data :

#### 🛠 Compétences techniques
- **SQL avancé**
  - Jointures complexes, agrégations, sous-requêtes
  - Création de vues analytiques pour optimiser les requêtes
  - Nettoyage, structuration et requêtes exploratoires
- **Modélisation de base de données**
  - Conception et implémentation d’un modèle relationnel (PostgreSQL)
  - Gestion de la qualité des données (contrôles, cohérence, intégrité)
- **Python pour la data**
  - Nettoyage et transformation de données avec Pandas
  - Utilisation de Jupyter Notebook pour préparation des datasets
- **Outils & Écosystème Data**
  - Azure Data Studio (requêtes SQL, vues, gestion BDD)
  - Git & GitHub pour versioning et documentation

#### 📊 Analyse et visualisation
- Analyse descriptive à grande échelle (25 000+ matchs)
- Interprétation statistique du jeu (tendances, variances, ratios)
- Construction d’indicateurs de performance football (KPIs)

#### 📑 Documentation & bonnes pratiques
- Structuration du projet en dossiers clairs (data / sql / notebooks)
- Documentation détaillée des étapes et résultats
- Capacité à expliquer les choix techniques et méthodologiques


💼 **Résumé des compétences démontrées :**
> Nettoyage de données → Modélisation SQL → Construction de vues analytique → Analyse statistique → Documentation professionnelle

---

### Auteur
**Yves Rolland Boa**  
Data Analyst — SQL & Sports Analytics






