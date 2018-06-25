#!/usr/bin/bash

packages="$@"
database_dir="$PWD/IanS5"
database="$database_dir/$(basename $database_dir).db.tar.gz"

mkdir -p "$database_dir"

[[ -n "$packages" ]] || packages="*"

for d in $packages; do
    [[ -d "$d" ]] || [[ -f "$d"/PKGBUILD ]] || continue

    pushd "$d"
    makepkg -f

    for f in ./*.pkg.*; do
        repo-add "$database" "$f"
        cp "$f" "$database_dir"
    done

    popd
done

mv "$database" "$database_dir/$(basename $database_dir).db"
mv "$database_dir/$(basename $database_dir).files.tar.gz" "$database_dir/$(basename $database_dir).files"
rm "$database_dir"/*.old
