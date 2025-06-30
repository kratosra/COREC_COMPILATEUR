# Le Compilateur COREC

Le Compilateur COREC est un projet de développement visant à traduire le langage de programmation COREC en code assembleur MIPS. Ce compilateur permet d'exécuter des programmes COREC sur des architectures compatibles MIPS en générant le code assembleur correspondant. Le projet inclut des fonctionnalités essentielles telles que l'affichage de la table des symboles et la gestion de diverses options de compilation via la ligne de commande. Bien que certaines fonctionnalités avancées comme la gestion des erreurs ne soient pas encore entièrement implémentées, le compilateur offre une base solide pour la traduction et l'exécution de programmes COREC simples.

## Table des Matières

- [Introduction](#introduction)
- [Fonctionnalités](#fonctionnalités)
- [Structure du Projet](#structure-du-projet)
- [Installation](#installation)
- [Utilisation](#utilisation)
  - [Options Disponibles](#options-disponibles)
  - [Exemple d'Utilisation](#exemple-dutilisation)
- [Tests](#tests)
  - [Exécution des Tests](#exécution-des-tests)
  - [Structure des Résultats de Tests](#structure-des-résultats-de-tests)
- [Limitations](#limitations)
- [Restrictions](#restrictions)
- [Résultats des Tests](#résultats-des-tests)
- [Licence](#licence)
- [Auteurs](#auteurs)

## Fonctionnalités

- **Traduction de Programmes COREC en Assembleur MIPS** : Conversion des programmes écrits en COREC en code assembleur MIPS.
- **Options de Ligne de Commande** :
  - `--version` : Affiche les informations sur les membres du projet.
  - `--tos` : Affiche la table des symboles du programme compilé.
  - `-o <nom>` : Spécifie le nom du fichier de sortie pour le code assembleur généré.
- **Table des Symboles** : Génération et affichage de la table des symboles utilisée lors de la compilation.
- **Automatisation des Tests** : Scripts Shell pour automatiser les tests des différentes fonctionnalités du compilateur.
- **Gestion Basique des Types** : Support des types `int` et des chaînes de caractères pour les opérations de lecture et d'affichage.

## Structure du Projet

Le projet est organisé de la manière suivante :

```
projet/
├── bin/
│   └── corec            # Exécutable compilé
├── include/
│   └── ...              # Fichiers d'en-tête (.h)
├── src/
│   ├── corec.y          # Fichier Yacc pour l'analyse syntaxique
│   ├── ccorec.l         # Fichier Lex pour l'analyse lexicale
│   ├── mips.c           # Génération du code MIPS
│   ├── treesyn.c        # Construction de l'arbre syntaxique
│   ├── symtab.c         # Gestion de la table des symboles
│   └── dependency.c     # Gestion des dépendances (si applicable)
├── tests/
│   ├── test0.corec
│   ├── test1.corec
│   ├── test2.corec
│   ├── test3.corec
│   ├── test4.corec
│   └── test5.corec
├── test_corec.sh        # Script de tests automatisés
└── Makefile
```

### Description des Fichiers

- **mips.c** : Génération du code assembleur MIPS à partir de l'arbre syntaxique.
- **treesyn.c** : Construction et manipulation de l'arbre syntaxique abstrait (AST).
- **symtab.c** : Implémentation de la table des symboles.
- **dependency.c** : Gestion des dépendances entre modules (si applicable).
- **corec.y** : Grammaire Yacc pour l'analyse syntaxique.
- **ccorec.l** : Règles d'analyse lexicale Lex pour le langage COREC.
- **test_corec.sh** : Automatisation des tests.

## Installation

Utilisez `make` pour compiler le compilateur COREC :

```bash
make
```

L'exécutable `corec` sera généré dans le répertoire `bin/`.

## Utilisation

### Compilation d'un Programme COREC

Pour compiler un fichier source COREC et générer le code assembleur MIPS :

```bash
bin/corec [options] <fichier_source.corec>
```

### Options Disponibles

- **`--version`** : Affiche les informations sur les membres du projet.

  ```bash
  bin/corec --version
  ```

- **`--tos`** : Affiche la table des symboles du programme compilé.

  ```bash
  bin/corec --tos <fichier_source.corec>
  ```

- **`-o <nom>`** : Spécifie le nom du fichier de sortie pour le code assembleur généré. Par défaut, le fichier de sortie est `testN.s`.

  ```bash
  bin/corec -o mon_programme.s <fichier_source.corec>
  ```

### Exemple d'Utilisation

- Compiler un programme et générer un fichier assembleur :

  ```bash
  bin/corec -o hello_world.s tests/test1.corec
  ```

- Afficher la version du compilateur :

  ```bash
  bin/corec --version
  ```

- Afficher la table des symboles :

  ```bash
  bin/corec --tos tests/test1.corec
  ```

## Tests

Le projet inclut un script Shell nommé `test_corec.sh` qui automatise les tests des fonctionnalités principales du compilateur COREC.

### Exécution des Tests

#### Rendre le Script Exécutable

```bash
chmod +x test_corec.sh
```

#### Lancer les Tests

```bash
./test_corec.sh
```

Le script :

- Compile le projet en utilisant le Makefile.
- Teste les options `--version`, `--tos`, et `-o <nom>` sur 5 fichiers de test.
- Génère un résumé des résultats des tests.

#### Nettoyer les Fichiers Générés

Pour supprimer les fichiers compilés et générés lors des tests :

```bash
./test_corec.sh --clean
```

### Structure des Résultats de Tests

Après l'exécution des tests, vous trouverez les fichiers suivants dans le répertoire `tests/` :

- **`version.txt`** : Informations sur les membres du projet.
- **`testN.tos`** : Table des symboles pour chaque fichier de test.
- **`testN.s`** : Code assembleur généré pour chaque fichier de test.
- **`testN.s.log`** : Logs des erreurs lors de la génération des fichiers assembleur.

## Limitations

- **Fonctionnalités du Langage COREC Restreintes** :
  - Pas de support pour les structures de données avancées.
  - Pas de gestion des exceptions.
- **Optimisations du Code Assembleur Limitées**.
- **Bibliothèque Standard Incomplète** : Fonctions avancées non disponibles.
- **Absence de Debugging Intégré**.

## Restrictions

Le compilateur prend uniquement en charge les commandes suivantes dans le langage COREC et produit un code en mips qui génère un code fonctionnel et relativement conforme pour les fonctions pris en charge.:

- **`printstr`** : Pour afficher des chaînes de caractères.
- **`print`** : Pour afficher des valeurs entières.
- **`read`** : Pour lire des valeurs entières.

Toute autre commande ou fonctionnalité avancée n'est pas prise en charge dans cette version.

## Résultats des Tests

### Ce Qui a Réussi

- **Options de Ligne de Commande** :
  - `--version` fonctionne correctement.
  - `--tos` génère correctement la table des symboles.
  - `-o <nom>` génère correctement le fichier assembleur.
- **Table des Symboles** : Génération correcte pour les programmes COREC simples.

### Ce Qui n'a Pas Réussi

- **Gestion des Erreurs** : Messages d'erreur limités.
- **Traduction Avancée** : Limitation à un sous-ensemble des fonctionnalités du langage COREC.

## Licence

Ce projet est réalisé par :

## Auteurs

- **Jadi Ahmed Amine** : Programmeur principal responsable de l'organisation et l'implémentation.
- **Smali Anass** : Programmeur adjoint.
- **El Allaoui Othmane** : Programmeur adjoint.

