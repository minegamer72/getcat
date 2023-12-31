#!/bin/bash

echo "ok" # visual feedback

# Replace this with your API key!
API_KEY=""

# curl to get the image onto the machine
if [ "$API_KEY" != "" ]; then
  cat_data=$(curl -s https://api.thecatapi.com/v1/images/search?api_key=$API_KEY | jq -r '.[0].url' | xargs curl -s -o cat)
else
  cat_data=$(curl -s https://api.thecatapi.com/v1/images/search | jq -r '.[0].url' | xargs curl -s -o cat)
fi

# use 'file' to detect image format
cat_format=$(file -b --mime-type cat)

# find out what file type it is
case "$cat_format" in
    "image/gif")
        file_ext=".gif";;
    "image/png")
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
mv cat "./cat$file_ext"

# Use nsxiv because it is a very lightweight alternative to feh that handles gifs.
nsxiv ./cat$file_ext
echo "done" # visual feedback
exit 0
