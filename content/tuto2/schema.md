````{mermaid}
---
title: "Analyse RNA-seq"
---
flowchart TB
	read["reads .fastq.gz"]
    genome["genome de référence"]
    annotation["annotations du génome"]

    quality_control(["Contrôler <br/> la qualité des reads"])
    star_index(["Indexer <br/> le génome de référence"])
    star_map(["Aligner les reads <br/> sur le génome de référence"])
    samtools_sort(["Trier les reads alignés"])
    samtools_index(["Indexer les reads alignés"])
    htseq(["Compter les reads alignés"])
    cuffquant(["Compter les transcrits"])
    cuffnorm(["Normaliser les transcrits"])

    table[["Table de comptage"]]

    genome -->|"STAR"| star_index
    annotation -->|"STAR"| star_index
    
    read -->|"FastQC"| quality_control
    
    star_index -->|"STAR"| star_map
    read -->|"STAR"| star_map

    star_map -->|"samtools"| samtools_sort
    samtools_sort -->|"samtools"| samtools_index

    samtools_index -->|"HTseq"| htseq
    annotation -->|"HTseq"| htseq 
    samtools_index -->|"cuffquant"| cuffquant
    annotation -->|"cuffquant"| cuffquant
    cuffquant -->|"cuffnom"| cuffnorm
    cuffnorm -->|"Aggréger les résultats"| table 
    
    linkStyle default stroke-width:2px,fill:none,color:red;
    style read fill:#E1F8DC,stroke:#40A8C4;
    style genome fill:#E1F8DC,stroke:#40A8C4;
    style annotation fill:#E1F8DC,stroke:#40A8C4;
````
