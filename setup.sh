#!/bin/sh

uid="BenSabry/Cloudflared"
url="https://github.com/$uid/archive/refs/heads/main.zip"
dir="/tmp/$uid"

echo "Downloading $1"
{
    rm -rf $dir
    mkdir -p $dir
    cd $dir

    wget "$url"

    zipfile="$(ls "$dir/"*.zip | head -1)"
    unzip $zipfile -d "$dir"
    rm $zipfile

    extracted="$(ls -d "$dir/"* | head -n 1)"
    mv "$extracted"/* "$dir"
    rmdir "$extracted"

} &> /dev/null

chmod +x ./setup-offline.sh
./setup-offline.sh $dir
