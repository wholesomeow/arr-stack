#!/usr/bin/env bash

source "${BASH_SOURCE%/*}/helpers.sh"

# Pushd to data location on Windows
pushd /mnt/e/

ROOT_FOLDER="arr-stack"
MEDIA_FOLDER="${ROOT_FOLDER}/media"
TORRENTS_FOLDER="${ROOT_FOLDER}/torrents"
CONFIG_FOLDER="$HOME/arr-stack/config"
SECRETS_FILE="$(dirname "${BASH_SOURCE[0]}")/compiled/secrets/arr-secrets.sh"

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

info "Setting permissions for ${ROOT_FOLDER} and ${CONFIG_FOLDER}"
chown -R 1000:1000 $ROOT_FOLDER $CONFIG_FOLDER
chmod -R a=,a+rX,u+w,g+w $ROOT_FOLDER $CONFIG_FOLDER

info "Adding Docker's official GPG key"
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

info "Add the repository to Apt sources"
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

info "Installing core dependencies"
sudo apt update && sudo apt install -y \
    ca-certificates \
    curl \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin \
    pipx \
    sqlite3 \
    python3 \
    python3-dev \
    python3-pip \
    python3-yaml \
    python3-bcrypt

info "Installing Kapitan"
pipx install kapitan
pipx ensurepath

info "Compiling secrets via Kapitan"
kapitan compile --targets secrets

# Make sure the secrets file does actually exist
if [[ ! -f "$SECRETS_FILE" ]]; then
    error "Kapitan secrets file not found at ${SECRETS_FILE}, aborting db seeding"
    exit 1
fi

info "Generating pre-built databases"
(
    source "$SECRETS_FILE"

    ARR_PASSWORD_HASH=$(python3 -c "
import bcrypt, sys
pw = sys.argv[1].encode()
print(bcrypt.hashpw(pw, bcrypt.gensalt(10)).decode())
" "$ARR_ADMIN_PASSWORD")

    for app in "${ARR_APPS[@]}"; do
        DB_PATH="${CONFIG_FOLDER}/${app}/${app}.db"

        if [[ -f "$DB_PATH" ]]; then
            info "Skipping ${app} — db already exists"
            continue
        fi

        info "Seeding ${app} database at ${DB_PATH}"

        sqlite3 "$DB_PATH" <<SQL
CREATE TABLE IF NOT EXISTS Users (
    Id          INTEGER PRIMARY KEY AUTOINCREMENT,
    Identifier  TEXT    NOT NULL UNIQUE,
    Username    TEXT    NOT NULL UNIQUE,
    Password    TEXT    NOT NULL
);
INSERT INTO Users (Identifier, Username, Password)
VALUES (
    lower(hex(randomblob(16))),
    '${ARR_ADMIN_USERNAME}',
    '${ARR_PASSWORD_HASH}'
);
SQL

        chown 1000:1000 "$DB_PATH"
        chmod 640 "$DB_PATH"
        ok "Seeded ${app}"
    done
# Subshell exit — ARR_ADMIN_PASSWORD and hash never exist in parent shell
)

ok "All done c:"
info "Here's what was made:"
tree $ROOT_FOLDER

# Return to where we were
popd
