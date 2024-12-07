#!/bin/sh
echo ""
echo "$(date) $0 $@"

dir="$1"
srcroot="$dir/content"
dstroot="/"

#region core functions
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

#region logic functions
initsetup() {
    executable "*" "$srcroot/etc/init.d"
    executable "*" "$srcroot/etc/periodic"
    executable "*" "$srcroot/scripts"
    executable "*" "$dir/scripts"
}
precopy() {
    find "$dir"/scripts/* -type f -name "0*" | while read item; do
        "$item" "$srcroot"
    done
}
postcopy() {
    find "$dir"/scripts/* -type f ! -name "0*" | while read item; do
        "$item" "$srcroot"
    done
}
finsetup() {
    copy "$srcroot" "$dstroot"

    # register and run init.d services
    for item in "$srcroot/etc/init.d"/*; do
        if [ -f "$item" -a -e "$item" ]; then
            local name="$(basename "$item")"
            rc-update add "$name" default
            service "$name" restart
        fi
    done

    rm -rf "$dir"
}
#endregion

initsetup
precopy
copy "$srcroot" "$dstroot"
postcopy
copy "$srcroot" "$dstroot"
finsetup

echo "Setup completed"
