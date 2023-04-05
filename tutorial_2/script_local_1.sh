# Référence de l'échantillon à analyser.
sample="SRR3405783"
# Chemin relatif et nom du fichier contenant le génome de référence.
genome="genome/genome.fa"
# Chemin relatif et nom du fichier contenant les annotations.
annotations="genome/genes.gtf"


echo "Contrôle qualité"
mkdir -p reads_qc
fastqc reads/${sample}.fastq.gz --outdir reads_qc


echo "Indexation du génome de référence"
mkdir -p genome_index
STAR --runMode genomeGenerate \
--genomeDir genome_index \
--genomeFastaFiles ${genome} \
--sjdbGTFfile ${annotations} \
--sjdbOverhang 50 \
--genomeSAindexNbases 10


echo "Alignement des reads sur le génome de référence"
mkdir -p reads_map
STAR --runThreadN 1 \
--runMode alignReads \
--genomeDir genome_index \
--sjdbGTFfile genome/genes.gtf \
--readFilesCommand zcat \
--readFilesIn reads/${sample}.fastq.gz \
--outFilterType BySJout \
--alignIntronMin 10 \
--alignIntronMax 3000 \
--outFileNamePrefix reads_map/${sample}_ \
--outFilterIntronMotifs RemoveNoncanonical \
--outSAMtype BAM Unsorted


echo "Tri et indexation des reads alignés"
samtools sort reads_map/${sample}_Aligned.out.bam -o reads_map/${sample}_Aligned.sorted.out.bam
samtools index reads_map/${sample}_Aligned.sorted.out.bam


echo "Comptage"
mkdir -p counts/${sample}

htseq-count --order=pos --stranded=reverse \
--mode=intersection-nonempty \
reads_map/${sample}_Aligned.sorted.out.bam ${annotations} > counts/${sample}/count_${sample}.txt

cuffquant --library-type=fr-firststrand genome/genes.gtf \
reads_map/${sample}_Aligned.sorted.out.bam \
--output-dir counts/${sample}


echo "Nettoyage des fichiers inutiles"

