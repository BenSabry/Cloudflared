#!/bin/sh

uid="BenSabry/Cloudflared"

#region Helpers
download() {
    echo "Downloading $1"
    {(
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

    )} &> /dev/null
}
executable() {
    if [ -n "$2" ]; then
        find "$2" -type f -name "$1" -exec chmod +x {} \;
    else
        echo "executable(): exception, path argument can not be empty."
    fi
}
copy() {
    local src="$1"
    local dst="$2"

    # check if source exists
    if [ ! -e "$src" ]; then
        echo "Source $src does not exist."
        return 1
    fi

    # if it's a file
    if [ -f "$src" ]; then
        # if destination file exists
        if [ -e "$dst" ]; then
            # overwrite its content, not the file itself
            cat "$src" > "$dst"
        else
            # copy the file itself
            cp "$src" "$dst"
        fi

    # if it's a directory
    elif [ -d "$src" ]; then
        # make sure destination path exists
        mkdir -p "$dst"
        # check if a directory is not empty
        if [ "$(ls -A "$src")" ]; then
            # iterate over directory content
            for item in "$src"/*; do
                # recursively call the function with child item
                copy "$item" "$dst/$(basename "$item")"
            done
        fi
    else
        echo "Source $src is neither a file nor a directory."
        return 1
    fi
}
#endregion

#region Functions
url="https://github.com/$uid/archive/refs/heads/main.zip"
dir="/tmp/$uid"
srcroot="$dir/content"
dstroot="/"

initialize() {
    download $url $dir

    executable "*" "$srcroot/etc/init.d"
    executable "*" "$srcroot/etc/periodic"
    executable "*" "$srcroot/scripts"
    executable "*" "$dir/scripts"

    copy "$srcroot" "$dstroot"
}
run_init_scripts() {
    find "$dir"/scripts/* -type f -name "0*.sh" | while read item; do
        "$item" "$srcroot"
    done
}
run_scripts() {
    find "$dir"/scripts/* -type f ! -name "0*.sh" | while read item; do
        "$item" "$srcroot"
    done
}
cleanup() {
    rm -rf "$dir"
    echo "Setup completed"
}

register_services() {
    for item in "$srcroot/etc/init.d"/*; do
        if [ -f "$item" -a -e "$item" ]; then
            local name="$(basename "$item")"
            rc-update add "$name" default
        fi
    done
}
restart_services() {
    for item in "$srcroot/etc/init.d"/*; do
        if [ -f "$item" -a -e "$item" ]; then
            local name="$(basename "$item")"
            service "$name" restart &
        fi
    done
}
#endregion

initialize
run_init_scripts
register_services
run_scripts
restart_services
cleanup
