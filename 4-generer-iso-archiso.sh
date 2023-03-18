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

# Créer un dossier temporaire pour stocker les fichiers nécessaires
mkdir -p ~/iso-temp/archiso

# Installer les outils nécessaires pour créer l'image ISO
sudo pacman -S archiso

# Copier les fichiers nécessaires depuis l'installation d'Arch Linux
sudo cp -r /usr/share/archiso/configs/releng/* ~/iso-temp/archiso

# Modifier le fichier de configuration pour inclure vos propres packages et paramètres
nano ~/iso-temp/archiso/packages.x86_64

# Construire l'image ISO
cd ~/iso-temp/archiso
sudo ./build.sh -v

# Copier l'image ISO dans votre dossier de choix
sudo cp ~/iso-temp/archiso/out/archlinux*.iso ~/home/$username/

# Supprimer le dossier temporaire
sudo rm -rf ~/iso-temp/archiso