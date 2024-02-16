#!/usr/bin/env bash

ROOT_DIR="${HOME}/Music"
SOURCE="${ROOT_DIR}/Untagged"
BEETS_DB="${ROOT_DIR}/beets.db"


rm -f "$BEETS_DB"
pushd "$SOURCE" &> /dev/null || exit 1


while read -r basedir; do
  echo $'\uf481' " Flattening ${basedir}"
  while read -r filename; do
    src="${basedir}/${filename}"
    dest="${basedir}/${filename//\//_}"
    [[ "$src" != "$dest" ]] && mv "$src" "$dest"
  done < <(find "$basedir" -type f -printf '%P\n')
done < <(find . -mindepth 1 -maxdepth 1 -type d -printf '%P\n')


echo $'\uf014' " Removing empty directories"
find . -mindepth 1 -type d -empty -delete


echo $'\ue68f' " Searching for flac albums"
while read -r album; do
  dirname="${album#./}"
  echo $'\uf066' " Archiving ${dirname}"
  tarfile="${dirname//[^a-zA-Z0-9]/_}.tar.gz"
  tar -czf "$tarfile" "$album"
  mv -f "$tarfile" "${ARCHIVE}/${tarfile}"
done < <(find . -type f -name '*.flac' -printf '%h\n' | sort -u)


echo $'\u266f' " Importing with beets"
beet import "$SOURCE"


popd &> /dev/null || exit 1
rm -f "$BEETS_DB"
