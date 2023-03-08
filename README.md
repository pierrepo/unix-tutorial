# Le Shell Unix

## Tutoriel *maison*

[Un aperçu rapide du *shell* Unix](tutoriel/README).

C'est par ce tutoriel que vous devez débuter.

## Tutoriel Software Carpentry

[Un autre tutoriel](software_carpentry) pour poursuivre votre découverte d'Unix.


## Trucs et astuces

### Copier / coller

Pour copier / coller entre Windows et le *shell* Linux :

- Pour copier depuis Windows (<kbd>Ctrl</kbd>+<kbd>C</kbd>) puis coller dans le *shell* : clic droit de la souris.
- Pour copier depuis le *shell* (<kbd>Ctrl</kbd>+<kbd>Maj</kbd>+<kbd>C</kbd>) puis coller dans Windows (<kbd>Ctrl</kbd>+<kbd>V</kbd>)

### Répertoire utilisateur Windows et Unix (dans WSL)


Depuis un shell Linux, votre répertoire utilisateur de Windows est accessible via le chemin
```
/mnt/c/Users/omics
```
`omics` désigne ici votre login Windows sur les machines du DU.

Nous vous demandons de **travailler depuis ce répertoire** afin que vos fichiers puissent également être visibles depuis Windows.


## Installer un *shell* Linux sur sa propre machine

### Linux et Mac OS X

Si vous travaillez avec les systèmes d'exploitations Linux (Ubuntu, Mint, Debian...) ou Mac OS X, vous avez déjà un *shell* installé sur votre machine.

### Windows

Si vous travaillez avec Windows 10, suivez cette documentation :

<https://github.com/pierrepo/intro-wsl>





## De l'aide 🆘

Si vous avez besoin d'aide, interrogez votre moteur de recherche favori. Une bonne partie des réponses qui vous seront proposées proviendront du site [stackoverflow](https://stackoverflow.com/) qui est *le* forum de discussion en informatique.

Les deux tutoriels ci-dessus vous invitent à consulter le manuel (commande `man`) quand vous avez un doute sur le fonctionnement d'une commande. La documentation du manuel est quasi-exhaustive mais peu conviviale. Le site [TLDR pages](https://tldr.sh/) propose une aide concise sur les commandes Unix et leurs principales options. Par exemple, pour la commande [ls](https://tldr.ostera.io/ls).

Enfin, le site [explainshell](https://explainshell.com/) explique le rôle des différentes options utilisées dans une commande. Par exemple pour décompresser une archive avec la commande [tar](https://explainshell.com/explain?cmd=tar%20xzvf%20archive.tar.gz).


## Bibliographie / webographie

Livre :

- [Bioinformatics Data Skills](http://shop.oreilly.com/product/0636920030157.do), Vince Buffalo, O'Reilly Media, 2015.

Sites internet :

- [The UNIX Shell](http://swcarpentry.github.io/shell-novice/), cours en ligne de *Software Carpentry*.
- [Unix Fondamentals](https://edu.sib.swiss/pluginfile.php/2878/mod_resource/content/4/couselab-html/content.html), du *Swiss Institute of Bioinformatics*.


## Licence

![](img/CC-BY-SA.png)

Ce contenu est mis à disposition selon les termes de la licence [Creative Commons Attribution - Partage dans les Mêmes Conditions 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/deed.fr) (CC BY-SA 4.0). Consultez le fichier [LICENSE](LICENSE) pour plus de détails.

This content is released under the [Creative Commons Attribution-ShareAlike 4.0 ](https://creativecommons.org/licenses/by-sa/4.0/deed.en) (CC BY-SA 4.0) license. See the bundled [LICENSE](LICENSE) file for details.
