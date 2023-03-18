#!/usr/bin/env bash
#-------------------------------------------------------------------------
#     __    ____   ___  _   _  ___    __    _  _ 
#    /__\  (  _ \ / __)( )_( )/ __)  /__\  ( \( )
#   /(__)\  )   /( (__  ) _ ( \__ \ /(__)\  )  ( 
#  (__)(__)(_)\_) \___)(_) (_)(___/(__)(__)(_)\_)
#  Arch Linux Post Install Setup and Config
#-------------------------------------------------------------------------

echo -e "\nCRÉER ISO DE LA DISTRIBUTION"

# ------------------------------------------------------------------------

# Récupération du nom de l'image ISO
echo "Entrez le nom de l'image ISO que vous voulez créer (sans extension) : "
read image_name

# Création de l'image ISO
echo "Création de l'image ISO en cours..."
sudo pacman -Syyu && sudo pacman -S cdrkit
sudo genisoimage -R -J -l -o "${image_name}.iso" -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table ./

# Copie de l'image ISO sur votre ordinateur
echo "Copie de l'image ISO sur votre ordinateur en cours..."
echo "Entrez le nom d'utilisateur de votre ordinateur : "
read username
echo "Entrez l'adresse IP de votre ordinateur : "
read ip_address
scp "${image_name}.iso" "${username}@${ip_address}:~/"
echo "L'image ISO a été copiée sur votre ordinateur avec succès !"