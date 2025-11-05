#!/bin/bash
# pendu.sh - jeu du pendu (11 tentatives) - utilise mots.txt si présent

set -u

# Nombre maximum d'erreurs autorisées (ici 11 - le pendu complet)
MAX_ATTEMPTS=11

# ----- Charger le mot -----
# Si mots.txt existe et contient au moins une ligne, on prend un mot au hasard.
# Sinon on utilise une liste interne de secours.
if [[ -s "mots.txt" ]]; then
    # shuf sélectionne une ligne aléatoire ; on supprime espaces/tabs de début/fin
    mot=$(shuf -n1 mots.txt | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
else
    # liste de secours
    mots=("ordinateur" "programmation" "bash" "github" "pendu" "script" "terminal" "developpeur" "virtualisation" "machine" "commande")
    mot=${mots[$RANDOM % ${#mots[@]}]}
fi

# Normaliser en minuscules (évite les différences entre A et a)
mot=$(echo "$mot" | tr '[:upper:]' '[:lower:]')

# Vérifier que le mot n'est pas vide après nettoyage
if [[ -z "$mot" ]]; then
    echo "Erreur : le mot choisi est vide. Vérifie le fichier mots.txt."
    exit 1
fi

# ----- Initialisation -----
mot_affiche=$(echo "$mot" | sed 's/./_/g')  # chaine de _ de la bonne longueur
attempts_left=$MAX_ATTEMPTS
lettres_tentees=()  # tableau des lettres déjà proposées

# Fonction d'affichage du pendu en 11 étapes (0 = rien, 11 = pendu complet)
afficher_pendu() {
    erreurs=$((MAX_ATTEMPTS - attempts_left))
    echo ""
    case $erreurs in
        0)
            echo "      _______"
            echo "     |/      |"
            echo "     |"
            echo "     |"
            echo "     |"
            echo "     |"
            echo "_____|___"
            ;;
        1)
            echo "      _______"
            echo "     |/      |"
            echo "     |      (_)"
            echo "     |"
            echo "     |"
            echo "     |"
            echo "_____|___"
            ;;
        2)
            echo "      _______"
            echo "     |/      |"
            echo "     |      (_)"
            echo "     |       |"
            echo "     |"
            echo "     |"
            echo "_____|___"
            ;;
        3)
            echo "      _______"
            echo "     |/      |"
            echo "     |      (_)"
            echo "     |      \\|"
            echo "     |"
            echo "     |"
            echo "_____|___"
            ;;
        4)
            echo "      _______"
            echo "     |/      |"
            echo "     |      (_)"
            echo "     |      \\|/"
            echo "     |"
            echo "     |"
            echo "_____|___"
            ;;
        5)
            echo "      _______"
            echo "     |/      |"
            echo "     |      (_)"
            echo "     |      \\|/"
            echo "     |       |"
            echo "     |"
            echo "_____|___"
            ;;
        6)
            echo "      _______"
            echo "     |/      |"
            echo "     |      (_)"
            echo "     |      \\|/"
            echo "     |       |"
            echo "     |      /"
            echo "_____|___"
            ;;
        7)
            echo "      _______"
            echo "     |/      |"
            echo "     |      (_)"
            echo "     |      \\|/"
            echo "     |       |"
            echo "     |      / \\"
            echo "_____|___"
            ;;
        8)
            echo "      _______"
            echo "     |/      |"
            echo "     |     \\(_)/"
            echo "     |      \\|/"
            echo "     |       |"
            echo "     |      / \\"
            echo "_____|___"
            ;;
        9)
            echo "      _______"
            echo "     |/      |"
            echo "     |     \\(_)/"
            echo "     |      \\|/"
            echo "     |     --|--"
            echo "     |      / \\"
            echo "_____|___"
            ;;
        10)
            echo "      _______"
            echo "     |/      |"
            echo "     |     \\(_)/"
            echo "     |    --\\|/--"
            echo "     |     --|--"
            echo "     |      / \\"
            echo "_____|___"
            ;;
        *)
            # 11 ou plus -> pendu complet (état final)
            echo "      _______"
            echo "     |/      |"
            echo "     |     \\(_)/"
            echo "     |    --\\|/--"
            echo "     |     --|--"
            echo "     |      / \\"
            echo "_____|___"
            ;;
    esac
    echo ""
}

# ----- Jeu -----
echo "Bienvenue dans le jeu du pendu !"
echo "Vous avez $attempts_left tentatives pour deviner le mot."
afficher_pendu

while [[ "$mot_affiche" != "$mot" && $attempts_left -gt 0 ]]; do
    # Affichage du mot (horizontal) et lettres déjà essayées
    echo "Mot : $(echo "$mot_affiche" | sed 's/./& /g')"
    if [[ ${#lettres_tentees[@]} -gt 0 ]]; then
        echo "Lettres déjà essayées : ${lettres_tentees[*]}"
    else
        echo "Lettres déjà essayées : (aucune)"
    fi
    echo "Tentatives restantes : $attempts_left"

    # Lire une lettre valide (une seule lettre a-z)
    read -p "Proposez une lettre : " lettre_raw
    lettre=$(echo "$lettre_raw" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]' | tr -d '\r')

    # Validation entrée
    if [[ -z "$lettre" ]]; then
        echo "Veuillez saisir une lettre."
        continue
    fi
    if [[ ! "$lettre" =~ ^[a-z]$ ]]; then
        echo "Entrée invalide. Saisissez une seule lettre (a-z)."
        continue
    fi

    # Déjà essayé ?
    if [[ " ${lettres_tentees[*]} " =~ " $lettre " ]]; then
        echo "Vous avez déjà proposé la lettre '$lettre'."
        continue
    fi

    # Ajouter à la liste des tentatives
    lettres_tentees+=("$lettre")

    # Vérifier si la lettre est dans le mot
    if [[ "$mot" == *"$lettre"* ]]; then
        # Remplacer chaque "_" correspondant par la lettre
        for ((i=0; i<${#mot}; i++)); do
            if [[ "${mot:i:1}" == "$lettre" ]]; then
                mot_affiche="${mot_affiche:0:i}$lettre${mot_affiche:i+1}"
            fi
        done
        echo "Bien joué !"
    else
        ((attempts_left--))
        echo "Raté..."
    fi

    afficher_pendu
done

# Résultat final
if [[ "$mot_affiche" == "$mot" ]]; then
    echo " Félicitations ! Vous avez deviné le mot : $mot"
else
    echo " Dommage, vous avez perdu. Le mot était : $mot"
fi



