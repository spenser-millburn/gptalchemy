#/usr/bin/env sh
mkdir -p ~/.config/fish/functions
find . -type f -name '*.fish' -exec mv {} ~/.config/fish/functions/ \;
