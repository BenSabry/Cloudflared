#!/bin/sh

uid="BenSabry/Cloudflared"
url="https://github.com/$uid/archive/refs/heads/main.zip"
dir="/tmp/$uid"

#region core functions
download() {
    echo "Downloading $1"
    {
        local url=$1
        local path=$2

        rm -rf $path
        mkdir -p $path
        cd $path

        wget "$url"

        zipfile="$(ls "$path/"*.zip | head -1)"
        unzip $zipfile -d "$path"
        rm $zipfile

        extracted="$(ls -d "$path/"* | head -n 1)"
        mv "$extracted"/* "$path"
        rmdir "$extracted"

    } &> /dev/null
}
#endregion

download $url $dir
./setup-offline.sh $dir

