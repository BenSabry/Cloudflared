#!/bin/sh
echo ""
echo "$(date) $0 $@"

user="$1"
repo="$2"
func=$3

file="/tmp/$user.$repo.ver"
default_version="0.0.0"
latest_version="1.0.0"

#region Functions
fetch_latest_version() {
    local version;
    {
        version=$(wget -qO- https://github.com/$user/$repo/releases/latest | grep -o 'href="/'$user/$repo'/releases/tag/[^"]*' | head -1 | cut -d'/' -f6);
    } &> /dev/null

    echo $version
}
read_local_version() {
    if [ -f "$file" ]; then
        echo "$(cat $file)"
    else
        echo "$default_version"
    fi
}
update_local_version() {
    echo "$latest_version" > "$file"
}
#endregion

latest_version=$(fetch_latest_version)
local_version=$(read_local_version)

# Check if the versions are the same
if [ "$latest_version" = "$local_version" ]; then
    echo "No new versions found."
else
    echo "New version found: $latest_version"

    # Run the update script
    $func

    # Update the version file with the latest version
    update_local_version
    echo "Update complete."
fi
