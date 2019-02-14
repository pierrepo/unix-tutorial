class: center, middle

# Formats & échanges de données

## DU Omiques 2019

Pierre Poulain / @pierrepo

<br /><br /><br /><br /><br /><br />

<div>
<img src="img/logo_DUO.png"
	 height="100px" style="vertical-align:midle;">
 </img>
<div style="display: inline-block; width:100px;"></div>
<img src="img/logo_UPD_USPC.png"
 	 height="120px" style="vertical-align:midle;">
 </img>
</div>

.footer[
Ce contenu est mis à disposition selon les termes de la licence Creative Commons BY-SA 4.0
]

---

layout: true
name: title
class: center, middle
.footer[
DU Omiques 2019
]

---

layout: true
name: contentleft
class: top, left
.footer[
DU Omiques 2019
]

---

layout: true
name: contentcenter
class: top, center
.footer[
DU Omiques 2019
]

---

# Communication

<br />

--

### définir une langue commune

--

### .fas.fa-arrow-down[]

### des protocoles de communication

### .fas.fa-arrow-down[]

### des normes & des formats

---

template: title

# Protocoles de communication

---

# Protocoles de communications
<img src="img/client_servers_1.png"
     height="500px">
</img>


.footnote[
IP : `216.58.205.100`
]

---

# Protocoles de communications

<img src="img/client_servers_2.png"
     height="500px">
</img>

---

# Protocoles de communications

<img src="img/client_servers_3.png"
     height="500px">
</img>

---

# Protocoles de communications

<img src="img/client_servers_4.png"
     height="500px">
 </img>

---

# Protocoles de communications

.pure-table[
| Protocole | Port | Signification |
|-----------|------|:--------------|
| HTTP      | 80   | *Hypertext Transfer Protocol* (`http://`) |
| HTTPS     | 443  | *HyperText Transfer Protocol Secure* (`https://`) |
| FTP       | 21   | *File Transfert Protocol* (`ftp://`) |
| SSH       | 22   | *Secure Shell* |
]

<br /><br /><br /><br /><br />

.footnote[
Pour aller plus loin :
[C’est quoi la différence entre HTTP et HTTPS ?](https://www.culture-informatique.net/cest-quoi-difference-http-https/)
]

---

# Protocoles de communications

.pure-table[
| Protocole | Port | Signification |
|-----------|------|:--------------|
| IMAP      | 143  | *Internet Message Access Protocol* |
| IMAP/TLS  | 993  | *Internet Message Access Protocol* + *Transport Layer Security* |
| SMTP      | 25   | *Simple Mail Transfer Protocol* |
| SMTP/TLS  | 587  | *Simple Mail Transfer Protocol* + *Transport Layer Security* |
]

---

template: title

# Formats (de fichiers)

---

template: contentleft

# Fichiers binaires vs fichiers texte

.center[
<img src="img/fichier-binaire-archive-texte.svg"
     height="500px">
</img>
]

---

template: contentleft

# Formats de fichiers

1. Dressez la liste des formats de fichiers (extension / nom) que vous connaissez (1').

--

2. Mettez en commun avec votre voisin(e) et déterminez s'il s'agit de format binaire ou texte (3').

--

3. Mettez en commun avec le groupe.

---

template: contentleft

# Quelques formats de fichiers

[Document Microsoft Word](https://en.wikipedia.org/wiki/Office_Open_XML) (.docx) :  binaire (en réalité du texte compressé)

[Document Microsoft Excel](https://en.wikipedia.org/wiki/Microsoft_Excel#Binary) (.xls) : binaire

[Image *Joint Photographic Experts Group*](https://en.wikipedia.org/wiki/JPEG) (.jpg / .jpeg), [*Portable Network Graphics*](https://en.wikipedia.org/wiki/Portable_Network_Graphics) (.png) : binaire

[Fichier de données tabulées](https://en.wikipedia.org/wiki/Tab-separated_values) (.tsv) : .green[texte]

[Fichier de données séparées par des virgules](https://en.wikipedia.org/wiki/Comma-separated_values) (.csv) : .green[texte]

[Fichier de séquences FASTA](https://en.wikipedia.org/wiki/FASTA_format) (.fasta / .fa / .tfa / .fna) : .green[texte]

[Fichier de *reads* issus de séquençage haut débit](https://en.wikipedia.org/wiki/FASTQ_format) (.fastq) : .green[texte]

[Fichier de données brutes de spectrométrie de masse](https://en.wikipedia.org/wiki/Mass_spectrometry_data_format) (.raw) : binaire

[Fichier d'échange de données en spectrométrie de masse](https://en.wikipedia.org/wiki/Mass_spectrometry_data_format#mzML) (.mxML) : .green[texte] (mais avec un peu de binaire dedans)

[Document web](https://en.wikipedia.org/wiki/HTML) (.htm / .html) : .green[texte]

[Script R](https://www.r-project.org/) (.R), [Python](https://www.python.org/) (.py) : .green[texte]

---
template: contentleft

# Rappel : format FASTA

```bash
>Identifiant Commentaire
séquence sur 80 caractères (ou 50, 60 ou 70 caractères)
séquence sur 80 caractères (ou 50, 60 ou 70 caractères)
séquence sur 80 caractères (ou 50, 60 ou 70 caractères)
séquence
```

Exemple :

```bash
>gi|5524211|gb|AAD44166.1| cytochrome b [Elephas maximus maximus]
LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV
EWIWGGFSVDKATLNRFFAFHFILPFTMVALAGVHLTFLHETGSNNPLGLTSDSDKIPFHPYYTIKDFLG
LLILILLLLLLALLSPDMLGDPDNHMPADPLNTPLHIKPEWYFLFAYAILRSVPNKLGGVLALFLSIVIL
GLMPFLHTSKHRSMMLRPLSQALFWTLTMDLLTLTWIGSQPVEYPYTIIGQMASILYFSIILAFLPIAGX
IENY
```

---
template: contentleft

<br />

# Quelques particularités du format texte

--

## Le fichier texte c'est : g-é-n-i-a-l  😍 🎉 💪

--

## Mais attention aux caractères de *fin de ligne*


- Windows : *Carriage Return* (*CR*) + *Line Feed* (*LF*) `\(\rightarrow\)` `\r\n`
- Linux : *LF* `\(\rightarrow\)` `\n`
- Mac (depuis Mac OS 10) : *LF* `\(\rightarrow\)` `\n`

--
<br />

## Mais attention aux séparateurs décimaux

- `,` en français (`3,14`)
- `.` en anglais et en informatique (`3.14`)

Utilisez la notation anglaise

---
template: contentleft

# Les bons outils

## Éditeurs de texte

- Windows : [Notepad++](https://notepad-plus-plus.org/fr/) (pas *Bloc-notes*)

- Mac OS X : [BBEdit](https://www.barebones.com/products/bbedit/) ($$), [CotEditor](https://coteditor.com/)

- Linux : vim, emacs, gedit, Atom...

---
template: contentleft

# Les bons outils

Trouver les 5 différences entre les deux dessins

.center[
<img src="img/jeu_cinq_differences.png"
     height="450px">
</img>
]

---
template: contentleft

# Les bons outils

## Différences entre deux fichiers

```bash
>sp|P01308|INS_HUMAN Insulin OS=Homo sapiens OX=9606 GN=INS PE=1 SV=1
MALWMRLLPLLALLALWGPDPAAAFVNQHLCGSHLVEALYLVCGERGFFYTPKTRREAED
LQVGQVELGGGPGAGSLQPLALEGSLQKRGIVEQCCTSICSLYQLENYCN
```

```bash
>sp|Q8HXV2|INS_PONPY Insulin OS=Pongo pygmaeus OX=9600 GN=INS PE=3 SV=1
MALWMRLLPLLALLALWGPDPAQAFVNQHLCGSHLVEALYLVCGERGFFYTPKTRREAED
LQVGQVELGGGPGAGSLQPLALEGSLQKRGIVEQCCTSICSLYQLENYCN
```

.center[
# ?
]

---
template: contentleft

# Les bons outils

## Différences entre deux fichiers : [Meld](http://meldmerge.org/)

<img src="img/meld_insuline.png"
     height="400px">
</img>

.footnote[
Ala23 (homme) `\(\rightarrow\)` Gln23 (orang-outan de Bornéo)
]

---

# Le jeu de données *fil rouge* : *Ostreococcus tauri*

<img src="img/Otauri.jpg"
     height="450px">
</img>

.ref.footnote[
Crédit : Hervé Moreau, Laboratoire Arago. [Image](https://genome.jgi.doe.gov/Ost9901_3/Ost9901_3.home.html)
]

---
background-color: #cccccc

# À vous ! 🚀

.left[

## Exploration du génome de *O. tauri* : 7-zip, Bloc-notes, Notepad++

## Comparaison de deux séquences de déhydrogénase : Meld

## 💻 [Tutoriel](https://omics-school.github.io/formats-echanges-donnees/tutoriel/)
]

--

![](img/giphy-computer.gif)

.left[
Le mois prochain : le *shell* Unix (**deux activités préparatoires**)
]

---
template: contentleft

background-color: #cccccc

# Teasing : le *shell* Unix

.center[
<img src="img/terminal.png"
     height="500px">
</img>
]
