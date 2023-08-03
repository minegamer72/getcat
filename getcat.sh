#!/bin/bash

echo "ok" # visual feedback

# first check if the getcatDir exists
if [ ! -d ~/getcatDir ]; then
    mkdir ~/getcatDir
fi
# then set getcatDir to the directory.
getcatDir=~/getcatDir


# curl to get the image onto the machine
cat_data=$(curl -s https://api.thecatapi.com/v1/images/search | jq -r '.[0].url' | xargs curl -s -o cat)

# use 'file' to detect image format
cat_format=$(file -b --mime-type cat)

# now to find out what file type it is
case "$cat_format" in
    "image/gif") # TheCatAPI serves gifs, so include it here.
        file_ext=".gif";;
    "image/png") # i have not gotten a .png file from the API yet, but this is here JIC
        file_ext=".png";;
    "image/jpeg")
        file_ext=".jpg";;
    *)
        # if not found, echo this to the terminal then exit.
        echo "error found! file type not in case statement, add it! File type: $cat_format"
        exit 1
        ;;
esac

# save final image to disk
mv cat "$getcatDir/cat$file_ext"

#feh $getcatDir/cat$file_ext

# feh doesn't handle gifs so we're using the flatpak version of gwenview. todo: make this configurable
flatpak run org.kde.gwenview $getcatDir/cat$file_ext
echo "done" # visual feedback
exit 0
