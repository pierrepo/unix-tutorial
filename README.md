# Le Shell Unix


## Activités préparatoires

[Instructions](activites-preparatoires/)


## Tutoriel *maison*

[Un aperçu rapide du *shell* Unix](tutoriel/README).


## Tutoriel Software Carpentry

[Le cours de Software Carpentry](http://swcarpentry.github.io/shell-novice/) : parties 1, 2, 3, 4 et 7.
Le [mémo](http://swcarpentry.github.io/shell-novice/reference/) des notions abordées.

Pour faire les exercices de Software Carpentry, préparez les données nécessaires avec les commandes suivantes :
```
$ cd
$ wget http://swcarpentry.github.io/shell-novice/data/data-shell.zip
$ unzip data-shell.zip
```


## Installer un *shell* Linux sur sa machine

### Linux et Mac OS X

Si vous travaillez avec les systèmes d'exploitations Linux (Ubuntu, Mint, Debian...) ou Mac OS X, vous avez déjà un *shell* installé sur votre machine.

### Windows

Si vous travaillez avec Windows 10 :

- Vous pouvez installer très rapidement un *shell* Linux. Voici quelques liens pour y arriver :
    + <https://www.windowscentral.com/how-install-bash-shell-command-line-windows-10>
    + <https://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/>
    + <https://www.howtogeek.com/265900/everything-you-can-do-with-windows-10s-new-bash-shell/>

- Depuis un *shell* Linux, votre répertoire utilisateur de Windows est accessible via le chemin

    ```
    /mnt/c/Users/<login-windows>
    ```

    où `<login-windows>` est votre *login* sous Windows. Nous vous conseillons de travailler depuis ce répertoire afin que vos fichiers puissent également être visibles depuis Windows.

Si vous souhaitez simplement un logiciel sous Windows pour vous connecter au serveur du DU en SSH. Nous vous conseillons [MobaXterm](https://mobaxterm.mobatek.net/). La version [*Free*](https://mobaxterm.mobatek.net/download.html) est suffisante. Vous trouverez quelques vidéos de démo [ici](https://mobaxterm.mobatek.net/demo.html).

Pour copier / coller entre Windows et le *shell* Linux :

- Pour copier depuis Windows (<kbd>Ctrl</kbd>+<kbd>C</kbd>) puis coller dans le *shell* : clic droit de la souris.
- Pour copier depuis le *shell* (<kbd>Ctrl</kbd>+<kbd>Maj</kbd>+<kbd>C</kbd>) puis coller dans Windows (<kbd>Ctrl</kbd>+<kbd>V</kbd>)


## De l'aide

Si vous avez besoin d'aide, n'hésitez pas à interroger votre moteur de recherche favori. Une bonne partie des réponses qui vous seront proposées proviendront du site [stackoverflow](https://stackoverflow.com/) qui est *le* forum de discussion en informatique.

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
