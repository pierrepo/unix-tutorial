#!/usr/bin/env bash

#SBATCH --mem=2G
#SBATCH --cpus-per-task=8

# Le script va s'arrêter
# - à la première erreur
# - si une variable n'est pas définie
# - si une erreur est recontrée dans un pipe
set -euo pipefail


# Chargement des modules nécessaires :
module load star/2.7.10b


# répertoire de base (le répertoire depuis lequel vous lancez le script)
base_dir="$PWD"
# répertoire contenant les données
data_dir="/shared/projects/2501_duo/data/rnaseq_scere"
# répertoire contenant les fichiers du génome de référence
# (séquence et annotations)
genome_dir="${data_dir}/genome"
# chemin et nom du fichier contenant le génome de référence.
genome_file="${genome_dir}/genome.fa"
# chemin et nom du fichier contenant les annotations
annotation_file="${genome_dir}/genes.gtf"
# répertoire contenant les fichiers .fastq.gz
fastq_dir="${data_dir}/reads"


# On indexe le génome qu'une seule fois.
echo "=============================================================="
echo "Indexer le génome de référence"
echo "Date et heure : $(date --iso-8601=seconds)"
echo "=============================================================="
mkdir -p "${base_dir}/genome_index"
srun STAR --runThreadN "${SLURM_CPUS_PER_TASK}" \
--runMode genomeGenerate \
--genomeDir "${base_dir}/genome_index" \
--genomeFastaFiles "${genome_file}" \
--sjdbGTFfile "${annotation_file}" \
--sjdbOverhang 50 \
--genomeSAindexNbases 10

echo "=============================================================="
echo "Fin"
echo "Date et heure : $(date --iso-8601=seconds)"
echo "=============================================================="
