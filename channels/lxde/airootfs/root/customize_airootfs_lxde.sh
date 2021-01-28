#!/usr/bin/env bash

systemctl disable lxdm.service
dnf remove -y lxdm
dnf install -y lightdm lightdm-gtk
systemctl enable lightdm.service
sed -i s/%USERNAME%/${username}/g /etc/lightdm/lightdm.conf
dconf update
# Set os name
sed -i s/%OS_NAME%/"${os_name}"/g /etc/skel/Desktop/calamares.desktop
cp -f /etc/skel/Desktop/calamares.desktop /home/${username}/Desktop/calamares.desktop
# delete xscreen
dnf remove -y xscreensaver-base
# delete dnfdragora
dnf remove -y dnfdragora
# Create Calamares Entry
cp -f /etc/skel/Desktop/calamares.desktop /usr/share/applications/calamares.desktop

unlink /usr/share/backgrounds/images/default.png
ln -s /usr/share/backgrounds/serene-wallpaper-1.png /usr/share/backgrounds/images/default.png

echo -e "sed -i \"s/^autologin/#autologin/g\" /etc/lightdm/lightdm.conf" >> /usr/share/calamares/final-process
sed -i "s/- packages/- shellprocess\n  - removeuser\n  - packages/g" /usr/share/calamares/settings.conf
sed -i "s/sb-shim/grub/g" /usr/share/calamares/modules/bootloader.conf
sed -i "s/fedora/Serene Linux on Fedora/g" /usr/share/calamares/modules/bootloader.conf
sed -i "s/auto/serene/g" /usr/share/calamares/settings.conf
if [[ $boot_splash = true ]]; then
    /usr/sbin/plymouth-set-default-theme serene-logo
fi
