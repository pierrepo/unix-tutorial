#!/usr/bin/env bash

# Référence de l'échantillon à analyser.
sample="SRR3405801"
# Chemin et nom du fichier contenant le génome de référence.
genome_file="genome/genome.fa"
# Chemin et nom du fichier contenant les annotations.
annotation_file="genome/genes.gtf"

echo "=============================================================="
echo "Indexer le génome de référence"
echo "Date et heure : $(date --iso-8601=seconds)"
echo "=============================================================="
mkdir -p "genome_index"
STAR --runThreadN 4 \
--runMode genomeGenerate \
--genomeDir "genome_index" \
--genomeFastaFiles "${genome_file}" \
--sjdbGTFfile "${annotation_file}" \
--sjdbOverhang 50 \
--genomeSAindexNbases 10

echo "=============================================================="
echo "Contrôler la qualité : échantillon ${sample}"
echo "Date et heure : $(date --iso-8601=seconds)"
echo "=============================================================="
mkdir -p "reads_qc"
fastqc "reads/${sample}.fastq.gz" --outdir "reads_qc"

echo "=============================================================="
echo "Aligner les reads sur le génome de référence : échantillon ${sample}"
echo "Date et heure : $(date --iso-8601=seconds)"
echo "=============================================================="
mkdir -p "reads_map"
STAR --runThreadN 4 \
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
echo "Date et heure : $(date --iso-8601=seconds)"
echo "=============================================================="
samtools sort "reads_map/${sample}_Aligned.out.bam" \
-o "reads_map/${sample}_Aligned.sorted.out.bam"

echo "=============================================================="
echo "Indexer les reads alignés : échantillon ${sample}"
echo "Date et heure : $(date --iso-8601=seconds)"
echo "=============================================================="
samtools index "reads_map/${sample}_Aligned.sorted.out.bam"

echo "=============================================================="
echo "Compter les reads : échantillon ${sample}"
echo "Date et heure : $(date --iso-8601=seconds)"
echo "=============================================================="
mkdir -p "counts/${sample}"
htseq-count --order=pos --stranded=reverse \
--mode=intersection-nonempty \
"reads_map/${sample}_Aligned.sorted.out.bam" \
"${annotation_file}" > "counts/${sample}/count_${sample}.txt"

echo "=============================================================="
echo "Compter les transcrits : échantillon ${sample}"
echo "Date et heure : $(date --iso-8601=seconds)"
echo "=============================================================="
cuffquant --num-threads 4 \
--library-type=fr-firststrand "${annotation_file}" \
"reads_map/${sample}_Aligned.sorted.out.bam" \
--output-dir "counts/${sample}"

echo "=============================================================="
echo "Fin"
echo "Date et heure : $(date --iso-8601=seconds)"
echo "=============================================================="
