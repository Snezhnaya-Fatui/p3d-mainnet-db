#!/bin/bash

# GitHub username and repository name
GITHUB_USER="Snezhnaya-Fatui"
GITHUB_REPO="p3d-mainnet-db"

# Fetching the latest release tag
latest_release=$(curl -s "https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
if [ -z "$latest_release" ]; then
    echo "Failed to fetch latest release tag. Exiting."
    exit 1
fi
echo "Latest release tag: ${latest_release}"

# Download directory
download_dir="./downloads"
mkdir -p "${download_dir}"

# Downloading the latest release parts of db
for ((i=1; i<=11; i++)); do
    part=$(printf "%03d" $i)
    url="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/releases/download/${latest_release}/db.7z.${part}"
    echo "Downloading ${url} ..."
    wget_output=$(wget -nv --show-progress -P "${download_dir}" "${url}" 2>&1)
    if [ $? -ne 0 ]; then
        echo "Failed to download ${url}:"
        echo "$wget_output"
        exit 1
    fi
done

# Waiting for all download tasks to complete
wait

# Check if all parts were downloaded
num_files=$(ls -1 "${download_dir}/db.7z."* 2>/dev/null | wc -l)
if [ $num_files -eq 11 ]; then
    echo "Download complete. All parts downloaded successfully."
else
    echo "Download incomplete. Expected 11 parts, found ${num_files}."
fi
