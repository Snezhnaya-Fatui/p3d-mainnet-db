#!/bin/bash

GITHUB_USER="Snezhnaya-Fatui"
GITHUB_REPO="p3d-mainnet-db"

latest_release=$(curl -s "https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/releases/latest" | grep -oP '"tag_name": "\K[^"]+')
if [ -z "$latest_release" ]; then
    echo "Failed to fetch latest release tag. Exiting."
    exit 1
fi
echo "Latest release tag: ${latest_release}"

download_dir="./downloads"
mkdir -p "${download_dir}" || { echo "Failed to create download directory. Exiting."; exit 1; }

assets=$(curl -s "https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/releases/latest" | grep -oP '"name": "\K[^"]+')
echo "Available assets:"
echo "${assets}"

# Create an array to hold download URLs
urls=()

part_number=1
while true; do
    part=$(printf "%03d" $part_number)
    asset_name="db.7z.${part}"
    
    download_url=$(curl -s "https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/releases/latest" | grep -oP '"browser_download_url": "\K[^"]+' | grep "$asset_name")

    if [ -z "$download_url" ]; then
        echo "File ${asset_name} not found, stopping."
        break
    fi

    urls+=("$download_url")
    part_number=$((part_number + 1))
done

# Download all URLs in parallel
echo "Starting parallel download of ${#urls[@]} files..."
printf "%s\n" "${urls[@]}" | xargs -n 1 -P "${#urls[@]}" wget -L --content-disposition -nv --show-progress -P "${download_dir}"

num_files=$(ls -1 "${download_dir}/db.7z."* 2>/dev/null | wc -l)
echo "Download complete. Total parts downloaded: ${num_files}."
