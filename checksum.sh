#!/bin/bash

# checksum.sh - checksum all files under a certain path

if [ $# -ne 2 ]; then
    echo "You must specifiy a hash (md5 or sha) type and a path to checksum!"
    echo "  e.g. $0 [ md5 | sha ] /path/to/directory"
    exit 1
fi

# check to make sure a valid hash is provided
if ! [[ $1 =~ (md5|sha1) ]]; then
    echo "ERROR: You must specify a hash, either md5 or sha1!"
    exit 1
else
    if [[ $1 =~ "md5" ]]; then
        algo=md5
    elif [[ $1 =~ "sha1" ]]; then
        algo=sha1
    else
        echo "ERROR: Unknown hashing algorithm! Please use md5 or sha1."
    fi
fi

path="$2"
chksumfile="~/checksums.txt"

# checksum based on $OSTYPE
if [[ $OSTYPE =~ "linux" ]]; then
    if [[ $algo =~ "md5" ]]; then
        algo=md5sum
    else
        algo=shasum
    fi
elif [[ $OSTYPE =~ "darwin" ]]; then
    if [[ $algo =~ "md5" ]]; then
        algo=md5
    else
        algo=shasum
    fi
else
    echo "ERROR: Unknown \$OSTYPE!"
fi

# find all regular files under dir tree
command find "$path" -type f -print0 | xargs -0 "$algo" &> ~/checksums.$$.$1

echo "Checksum complete. Checksum file located at: ~/checksums.$$.$1"

#EOF
