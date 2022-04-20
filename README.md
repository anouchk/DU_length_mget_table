# DU_length_mget_table

Il s'agit d'appliquer des fonctions de la librairie data.table dans R, expliquées dans cette <a href="https://raw.githubusercontent.com/rstudio/cheatsheets/master/datatable.pdf">cheatsheet</a>, au <a href="https://data.enseignementsup-recherche.gouv.fr/explore/dataset/fr-esr-sise-effectifs-d-etudiants-inscrits-esr-public/information/">fichier en open data des étudiants inscrits du MESRI</a>, pour **compter le nombre d'étudiants étrangers hors UE inscrits en DU**, dans chaque université.

- **length(unique(Table$NOMDELACOLONNE))** ça compte le nombre de valeurs uniques dans la colonne
- **mget** ça transforme un vecteur de chaînes de caractère en vecteur de variables (sinon y'a get si c'est pour un seul string). Attention : datatable uniquement
- **table(Table$NOMDELACOLONNE)** ça fait un tableau croisé dynamique sur une colonne (un peu comme un filtre excel, ça compte les occurrences d'une colonne)

