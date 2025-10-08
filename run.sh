#!/bin/bash

set -e

UNSAFE_DIRS=(
    "$HOME"
    "$HOME/.config"
    "$HOME/.local"
    "$HOME/.local/share"
    "$HOME/.local/state"
    "$HOME/.var"
    "$HOME/.var/app"
)
BASHINIT_FILE="$(dirname "$(realpath "${BASH_SOURCE[0]}")")/.bash_init"

# load dir path: first from parameter, if missing from local file
[[ "$#" -gt 0 ]] && DIR_PATH="$(realpath "$1")"
MOUNT_DIR_FILE="$(dirname "$(realpath "${BASH_SOURCE[0]}")")/.mount_dir"
[[ "$#" == 0 ]] && [[ -f "$MOUNT_DIR_FILE" ]] && DIR_PATH="$(realpath "$(cat "$MOUNT_DIR_FILE")")"

# checks on string to mount
[[ "$DIR_PATH" == '' ]] && echo "File '$MOUNT_DIR_FILE' is missing, and so is parameter from input!" && exit 1
if [ ! -d "$DIR_PATH" ] || [ ! -w "$DIR_PATH" ] || [ ! -O "$DIR_PATH" ]; then
    echo "invalid directory: '$DIR_PATH'"
    exit 1
fi
for UNSAFE_DIR in "${UNSAFE_DIRS[@]}"; do 
    [[ "$DIR_PATH" == "$UNSAFE_DIR" ]] && echo "'$UNSAFE_DIR' is an unsafe directory to mount!" && exit 1
done

# all volumes to mount
volumes=(-v "$DIR_PATH":/data)
[[ -f "$BASHINIT_FILE" ]] && volumes+=(-v "$BASHINIT_FILE:/root/.bash_init")

# launch container
podman --root "/tmp/script-podman-images-$(id -u)" run -it --rm \
    --init \
    -e "TZ=$(timedatectl show --property=Timezone --value)" \
    --detach-keys="" \
    --security-opt label=type:container_runtime_t \
    "${volumes[@]}" \
    -w /data \
    ghcr.io/danix1234/hpcdev bash
