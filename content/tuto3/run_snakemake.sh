#!/usr/bin/env bash

# Script will stop at the first error
set -euo pipefail

# Load modules
module load fastqc/0.11.9
module load star/2.7.10b
module load samtools/1.15.1
module load htseq/0.13.5
module load cufflinks/2.2.1

module load snakemake/8.27.1

# Paths
export DATA_DIR="/shared/projects/2501_duo/data/rnaseq_scere"

# Run snakemake with cluster mode
snakemake --profile snakemake_profiles/cluster/
