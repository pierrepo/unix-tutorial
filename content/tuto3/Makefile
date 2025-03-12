SHELL=/bin/bash

.PHONY: clean
clean:
	rm -rf genome_index reads_qc reads_map slurm*


.PHONY: snakemake
snakemake:
	zip snakemake.zip run_snakemake.sh Snakefile snakemake_profiles/*/*
