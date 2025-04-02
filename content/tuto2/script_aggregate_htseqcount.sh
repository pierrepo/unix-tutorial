#!/bin/bash

# Le script va s'arrêter :
# - à la première erreur,
# - si une variable n'est pas définie,
# - si une erreur est recontrée dans un pipe.
set -euo pipefail

for name in counts/*/*.txt
do
    echo "${name}"
    # On récupère le nom de l'échantillon.
    sample="$(basename -s .txt ${name} | sed 's/count_//g' )"
    # On stocke dans un fichier temporaire, pour chaque échantillon,
    # un entête avec "gene" et le nom de l'échantillon.
    echo -e "${sample}" > "count_${sample}_tmp.txt"
    # On copie le contenu du fichier de comptage dans ce fichier temporaire.
    cut -f2 "${name}" >> "count_${sample}_tmp.txt"
done

# On récupère les noms des gènes.
echo "gene" > genes.txt
cut -f1 "${name}" >> genes.txt

# On fusionne tous les fichiers.
paste genes.txt *tmp.txt > count_all.txt

# On supprime les lignes qui débutent par '__'
# et qui ne sont pas utiles.
grep -v "^__" count_all.txt > count_all_clean.txt

# On supprime les fichiers temporaires.
rm -f genes.txt *tmp.txt count_all.txt