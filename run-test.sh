#!/bin/bash

# Création du dossier de résultats
RESULT_DIR="test-results"

if [ -d "$RESULT_DIR" ]; then
    # Nettoyage du dossier de rapport
    rm -rf "$RESULT_DIR"
fi

mkdir -p "$RESULT_DIR"

EXIT_CODE=0

# test type de projet
if [ -f "build.gradle" ]; then
    echo  " projet java "
    if [ ! -x "./gradlew" ]; then
        # Ajout des droits d'exécution
        chmod +x gradlew
    fi

    # execution des test
    ./gradlew clean test
    # on stoque le retour de la commande dans exit code
    EXIT_CODE=$?

    if [ -d "build/test-results/test" ]; then
        # copie des raport dans le dossier RESULT_DIR
        echo " Copie des rapports JUnit XML..."
        cp build/test-results/test/*.xml "$RESULT_DIR/" 
    else
        echo "Aucun rapport XML trouvé. Les tests java ont peut-être échoué."
        EXIT_CODE=1
    fi

elif [ -f "package.json" ]; then
    echo  " projet angular "

    rm -rf reports

    if [ ! -d "node_modules" ]; then
        # Installation des dépendances 
        npm ci
    fi
    # execution des test
    npm test 
    EXIT_CODE=$?

    # récupération des XML
     if [ -d "reports" ]; then
        cp reports/*.xml "$RESULT_DIR/"
        echo " Copie des rapports Angular "
    else
        echo "Aucun rapport XML trouvé. Les tests angular ont peut-être échoué."
        EXIT_CODE=1
    fi

else 
    #read -p "Appuyez sur Entrée pour confirmer le type de projet non supporter"
    echo " type projet non prevu"
    exit 1
fi


# Vérification finale
if [ -z "$(ls -A $RESULT_DIR)" ]; then
   echo " Le dossier $RESULT_DIR est vide."
   EXIT_CODE=1
fi

if [ $EXIT_CODE -eq 0 ]; then
    echo " test réaliser avec succé"
else
    echo "Tests échoués (Code: $EXIT_CODE)."
fi


exit $EXIT_CODE