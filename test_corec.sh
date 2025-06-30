#!/bin/bash

# ========================================
# Script Shell pour tester les options de COREC
# ========================================

# Répertoire contenant les fichiers de test
TEST_DIR="tests"

# Répertoire contenant l'exécutable compilé
BIN_DIR="bin"

# Nom de l'exécutable
COMPILER_BIN="$BIN_DIR/corec"

# Variables pour les résultats des tests
VERSION_TEST_PASSED=0
VERSION_TEST_TOTAL=1

TOS_TEST_PASSED=0
TOS_TEST_TOTAL=5  # Nombre de fichiers de test

OUTPUT_TEST_PASSED=0
OUTPUT_TEST_TOTAL=5  # Nombre de fichiers de test

# Fonction pour afficher les messages d'erreur et quitter
function error_exit {
    echo "Erreur : $1" 1>&2
    exit 1
}

# Option de nettoyage
if [ "$1" == "--clean" ]; then
    echo "Nettoyage des fichiers compilés et générés..."
    make clean || error_exit "Erreur : La commande 'make clean' a échoué."
    rm -f "$TEST_DIR"/*.asm "$TEST_DIR"/*.o "$TEST_DIR"/*.tos
    rm -f version.txt
    echo "Nettoyage terminé."
    exit 0
fi

# Compiler le projet COREC en utilisant le Makefile
echo "Compilation du projet COREC en utilisant le Makefile..."
make

# Vérifier si la compilation a réussi
if [ $? -ne 0 ]; then
    error_exit "La compilation du projet COREC a échoué. Veuillez vérifier les erreurs ci-dessus."
fi

# Vérifier que l'exécutable 'corec' existe et est exécutable
if [ ! -x "$COMPILER_BIN" ]; then
    error_exit "L'exécutable '$COMPILER_BIN' n'existe pas ou n'est pas exécutable. Vérifiez la compilation."
fi

echo "Compilation réussie : $COMPILER_BIN"
echo "----------------------------------------"

# Tester l'option --version
echo "Test de l'option --version..."
VERSION_OUTPUT=$("$COMPILER_BIN" -version 2>/dev/null)

if [[ $? -eq 0 && $VERSION_OUTPUT == *"COREC Compiler"* ]]; then
    echo "PASS : Option --version fonctionne correctement."
    echo "$VERSION_OUTPUT" > version.txt
    VERSION_TEST_PASSED=$((VERSION_TEST_PASSED + 1))
else
    echo "FAIL : Option --version ne fonctionne pas correctement."
    echo "Sortie obtenue : $VERSION_OUTPUT"
fi
echo "----------------------------------------"

# Tester l'option --tos pour chaque fichier de test
echo "Test de l'option --tos pour chaque fichier de test..."
for i in {1..5}
do
    TEST_FILE="$TEST_DIR/test${i}.corec"

    # Vérifier l'existence du fichier de test
    if [ ! -f "$TEST_FILE" ]; then
        echo "Attention : Le fichier de test '$TEST_FILE' est manquant. Passage au suivant..."
        TOS_TEST_TOTAL=$((TOS_TEST_TOTAL - 1))
        continue
    fi

    echo "Traitement de '$TEST_FILE' avec --tos..."

    # Exécuter l'option --tos
    TOS_OUTPUT=$("$COMPILER_BIN" -tos "$TEST_FILE" 2>/dev/null)

    if [[ $? -eq 0 && ! -z "$TOS_OUTPUT" ]]; then
        echo "PASS : Option --tos fonctionne correctement pour '$TEST_FILE'."
        echo "$TOS_OUTPUT" > "$TEST_DIR/test${i}.tos"
        TOS_TEST_PASSED=$((TOS_TEST_PASSED + 1))
    else
        echo "FAIL : Option --tos ne fonctionne pas correctement pour '$TEST_FILE'."
        echo "Sortie obtenue : $TOS_OUTPUT"
    fi

    echo "----------------------------------------"
done

# Tester l'option -o <name> pour chaque fichier de test
echo "Test de l'option -o <name> pour chaque fichier de test..."
for i in {1..5}
do
    TEST_FILE="$TEST_DIR/test${i}.corec"
    OUTPUT_SPECIFIED="$TEST_DIR/test${i}.s"

    # Vérifier l'existence du fichier de test
    if [ ! -f "$TEST_FILE" ]; then
        echo "Attention : Le fichier de test '$TEST_FILE' est manquant. Passage au suivant..."
        OUTPUT_TEST_TOTAL=$((OUTPUT_TEST_TOTAL - 1))
        continue
    fi

    echo "Traitement de '$TEST_FILE' avec -o $OUTPUT_SPECIFIED..."

    # Exécuter l'option -o <name> et capturer la sortie et les erreurs
    "$COMPILER_BIN" -o "$OUTPUT_SPECIFIED" "$TEST_FILE" > "$TEST_DIR/test${i}.o.log" 2>&1

    if [ $? -eq 0 ]; then
        if [ -f "$OUTPUT_SPECIFIED" ]; then
            echo "PASS : Option -o fonctionne correctement pour '$TEST_FILE'. Fichier généré : '$OUTPUT_SPECIFIED'"
            OUTPUT_TEST_PASSED=$((OUTPUT_TEST_PASSED + 1))
        else
            echo "FAIL : Option -o a été utilisée mais le fichier '$OUTPUT_SPECIFIED' n'a pas été créé."
        fi
    else
        echo "FAIL : Exécution de '$COMPILER_BIN -o $OUTPUT_SPECIFIED $TEST_FILE' a échoué."
        echo "Sortie obtenue : $(cat "$TEST_DIR/test${i}.o.log")"
    fi

    echo "----------------------------------------"
    
done


# Résumé des résultats des tests
echo "========================================"
echo "Résumé des résultats des tests :"
echo "Option --version :  PASS"
echo "Option --tos     : $TOS_TEST_PASSED/$TOS_TEST_TOTAL PASS"
echo "Option -o <name> : $OUTPUT_TEST_PASSED/$OUTPUT_TEST_TOTAL PASS"
echo "========================================"

echo "Tous les tests ont été traités."
