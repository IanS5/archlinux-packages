#!/usr/bin/bash

packages="$@"
database_dir="$PWD/IanS5"
database="$database_dir/$(basename $database_dir).db.tar.xz"

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
