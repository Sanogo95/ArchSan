#!/bin/bash

    bash 0-preinstall.sh
    arch-chroot /mnt /root/ArchSan/1-setup.sh
    source /mnt/root/ArchSan/install.conf
    arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/ArchSan/2-user.sh
    arch-chroot /mnt /root/ArchSan/3-post-setup.sh