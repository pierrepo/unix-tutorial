# Automatiser l'analyse RNA-seq ⚙️

```{contents}
```

Dans la section précédente, vous avez analysé les données RNA-seq d'un seul échantillon en exécutant, une à une, chaque étape de l'analyse (contrôle qualité, alignement des *reads*, quantification...).

Nous allons maintenant automatiser l'analyse d'un échantillon en utilisant un script. Puis nous automatiserons l'analyse de plusieurs échantillons.

## Vérifier l'environnement logiciel et les données

Si cela n'est pas déjà fait, chargez les outils nécessaires à l'analyse des données RNA-seq :

```bash
$ module load sra-tools fastqc star htseq cufflinks samtools
```

```{admonition} Rappel
:class: tip
La commande `module list` affiche les modules déjà chargés.
```

Vérifiez ensuite que vous êtes bien dans le répertoire `/shared/projects/202304_duo/$USER/rnaseq` avec la commande `pwd`. Déplacez-vous dans ce répertoire si ce n'est pas le cas.

Supprimez les répertoires qui contiennent les résultats de l'analyse précédente :

```bash
$ rm -rf genome_index reads_qc reads_map counts
```

```{warning}
Attention à la commande `rm` qui supprime irrémédiablement fichiers et répertoires.
```

Enfin, vérifiez que les données RNA-seq et le génome de *S. cerevisiae* sont bien disponibles :

```bash
$ tree
.
├── genome
│   ├── genes.gtf
│   └── genome.fa
└── reads
    ├── SRR3405783.fastq.gz
    ├── SRR3405784.fastq.gz
    └── SRR3405785.fastq.gz
```

## Variables Bash

Une variable va contenir de l'information qui sera utilisable autant de fois que nécessaire.

Créer des variables :

```bash
$ toto=33
$ t="salut"
```

```{warning}
Il faut coller le nom de la variable et son contenu au symbole `=`.
```

Afficher des variables :

```bash
$ echo $toto
33
$ echo "$t Pierre"
salut Pierre
```

La commande `echo` affiche une chaîne de caractères, une variable, ou les deux.

Pour utiliser une variable (et accéder à son contenu), il faut précéder son nom du caractère `$`. Attention, ne  confondez pas ce symbole avec celui qui désigne l'invite de commande de votre *shell* Linux.

Enfin, une bonne pratique consiste à utiliser une variable avec le symbole `$` et son nom entre accolades :

```bash
$ echo ${toto}
33
$ echo "${t} Pierre"
salut Pierre
```

## Script Bash

Un script est un fichier texte qui contient des instructions Bash. Par convention, il porte l'extension `.sh`. L'objectif premier d'un script Bash est d'**automatiser l'exécution de plusieurs commandes** Bash, la plupart du temps pour manipuler ou analyser des fichiers.

Dans un script Bash :

- La première ligne commence par `#! /bin/bash` et précise à l'ordinateur que le script est écrit en Bash.
- Tout ce qui suit le symbole `#` est considéré comme un commentaire et n'est donc pas traité par Bash.
- Le caractère `\` en fin de ligne permet de continuer une instruction sur la ligne suivante.

## Automatiser l'analyse d'un échantillon

Téléchargez dans un terminal de JupyterLab un premier script Bash ([`script_local_1.sh`](script_local_1.sh)) avec la commande `wget` :

```bash
$ wget https://raw.githubusercontent.com/pierrepo/unix-tutorial/master/tuto2/script_local_1.sh
```

Ouvrez ce script avec l'éditeur de texte de JupyterLab. Pour cela, double-cliquez sur le nom du script dans le navigateur de fichiers (situé à gauche) de JupyterLab, .

Retrouvez également dans ce script les différentes étapes de l'analyse RNA-seq que vous avez réalisées précédemment. Y-a-t-il des choses bizarres dont vous souhaiteriez des explications ? Si oui, notez-les, lancez-le script puis nous y reviendrons.

Lancez le script avec la commande :

```bash
$ bash script_local_1.sh
```

Vérifiez que le déroulement du script se passe bien. Vous avez le temps de prendre un café, voir plusieurs ☕ 🍪 ☕ 🍪.

Une fois terminé, évaluez approximativement le temps qu'il a fallu au script 1 pour s'exécuter. Reportez dans le carnet de bord le numéro de l'échantillon analysé et le temps d'exécution du script.

D'après vous, quelle est l'étape la plus longue ? Combien de temps faudrait-il pour analyser les 3 échantillons ?

Utilisez enfin la commande `tree` pour contempler votre travail (ici avec l'échantillon `SRR3405783`) :

```bash
$ tree
.
├── counts
│   └── SRR3405783
│       ├── abundances.cxb
│       └── count_SRR3405783.txt
├── genome
│   ├── genes.gtf
│   └── genome.fa
├── genome_index
│   ├── chrLength.txt
│   ├── chrNameLength.txt
│   ├── chrName.txt
│   ├── chrStart.txt
│   ├── exonGeTrInfo.tab
│   ├── exonInfo.tab
│   ├── geneInfo.tab
│   ├── Genome
│   ├── genomeParameters.txt
│   ├── Log.out
│   ├── SA
│   ├── SAindex
│   ├── sjdbInfo.txt
│   ├── sjdbList.fromGTF.out.tab
│   ├── sjdbList.out.tab
│   └── transcriptInfo.tab
├── reads
│   ├── SRR3405783.fastq.gz
│   ├── SRR3405784.fastq.gz
│   └── SRR3405785.fastq.gz
├── reads_map
│   ├── SRR3405783_Aligned.out.bam
│   ├── SRR3405783_Aligned.sorted.out.bam
│   ├── SRR3405783_Aligned.sorted.out.bam.bai
│   ├── SRR3405783_Log.final.out
│   ├── SRR3405783_Log.out
│   ├── SRR3405783_Log.progress.out
│   ├── SRR3405783_SJ.out.tab
│   └── SRR3405783__STARgenome
│       ├── exonGeTrInfo.tab
│       ├── exonInfo.tab
│       ├── geneInfo.tab
│       ├── sjdbInfo.txt
│       ├── sjdbList.fromGTF.out.tab
│       ├── sjdbList.out.tab
│       └── transcriptInfo.tab
├── reads_qc
│   ├── SRR3405783_fastqc.html
│   └── SRR3405783_fastqc.zip
[...]
```


Affichez enfin la taille occupée par chaque sous-répertoire ainsi que la taille totale avec la commande :

```bash
$ du -csh *
5.3M    counts
24M     genome
117M    genome_index
2.5G    reads
1.5G    reads_map
1.1M    reads_qc
[...]
4.1G    total
```

## Optimiser l'analyse d'un échantillon

L'analyse précédente est complètement automatisée par un script Bash qui rassemble toutes les étapes de l'analyse, mais l'analyse d'un seul échantillon prend environ 25 minutes.

Combien de temps faudrait-il pour analyser 3 échatillons ?

Combien de temps faudrait-il pour analyser les 50 échantillons de *S. cerevisiae* ?

Nous allons essayer d'optimiser l'analyse d'un échantillon pour réduire le temps de calcul. Une première approche consiste à utiliser plusieurs processeurs (coeurs) pour les logiciels qui le supporte. C'est le cas pour `star` et `cuffquant`.

- STAR propose l'option `--runThreadN x` pour utiliser `x` coeurs. 
- Cuffquant propose l'option `--num-threads x` pour utiliser `x` coeurs.

```{note}
Tous les logiciels ne proposent pas le multi-threading, c'est-à-dire l'utilisation de plusieurs coeurs. `htseq-count` par exemple ne prend pas en charge le multi-threading. Pour chaque logiciel, il faut donc le vérifier et trouver l'option adéquate.
```

Téléchargez un nouveau script Bash, [`script_local_2.sh`](script_local_2.sh), avec la commande `wget` :

```bash
$ wget https://raw.githubusercontent.com/pierrepo/unix-tutorial/master/tuto2/script_local_2.sh
```

Ouvrez ce script avec l'éditeur de texte de JupyterLab. Essayer de trouver les différences avec le script précédent.

````{admonition} Solution
:class: tip, dropdown

Lors de l'utilisation de `STAR` pour l'indexation du génome de référence et l'alignement des *reads* sur le génome, l'option `--runThreadN 4` a été ajoutée pour utiliser 4 coeurs.

Lors de l'utilisation de `cuffquant` pour le comptage des transcrits, l'option `--num-threads 4` a été ajoutée pour utiliser 4 coeurs.
````

Supprimez les répertoires qui contiennet les résultats de l'analyse précédente :

```bash
$ rm -rf genome_index reads_qc reads_map counts
```

Puis lancez ce nouveau script :

```bash
$ bash script_local_2.sh
```

Vérifiez que le déroulement du script se passe bien. Quelle étape vous semble la plus longue ?

Normalement, le temps de calcul est passé de 25 minutes à environ 20 minutes. C'est mieux, mais cela représente toujours beaucoup d'heures de calcul pour analyser les 50 échantillons. Nous verrons lors de la prochaine session commment utiliser la puissance d'un cluster de calcul pour réduire le temps d'analyse. 🚀

Mais pour le moment, nous allons automatiser le traitement de plusieurs échantillons dans un même script Bash.


## Répéter une action en Bash

Une boucle permet de répéter un ensemble d'instructions.

Voici un exemple en Bash :

```bash
$ for prenom in gaelle bertrand pierre
> do
> echo "Salut ${prenom} !"
> done
Salut gaelle !
Salut bertrand !
Salut pierre !
```

En sacrifiant un peu de lisibilité, la même commande peut s'écrire sur une seule ligne :

```bash
$ for prenom in gaelle bertrand pierre; do echo "Salut ${prenom} !"; done
Salut gaelle !
Salut bertrand !
Salut pierre !
```

Notez l'utilisation du symbole `;` pour séparer les différents éléments de la boucle.

Une leçon de Software Carpentry aborde la notion de [boucle](https://swcarpentry.github.io/shell-novice/05-loop.html). Prenez quelques minutes pour parcourir cette leçon et comprendre de quoi il s'agit.


## Automatiser l'analyse de 3 échantillons

Le script [`script_local_3.sh`](script_local_3.sh) utilise une boucle pour automatiser l'analyse de plusieurs échantillons. Téléchargez-le avec la commande :

```bash
$ wget https://raw.githubusercontent.com/pierrepo/unix-tutorial/master/tuto2/script_local_3.sh
```

Ouvrez ce script avec l'éditeur de texte de JupyterLab (ou avec `less` dans un terminal). Observez la structure du script et essayez de comprendre son fonctionnement.

- La ligne `set -euo pipefail` tout au début du script va arrêter celui-ci :
    - à la première erreur ;
    - si une variable n'est pas définie ;
    - si une erreur est rencontrée dans une commande avec un *pipe* (`|`).

    C'est une mesure de sécurité importante pour votre script. Si vous le souhaitez, vous pouvez lire l'article de Aaron Maxwell à ce sujet : [Use the Unofficial Bash Strict Mode (Unless You Looove Debugging)](http://redsymbol.net/articles/unofficial-bash-strict-mode/)

- Remarquez également la structure de la boucle qui va automatiser le traitement des 3 échantillons.

- Prêtez également attention, à la toute dernière étape, en dehors de la boucle, qui normalise les comptages des transcrits entre tous les échantillons.

- Enfin, la dernier ligne contient l'instruction `date` qui affiche la date et l'heure lorsque le script se termine. En ayant noté l'heure à laquelle le script a été lancé, cela vous permettra de calculer le temps d'exécution du script.

Lancez le script `script_local_3.sh`. Comme ce script va automatiser toute l'analyse, il va fonctionner pendant plus d'une heure.

```bash
$ bash script_local_3.sh
```

Vérifiez régulièrement votre terminal qu'aucune erreur n'apparaît. Une fois terminé, calculez le temps d'exécution du script.

Le fichier qui contient le comptage normalisé des transcrits est `counts/genes.count_table`.


## Comparer les versions des logiciels utilisés dans Galaxy (si vous avez du temps)

Connectez-vous maintenant à votre compte sur Galaxy. Essayez de retrouver les versions des logiciels que vous avez utilisés (FastQC, STAR, samtools, HTSeq, Cufflinks).

Pour ce faire, dans votre *History*, cliquez sur le nom d'un résultat d'analyse, puis cliquez sur le petit i entouré (ℹ️) et lisez les informations de la section *Job Dependencies*.

Comparez les versions des logiciels disponibles dans Galaxy avec celles que vous avez utilisés sur le cluster.

Comment utilisez-vous la version particulière d'un outil dans Galaxy ?


## Conclusion

Vous avez automatisé votre analyse RNA-seq en regroupant les différentes étapes dans un script Bash. Vous avez également utilisé plusieurs coeurs pour accélérer autant que possible l'analyse. Enfin, vous avez automatisé l'analyse de plusieurs échantillons dans un même script.

Ce n'est pas encore complètement satisfaisant. En effet, il vous faudrait 17 heures de calcul pour analyser les 50 échantillons.

Quelles autres pistes pourriez-vous explorer pour réduire le temps de calcul ?

Nous en discuterons lors de la prochaine session...


## Bonus : aggréger les données produites par HTSeq-count

Si vous analysez plusieurs échantillons, vous souhaiterez peut-être aggréger tous les fichiers produits par HTSeq-count.

Les instructions Bash suivantes pourront vous y aider :

```bash
for name in counts/*/*.txt
do
    echo "${name}"
    # On récupère le nom de l'échantillon
    sample="$(basename -s .txt ${name} | sed 's/count_//g' )"
    # On stocke dans un fichier temporaire pour chaque échantillon
    # un entête avec "gene" et le nom de l'échantillon
    echo -e "${sample}" > "count_${sample}_tmp.txt"
    # On copie le contenu du fichier de comptage dans ce fichier temporaire
    cut -f2 "${name}" >> "count_${sample}_tmp.txt"
done

# On récupère les noms des gènes
echo "gene" > genes.txt
cut -f1 "${name}" >> genes.txt

# On fusionne tous les fichiers
paste genes.txt *tmp.txt > count_all.txt

# On supprime les lignes qui débutent par '__'
# et qui ne sont pas utiles
grep -v "^__" count_all.txt > count_all_clean.txt

# On supprime les fichiers temporaires
rm -f genes.txt *tmp.txt count_all.txt
```
