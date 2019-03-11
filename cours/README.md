# Un rapide tour du shell Unix

Le *shell* Unix est un programme qui attend un ordre de la part de l'utilisateur, exécute cet ordre, affiche le résultat puis attend à nouveau un ordre.

Le *shell* fonctionne sur un ordinateur, qui n'a aucune capacité d'abstraction ou d'intuition. Pour que ces ordres puissent être compris et exécutés, il faut qu'ils respectent des règles bien précises.

## Invite de commande

Convention :
```
$
```

## Exploration de répertoires et fichiers.

Une commande très utile est la commande `pwd` qui signifie *print working directory* et qui affiche le nom du répertoire courant.

Par exemple :
```
$ pwd
/home/pierre
```
Cela signifie que je me trouve actuellement dans le répertoire `/home/pierre`.

Sous Unix, les répertoires et les fichiers sont organisés sous forme d'une structure en arbre. On parle d'arborescence. Le répertoire principale est le `/` qu'on appelle la « racine » (*root* en anglais), les différents sous-répertoire sont séparés les uns des autres par le caractère `/`.

Dans le cas de `/home/pierre`, on se trouve dans le répertoire `pierre` qui est lui-même est sous-répertoire de `home` qui est lui même un sous-répertoire de `/` (la racine).

Attention, ne confondez `/` qui tout au début signifie la racine de `/` qui sépare deux répertoires.

`/home/pierre` est aussi appelé un « chemin » car il indique la succession des répertoires à suivre pour arriver jusqu'à `pierre`.

Lorsqu'un chemin débute par `/` (la racine), on parle de **chemin absolu**. Il existe aussi des **chemins relatifs**, donc qui ne débutent pas par `/`, que nous verrons plus tard.

## Trucs et astuces

Flèche du haut <kbd>↑</kbd> pour rappeler une commande.

La touche tabulation <kbd>Tab</kbd> pour compléter une commande, un nom de répertoire ou de fichier. Appuyez deux fois sur <kbd>Tab</kbd> en cas d’ambiguïté.

<kbd>Ctrl</kbd> + <kbd>C</kbd> pour annuler une commande en cours. Presser la touche <kbd>Ctrl</kbd> et la touche <kbd>C</kbd> en même temps.

### Copier / coller




## Exploration du contenu des fichiers

## Manipulation de données
