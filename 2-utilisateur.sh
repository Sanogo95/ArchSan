#!/usr/bin/env bash
#-------------------------------------------------------------------------
#     __    ____   ___  _   _  ___    __    _  _ 
#    /__\  (  _ \ / __)( )_( )/ __)  /__\  ( \( )
#   /(__)\  )   /( (__  ) _ ( \__ \ /(__)\  )  ( 
#  (__)(__)(_)\_) \___)(_) (_)(___/(__)(__)(_)\_)
#  Arch Linux Post Install Setup and Config
#-------------------------------------------------------------------------

echo -e "\nINSTALLING AUR SOFTWARE\n"
# You can solve users running this script as root with this and then doing the same for the next for statement. However I will leave this up to you.

echo "CLONING: YAY"
cd ~
git clone "https://aur.archlinux.org/yay.git"
cd ${HOME}/yay
makepkg -si --noconfirm
cd ~
touch "$HOME/.cache/zshhistory"
git clone "https://github.com/ChrisTitusTech/zsh"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/powerlevel10k
ln -s "$HOME/zsh/.zshrc" $HOME/.zshrc

PKGS=(
'autojump'
'awesome-terminal-fonts'
'lightly-git'
'lightlyshaders-git'
'mangohud-common'
'nerd-fonts-fira-code'
'nordic-darker-standard-buttons-theme'
'nordic-darker-theme'
'nordic-kde-git'
'nordic-theme'
'noto-fonts-emoji'
'pamac-all' #Pamac
'papirus-icon-theme'
'sddm-nordic-theme-git'
'ocs-url' # install packages from websites
'timeshift-bin'
'ttf-droid'
'ttf-hack'
'ttf-meslo' # Nerdfont package
'ttf-roboto'

)

for PKG in "${PKGS[@]}"; do
    yay -S --noconfirm $PKG
done

cat <<EOF >> /home/$(whoami)/.config/mpv/mpv.conf
vo=vdpau
profile=opengl-hq
hwdec=vdpau
hwdec-codecs=all
scale=ewa_lanczossharp
cscale=ewa_lanczossharp
interpolation
tscale=oversample
EOF

export PATH=$PATH:~/.local/bin
cp -r $HOME/ArchSan/dotfiles/* $HOME/.config/
pip install konsave
konsave -i $HOME/ArchSan/kde.knsv
sleep 1
konsave -a kde

echo -e "\nDone!\n"
exit
