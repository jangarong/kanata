#!/bin/sh

# TODO: Add memos

save_cv() {
    REPO_DIR="$1"
    SAVE_TAR="$2"
    echo "Down containers if they are running ..."
    docker compose down
    echo "Saving $REPO_DIR/volumes/container ..."
    tar -cf "$SAVE_TAR" "$REPO_DIR/volumes/container"
    echo "Done!"
}

save_archive() {
    REPO_DIR="$1"
    SAVE_TAR="$2"
    echo "Down containers if they are running ..."
    docker compose down
    echo "Saving $REPO_DIR/volumes/container/archivebox ..."
    tar -cf "$SAVE_TAR" "$REPO_DIR/volumes/container/archivebox"
    echo "Done!"
}

save_blog() {
    REPO_DIR="$1"
    SAVE_TAR="$2"
    echo "Down containers if they are running ..."
    docker compose down
    echo "Saving $REPO_DIR/volumes/container/ghost ..."
    tar -cf "$SAVE_TAR" "$REPO_DIR/volumes/container/ghost"
    echo "Done!"
}

load_cv() {
    REPO_DIR="$1"
    LOAD_TAR="$2"
    echo "Down containers if they are running ..."
    docker compose down
    echo "Loading $REPO_DIR/volumes/container ..."
    tar -xf "$LOAD_TAR" -C "$REPO_DIR"
    echo "Done!"
}

save_imgs() {
    SAVE_TAR="$1"
    echo "Saving docker images..."
    mkdir -p images # Use -p to create the directory if it doesn't exist
    docker save nginx:1.21.6-alpine -o images/nginx_img.tar
    docker save archivebox/archivebox:0.7.3 -o images/archivebox_img.tar
    docker save pihole/pihole:2025.03.0 -o images/pihole_img.tar
    docker save jangarong/jangarong.github.io:4.2.4 -o images/jangarong_img.tar
    docker save linuxserver/syncthing:1.23.5 -o images/syncthing_img.tar
    docker save hurlenko/filebrowser:v2.29.0 -o images/filebrowser_img.tar
    docker save portainer/portainer-ce:2.18.1 -o images/portainer_img.tar
    docker save ghcr.io/wg-easy/wg-easy -o images/wgeasy_img.tar
    echo "Done saving individual images!"
    echo "Tarring all the images together..."
    tar -cf "$SAVE_TAR" ./images
    echo "Done tarring images!"
    rm -rf images
    echo "Done cleanup!"
}

load_imgs() {
    LOAD_TAR="$1"
    echo "Untarring docker images..."
    tar -xf "$LOAD_TAR"
    echo "Done untarring!"
    if [ -d "images" ]; then
        docker load -i images/nginx_img.tar
        docker load -i images/archivebox_img.tar
        docker load -i images/pihole_img.tar
        docker load -i images/jangarong_img.tar
        docker load -i images/syncthing_img.tar
        docker load -i images/filebrowser_img.tar
        docker load -i images/portainer_img.tar
        docker load -i images/wgeasy_img.tar
        rm -rf images
        echo "Done loading images and cleanup!"
    else
        echo "Error: 'images' directory not found in the tar archive."
    fi
}

help() {
    echo """
==============================
Sunnyvale ./tools.sh
For backups and restorations!
DATA IS IMPORTANT!

Author: JanG & Google Gemini
==============================

save-vol <repo_dir> <save_tar>

    This saves the container volumes in <repo_dir> to <save_tar>.
    Note: This does not save <repo_dir>/volumes/user.
    Please back them up using a separate method.

save-imgs <save_tar>

    This saves the container docker images to <save_tar>.

load-vol <repo_dir> <load_tar>

    This loads the container volumes from <load_tar> into <repo_dir>.
    Note: This does not save <repo_dir>/volumes/user.
    Please back them up using a separate method.

load-imgs <load_tar>

    Loads all images from <load_tar>.

run-archive

    Starts the archive locally

save-archive <save_tar>

    Saves the container volume for archivebox into a tar.

save-blog <save_tar>

    Saves the container volume for ghost into a tar.

start

    Starts sunnyvale containers

stop

    Stops sunnyvale containers

help

    Gets the following help message.
    """
}

case "$1" in
    "save-vol")
        if [ -z "$2" ] || [ -z "$3" ]; then
            echo "Usage: $0 save-vol <repo_dir> <save_tar>"
            exit 1
        fi
        echo "Saving container volumes in repository '$2' to '$3'"
        echo "Note: This does not save '$2'/volumes/user"
        echo "Please back them up using a separate method."
        save_cv "$2" "$3"
        ;;
    "save-imgs")
        if [ -z "$2" ]; then
            echo "Usage: $0 save-imgs <save_tar>"
            exit 1
        fi
        echo "Saving images to '$2'"
        save_imgs "$2"
        ;;
    "load-vol")
        if [ -z "$2" ] || [ -z "$3" ]; then
            echo "Usage: $0 load-vol <repo_dir> <load_tar>"
            exit 1
        fi
        echo "Loading container volumes into repository '$2' from '$3'"
        echo "Note: This does not save '$2'/volumes/user"
        echo "Please back them up using a separate method."
        load_cv "$2" "$3"
        ;;
    "load-imgs")
        if [ -z "$2" ]; then
            echo "Usage: $0 load-imgs <load_tar>"
            exit 1
        fi
        echo "Loading images from '$2'"
        load_imgs "$2"
        ;;
    "run-archive")
        docker compose down
        docker compose -f archive.docker-compose.yml up
        ;;
    "start-browser")
        docker compose down
        docker compose -f archive.docker-compose.yml down
        docker compose -f archive.docker-compose.yml up -d novnc
        echo "Please access http://localhost:8080/vnc.html"
        sleep 5s
        docker compose -f archive.docker-compose.yml run archivebox /usr/bin/chromium-browser --user-data-dir=/data/personas/Default/chrome_profile --profile-directory=Default --disable-gpu --disable-features=dbus --disable-dev-shm-usage --start-maximized --no-sandbox --disable-setuid-sandbox --no-zygote --disable-sync --no-first-run
        ;;
    "stop-browser")
        docker compose -f archive.docker-compose.yml down
        ;;
    "save-archive")
        if [ -z "$2" ] || [ -z "$3" ]; then
            echo "Usage: $0 save-archive <repo_dir> <save_tar>"
            exit 1
        fi
        echo "Saving archive from repo '$2' to '$3'"
        save_archive "$2" "$3"
        ;;
    "save-blog")
        if [ -z "$2" ] || [ -z "$3" ]; then
            echo "Usage: $0 save-blog <repo_dir> <save_tar>"
            exit 1
        fi
        echo "Saving blog from repo '$2' to '$3'"
        save_blog "$2" "$3"
        ;;
    "help")
        help
        ;;
    "start")
        docker compose up -d
        ;;
    "stop")
        docker compose down
        ;;
    *)
        echo "Unrecognized command: '$1'. Run '$0 help' to see list of commands."
        exit 1
        ;;
esac