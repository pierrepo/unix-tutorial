#!/bin/bash

#SBATCH --mem=2G
#SBATCH --cpus-per-task=8

# Le script va s'arrêter :
# - à la première erreur,
# - si une variable n'est pas définie,
# - si une erreur est recontrée dans un pipe.
set -euo pipefail


# Chargement des modules nécessaires :
module load fastqc/0.11.9
module load star/2.7.9a
module load samtools/1.14
module load htseq/0.13.5
module load cufflinks/2.2.1


# Référence de l'échantillon à analyser.
sample="SRR3405783"
# Chemin et nom du fichier contenant le génome de référence.
genome_file="genome/genome.fa"
# Chemin et nom du fichier contenant les annotations.
annotation_file="genome/genes.gtf"


echo "=============================================================="
echo "Indexer le génome de référence"
echo "=============================================================="
mkdir -p "genome_index"
srun STAR --runThreadN "${SLURM_CPUS_PER_TASK}" \
--runMode genomeGenerate \
--genomeDir "genome_index" \
--genomeFastaFiles "${genome_file}" \
--sjdbGTFfile "${annotation_file}" \
--sjdbOverhang 50 \
--genomeSAindexNbases 10

echo "=============================================================="
echo "Contrôler la qualité : échantillon ${sample}"
echo "=============================================================="
mkdir -p "reads_qc"
srun fastqc "reads/${sample}.fastq.gz" --outdir "reads_qc"

echo "=============================================================="
echo "Aligner les reads sur le génome de référence : échantillon ${sample}"
echo "=============================================================="
mkdir -p "reads_map"
srun STAR --runThreadN "${SLURM_CPUS_PER_TASK}" \
--runMode alignReads \
--genomeDir genome_index \
--sjdbGTFfile ${annotation_file} \
--readFilesCommand zcat \
--readFilesIn "reads/${sample}.fastq.gz" \
--outFilterType BySJout \
--alignIntronMin 10 \
--alignIntronMax 3000 \
--outFileNamePrefix "reads_map/${sample}_" \
--outFilterIntronMotifs RemoveNoncanonical \
--outSAMtype BAM Unsorted

echo "=============================================================="
echo "Trier les reads alignés : échantillon ${sample}"
echo "=============================================================="
srun samtools sort "reads_map/${sample}_Aligned.out.bam" \
-o "reads_map/${sample}_Aligned.sorted.out.bam"

echo "=============================================================="
echo "Indexer les reads alignés : échantillon ${sample}"
echo "=============================================================="
srun samtools index "reads_map/${sample}_Aligned.sorted.out.bam"

echo "=============================================================="
echo "Compter les reads : échantillon ${sample}"
echo "=============================================================="
mkdir -p "counts/${sample}"
srun htseq-count --order=pos --stranded=reverse \
--mode=intersection-nonempty \
"reads_map/${sample}_Aligned.sorted.out.bam" \
"${annotation_file}" > "counts/${sample}/count_${sample}.txt"

echo "=============================================================="
echo "Compter les transcrits : échantillon ${sample}"
echo "=============================================================="
srun cuffquant --num-threads "${SLURM_CPUS_PER_TASK}" \
--library-type=fr-firststrand "${annotation_file}" \
"reads_map/${sample}_Aligned.sorted.out.bam" \
--output-dir "counts/${sample}"
