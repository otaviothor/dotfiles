#!/usr/bin/env bash

## ask password beforehand ##
sudo -v

## variables ##
PROGRAMS_TO_INSTALL=(
  git
  vim
  nodejs
  php
)

## removing any blockages from apt ##
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

## update repository ##
sudo apt update -y

## setting nodejs repository ##
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -

## installing packages .deb ##
# sudo dpkg -i *.deb

## install programs in apt ##
for program in ${PROGRAMS_TO_INSTALL[@]}; do
  if ! dpkg -l | grep -q $program; then ## only install if not already installed
    apt install "$program" -y
  else
    echo "[installed] - $program"
  fi
done

## install composer ##
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php -r "unlink('composer-setup.php');"

## install xampp ##
wget "https://sourceforge.net/projects/xampp/files/XAMPP%20Linux/7.4.16/xampp-linux-x64-7.4.16-0-installer.run/download" -O xampp-installer.run
sudo chmod +x xampp-installer.run
sudo ./xampp-installer.run
sudo rm xampp-installer.run

## install yarn ##
sudo npm install -g yarn -y

## install snap ##
sudo rm /etc/apt/preferences.d/nosnap.pref
sudo apt install snapd

## install brave browser ##
sudo apt install apt-transport-https curl
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser


## finalization, update and cleaning ##
sudo apt update && sudo apt dist-upgrade -y
sudo apt autoclean
sudo apt autoremove -y
