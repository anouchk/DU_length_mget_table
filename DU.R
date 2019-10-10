library(data.table)

#set working directory
setwd('/Users/analutzky/Desktop/DU')

#lire le fichier des effectifs d'étudiants inscrits
t67univ=fread('67_univ_17_18.csv')
dauphine=fread('dauphine_17_18.csv')
lorraine=fread('lorraine_17_18.csv')
champo=fread('champollion_17_18.csv')
mayotte=fread('mayotte_17_18.csv')
comue=fread('comue_17_18.csv')
saclay_comue=comue[(Etablissement=="Université Paris-Saclay"&(CURSUS_LMD=="M"))]

# rbind ça concatene des matrices (A) et (B) en faisant
# (A)
# (B)
# i.e. ça concatène des lignes de tables ayant les memes colonnes

# cbind ça concatene des matrices (A) et (B) en faisant
# (A B)
# i.e. ça concatène des colonnes de tables ayant les memes lignes

Table=rbind(t67univ,dauphine,lorraine,champo,mayotte,saclay_comue)
rm(t67univ)
rm(dauphine)
rm(lorraine)
rm(champo)
rm(mayotte)
rm(saclay_comue)

# Combien d'établissement uniques ?
length(unique(Table$ETABLISSEMENT))
# [1] 72

### regarder l'objet
# afficher les premières et dernières ligne de apb (pour des objets de type data.table)
Table
# afficher les noms de colonnes
colnames(Table)
# dans R studio (pour des tableaux pas trop grands) 
View(Table)
# -> affichage excel-like

var.names=colnames(Table)

### supprimer les espaces et caractères spéciaux des noms de colonnes
colnames(Table)=make.names(var.names)

# Combien d'inscrits ?
Table[,.(inscrits=sum(Nombre.d.étudiants.inscrits..inscriptions.principales.))]
#  inscrits
# 1:  1 581 734

# afficher les nouveaux noms de colonnes
colnames(Table)

#### Etablissement aggregé

# créer un vecteur avec les nomsde colonnes qui m'intéressent
MYVARS=c('Etablissement','CURSUS_LMD', 'DN_DE', 'Nombre.d.étudiants.inscrits..inscriptions.principales.')

#mget ça transforme un vecteur de chaînes de caractère en vecteur de variables (sinon y'a get si c'est pour un seul string). Attention : datatable uniquement

Table=Table[,mget(MYVARS)]

# pour info table(Table$DN_DE) ça fait un tableau croisé dynamique sur une colonne (un peu comme un filtre excel, ça compte les occurrences d'une colonne)

# table(Table$Diplôme)

# dcast ça permet de remettre des lignes en colonnes
Table=dcast(Table,
	Etablissement + CURSUS_LMD ~ DN_DE, 
	value.var=c('Nombre.d.étudiants.inscrits..inscriptions.principales.'),
	fun.aggregate=sum)

# csv2 c'est à la française (; en séparateur et , pour les décimales)
write.csv2(as.data.frame(Table),file='72_univ_DU_Etablissement_LMD.csv',fileEncoding = "UTF8")

# reste à faire la ligne LMD

subTable_LMD=subTable[,.(CURSUS_LMD='Tout (L,M,D)',NB.ETR_NonUE=sum(NB.ETR_NonUE),NB.TOT=sum(NB.TOT)),by=.(Etablissement,DN_DE)]
subTable_withLMD=rbind(subTable,subTable_LMD)

subTable_withLMD_DNDE=dcast(subTable_withLMD,Etablissement+CURSUS_LMD~DN_DE,value.var=c('NB.ETR_NonUE','NB.TOT'))

subTable_withLMD_DNDE=subTable_withLMD_DNDE[,Pct_ETR_NonUE_DN:=NB.ETR_NonUE_DN/NB.TOT_DN_DE*100]
subTable_withLMD_DNDE=subTable_withLMD_DNDE[,Pct_ETR_NonUE_DN_DE:=NB.ETR_NonUE_DN_DE/NB.TOT_DN_DE*100]

# csv2 c'est à la française (; en séparateur et , pour les décimales)
write.csv2(as.data.frame(subTable_withLMD_DNDE),file='72_univ_DU_Etablissement_LMD.csv',fileEncoding = "UTF8")
