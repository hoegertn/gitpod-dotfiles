#!/bin/bash

mkdir -p ~/.m2

ln -sf ~/.dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/bash ~/.bashrc.d/90-hoegertn
ln -sf ~/.dotfiles/maven-settings.xml ~/.m2/settings.xml

echo 'pinentry-mode loopback' >> ~/.gnupg/gpg.conf
