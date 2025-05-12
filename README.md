# Tutoriel Unix

- https://pierrepo.github.io/unix-tutorial/
- [source](https://github.com/pierrepo/unix-tutorial)

## Compilation locale

Reconstruire l'environnement de développement :

```bash
uv sync
```

Compiler le site :

```bash
uv run jupyter-book build content
```

Le site compilé se trouve dans le dossier `content/_build/html`.


## Préparation des fichiers Snakemake

```bash
cd content/tuto3
make snakemake
```


## Licence

![](content/img/CC-BY-SA.png)

Ce contenu est mis à disposition selon les termes de la licence [Creative Commons Attribution - Partage dans les Mêmes Conditions 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/deed.fr) (CC BY-SA 4.0). Consultez le fichier [LICENSE](LICENSE) pour plus de détails.

*This content is released under the [Creative Commons Attribution-ShareAlike 4.0 ](https://creativecommons.org/licenses/by-sa/4.0/deed.en) (CC BY-SA 4.0) license. See the bundled [LICENSE](LICENSE) file for details*.