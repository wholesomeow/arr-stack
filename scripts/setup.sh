#!/usr/bin/env bash

source "${BASH_SOURCE%/*}/helpers.sh"

# Pushd to data location on Windows
pushd /mnt/e/

ROOT_FOLDER="arr-stack"
MEDIA_FOLDER="${ROOT_FOLDER}/media"
TORRENTS_FOLDER="${ROOT_FOLDER}/torrents"
CONFIG_FOLDER="$HOME/arr-stack/config"

info "Starting arr-stack setup"

# Create the folder structure
mkdir -p $ROOT_FOLDER

# for media
mkdir -p $MEDIA_FOLDER
mkdir -p $MEDIA_FOLDER/downloads
mkdir -p $MEDIA_FOLDER/downloads/complete
mkdir -p $MEDIA_FOLDER/downloads/incomplete

mkdir -p $MEDIA_FOLDER/anime
mkdir -p $MEDIA_FOLDER/movies
mkdir -p $MEDIA_FOLDER/music
mkdir -p $MEDIA_FOLDER/tv

info "Finished creating media folders"

# for torrents
mkdir -p $TORRENTS_FOLDER
mkdir -p $TORRENTS_FOLDER/anime
mkdir -p $TORRENTS_FOLDER/movies
mkdir -p $TORRENTS_FOLDER/music
mkdir -p $TORRENTS_FOLDER/tv

info "Finished creating torrents folders"

# for configs
mkdir -p $CONFIG_FOLDER
mkdir -p $CONFIG_FOLDER/sonarr
mkdir -p $CONFIG_FOLDER/radarr
mkdir -p $CONFIG_FOLDER/prowlarr
mkdir -p $CONFIG_FOLDER/lidarr
mkdir -p $CONFIG_FOLDER/bazarr
mkdir -p $CONFIG_FOLDER/flaresolverr
mkdir -p $CONFIG_FOLDER/qbittorrent
mkdir -p $CONFIG_FOLDER/jellyfin

info "Finished creating config folders"

# Set permissions
chown -R 1000:1000 $ROOT_FOLDER
chmod -R a=,a+rX,u+w,g+w $ROOT_FOLDER

# Install docker/docker compose
# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

ok "All done c:"
info "Here's what was made:"
tree $ROOT_FOLDER

# Return to where we were
popd
