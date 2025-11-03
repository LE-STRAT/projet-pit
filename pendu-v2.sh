#!/bin/bash

# Liste de mots

mots=("ordinateur" "programmation" "bash" "github" "pendu" "script" "terminal" "developpeur" "virtualisation" "machine" "commande")

# Choix aléatoire d'un mot

mot=${mots[$RANDOM % ${#mots[@]}]}

# Initialisation

mot_affiche=$(echo "$mot" | sed 's/./_/g')
tentatives=11
lettres_tentees=()

# Fonction pour afficher le pendu ASCII selon les erreurs

afficher_pendu() {
erreurs=$((11 - tentatives))
echo ""
case $erreurs in
0)
echo "      *******"
echo "     |/      |"
echo "     |"
echo "     |"
echo "     |"
echo "     |"
echo "__***|***"
;;
1)
echo "      __*****"
echo "     |/      |"
echo "     |      (*)"
echo "     |"
echo "     |"
echo "     |"
echo "*****|***"
;;
2)
echo "      __*****"
echo "     |/      |"
echo "     |      (*)"
echo "     |       |"
echo "     |"
echo "     |"
echo "*****|***"
;;
3)
echo "      __*****"
echo "     |/      |"
echo "     |      (*)"
echo "     |      \|"
echo "     |"
echo "     |"
echo "*****|***"
;;
4)
echo "      __*****"
echo "     |/      |"
echo "     |      (*)"
echo "     |      \|/"
echo "     |"
echo "     |"
echo "*****|***"
;;
5)
echo "      __*****"
echo "     |/      |"
echo "     |      (*)"
echo "     |      \|/"
echo "     |       |"
echo "     |"
echo "*****|***"
;;
6)
echo "      __*****"
echo "     |/      |"
echo "     |      (*)"
echo "     |      \|/"
echo "     |       |"
echo "     |      /"
echo "*****|***"
;;
7|8|9|10|11)
echo "      __*****"
echo "     |/      |"
echo "     |      (*)"
echo "     |      \|/"
echo "     |       |"
echo "     |      / \"
echo "*****|___"
;;
esac
}

echo "Bienvenue dans le jeu du pendu !"
echo "Vous avez $tentatives tentatives pour deviner le mot."

# Boucle principale

while [[ "$mot_affiche" != "$mot" && $tentatives -gt 0 ]]; do
echo ""
echo "Mot : $mot_affiche"
echo "Lettres déjà essayées : ${lettres_tentees[@]}"
echo "Tentatives restantes : $tentatives"

```
read -p "Proposez une lettre : " lettre
lettre=$(echo "$lettre" | tr '[:upper:]' '[:lower:]')

# Vérifie si la lettre a déjà été proposée
if [[ " ${lettres_tentees[@]} " =~ " $lettre " ]]; then
    echo "Vous avez déjà proposé cette lettre !"
    continue
fi

lettres_tentees+=("$lettre")

if [[ "$mot" == *"$lettre"* ]]; then
    # Remplace les "_" par la lettre correcte
    for ((i=0; i<${#mot}; i++)); do
        if [[ "${mot:i:1}" == "$lettre" ]]; then
            mot_affiche="${mot_affiche:0:i}$lettre${mot_affiche:i+1}"
        fi
    done
    echo "Bien joué !"
else
    ((tentatives--))
    echo "Raté !"
fi

afficher_pendu
```

done

# Résultat

if [[ "$mot_affiche" == "$mot" ]]; then
echo ""
echo "🎉 Félicitations ! Vous avez deviné le mot : $mot"
else
echo ""
echo "☠️ Dommage, vous avez perdu. Le mot était : $mot"
fi


