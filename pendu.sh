# --- Liste de mots possibles ---
mots=("ordinateur" "voiture" "chat" "maison" "banane" "bash" "pendu" "avion" "python")

# --- Choisir un mot au hasard ---
mot=${mots[$RANDOM % ${#mots[@]}]}
longueur=${#mot}

# --- Variables du jeu ---
essais=8
mot_cache=$(printf '_%.0s' $(seq 1 $longueur))
lettres_utilisees=""

# --- Fonction d'affichage ---
afficher_mot() {
    for ((i=0; i<$longueur; i++)); do
        echo -n "${mot_cache:$i:1} "
    done
    echo
}

clear
echo "=== Jeu du PENDU ==="
echo "Devine le mot ! Tu as $essais essais."

# --- Boucle principale ---
while [ $essais -gt 0 ]; do
    echo
    afficher_mot
    echo "Lettres utilisées : $lettres_utilisees"
    echo -n "Entre une lettre : "
    read -n1 lettre
    echo

    # Vérifier si déjà utilisée
    if [[ $lettres_utilisees == *$lettre* ]]; then
        echo "Tu as déjà utilisé cette lettre."
        continue
    fi

    lettres_utilisees+="$lettre "

    # Vérifier si la lettre est dans le mot
    if [[ $mot == *$lettre* ]]; then
        echo "Bonne lettre ! :)"
        nouveau_mot=""
        for ((i=0; i<$longueur; i++)); do
            if [ "${mot:$i:1}" == "$lettre" ]; then
                nouveau_mot+="$lettre"
            else
                nouveau_mot+="${mot_cache:$i:1}"
            fi
        done
        mot_cache=$nouveau_mot
    else
        echo "Mauvaise lettre. :("
        ((essais--))
        echo "Il te reste $essais essais."
    fi

    # Vérifier victoire
    if [ "$mot_cache" == "$mot" ]; then
        echo
        echo "🎉 Bravo ! Tu as trouvé le mot : $mot"
        exit 0
    fi
done

echo
echo "x( Perdu ! Le mot était : $mot"


