#!/bin/sh

base="$1"
path="${base}/Contents/MacOS"
cd "${path}"
files=(*)
index=1
count="${#files[@]}"
if [ "${count}" != "1" ]; then
    for i in "${!files[@]}"
    do
        echo "$i. ${files[$i]}"
    done
    while true ; do
        echo "Please select which file to fix: "
        read index
        if [[ ! "$index" < "0" ]] && [[ "$index" < "$count" ]]; then break; fi
    done  
fi
target="${path}/${files[${index}]}"
upx -d "${target}"
