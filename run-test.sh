#!/bin/bash

# Création du dossier de résultats
RESULT_DIR="test-results"
mkdir -p "$RESULT_DIR"

# test type de projet
if [ -f "build.gradle" ]; then
    echo  " projet java "
    if [ ! -x "./gradlew" ]; then
        # Ajout des droits d'exécution
        chmod +x gradlew
    fi

    # execution des test
    ./gradlew clean test

    if [ -d "build/test-results/test" ]; then
        # copie des raport dans le dossier RESULT_DIR
        echo " Copie des rapports JUnit XML..."
        cp build/test-results/test/*.xml "$RESULT_DIR/"
    else
        echo "Aucun rapport XML trouvé. Les tests java ont peut-être échoué."
        exit 1
    fi
elif [ -f "package.json" ]; then
    echo  " projet angular "
    if [ ! -d "node_modules" ]; then
        #read -p "Appuyez sur Entrée pour lancer installer les dépendances"
        # Installation des dépendances 
        npm ci
    fi
    #read -p "Appuyez sur Entrée pour executer les test"
    # execution des test
    npm test 

    # récupération des XML
     if [ -d "reports" ]; then
        #read -p "Appuyez sur Entrée pour copier les rapport"
        cp reports/*.xml "$RESULT_DIR/"
        echo " Copie des rapports Angular "
    else
        #read -p "Appuyez sur Entrée pour confirmer l'echec de generationd es XML"
        echo "Aucun rapport XML trouvé. Les tests angular ont peut-être échoué."
    fi

else 
    #read -p "Appuyez sur Entrée pour confirmer le type de projet non supporter"
    echo " type projet non prevu"
fi


# Vérification finale
if [ -z "$(ls -A $RESULT_DIR)" ]; then
   echo " Le dossier $RESULT_DIR est vide."
else
   echo " test réaliser avec succé"
fi