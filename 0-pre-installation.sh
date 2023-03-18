#!/usr/bin/env bash
#-------------------------------------------------------------------------
#     __    ____   ___  _   _  ___    __    _  _ 
#    /__\  (  _ \ / __)( )_( )/ __)  /__\  ( \( )
#   /(__)\  )   /( (__  ) _ ( \__ \ /(__)\  )  ( 
#  (__)(__)(_)\_) \___)(_) (_)(___/(__)(__)(_)\_)
#  Arch Linux Post Install Setup and Config
#-------------------------------------------------------------------------

echo "----------------------------------------------------------------"
echo "     Configuration de miroirs pour un téléchargement optimal    "
echo "----------------------------------------------------------------"
iso=$(curl -4 ifconfig.co/country-iso)
timedatectl set-ntp true
pacman -S --noconfirm pacman-contrib terminus-font
setfont ter-v22b
pacman -S --noconfirm reflector rsync
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
reflector -a 48 -c $iso -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist
mkdir /mnt


echo -e "\nInstalling prereqs...\n$HR"
pacman -S --noconfirm gptfdisk btrfs-progs

echo "-------------------------------------------------"
echo "-------sélectionnez votre disque à formater-------"
echo "-------------------------------------------------"
lsblk
echo "Veuillez saisir le disque sur lequel travailler: (exemple /dev/sda)"
read DISK
echo "CELA FORMATERA ET SUPPRIMERA TOUTES LES DONNÉES SUR LE DISQUE"
read -p "êtes-vous sûr de vouloir continuer (Y/N) ::" formatdisk
case $formatdisk in

y|Y|yes|Yes|YES)
echo "--------------------------------------"
echo -e "\nFormatage du disque...\n$HR"
echo "--------------------------------------"

# préparation du disque
sgdisk -Z ${DISK} # tout zapper sur disque
sgdisk -a 2048 -o ${DISK} # nouvel alignement du disque gpt 2048

# create partitions
sgdisk -n 1:0:+1000M ${DISK} # partition 1 (UEFI SYS), bloc de démarrage par défaut, 512 Mo
sgdisk -n 2:0:0     ${DISK} # partition 2 (racine), démarrage par défaut, restant

# set partition types
sgdisk -t 1:ef00 ${DISK}
sgdisk -t 2:8300 ${DISK}

# label partitions
sgdisk -c 1:"UEFISYS" ${DISK}
sgdisk -c 2:"ROOT" ${DISK}

# make filesystems
echo -e "\nCreating Filesystems...\n$HR"

mkfs.vfat -F32 -n "UEFISYS" "${DISK}1"
mkfs.btrfs -L "ROOT" "${DISK}2"
mount -t btrfs "${DISK}2" /mnt
btrfs subvolume create /mnt/@
umount /mnt
;;
esac

# mount target
mount -t btrfs -o subvol=@ "${DISK}2" /mnt
mkdir /mnt/boot
mkdir /mnt/boot/efi
mount -t vfat "${DISK}1" /mnt/boot/

echo "--------------------------------------"
echo "-- Arch Install on Main Drive       --"
echo "--------------------------------------"
pacstrap /mnt base base-devel linux linux-firmware vim nano sudo archlinux-keyring wget libnewt --noconfirm --needed
genfstab -U /mnt >> /mnt/etc/fstab
echo "keyserver hkp://keyserver.ubuntu.com" >> /mnt/etc/pacman.d/gnupg/gpg.conf
echo "--------------------------------------"
echo "-- Bootloader Systemd Installation  --"
echo "--------------------------------------"
bootctl install --esp-path=/mnt/boot
[ ! -d "/mnt/boot/loader/entries" ] && mkdir -p /mnt/boot/loader/entries
cat <<EOF > /mnt/boot/loader/entries/arch.conf
title Arch Linux  
linux /vmlinuz-linux  
initrd  /initramfs-linux.img  
options root=${DISK}2 rw rootflags=subvol=@
EOF
cp -R ~/ArchMatic /mnt/root/
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
echo "--------------------------------------"
echo "-- SYSTÈME PRÊT POUR 1-installation --"
echo "--------------------------------------"
