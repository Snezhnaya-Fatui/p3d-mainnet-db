#!/bin/bash

# GitHub username and repository name
GITHUB_USER="Snezhnaya-Fatui"
GITHUB_REPO="p3d-mainnet-db"

# Fetching the latest release tag
latest_release=$(curl -s "https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
echo "Latest release tag: ${latest_release}"

# Download directory
download_dir="./downloads"
mkdir -p "${download_dir}"

# Downloading the latest release parts of db
for ((i=1; i<=11; i++)); do
    part=$(printf "%03d" $i)
    url="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/releases/download/${latest_release}/db.7z.${part}"
    echo "Downloading ${url} ..."
    wget -nv --show-progress -P "${download_dir}" "${url}" &
done

# Waiting for all download tasks to complete
wait

echo "Download complete."
