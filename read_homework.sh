#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Usage: $0 'file.json' 'DD.MM. Day' 'Item'"
    exit 1
fi 

which jq >/dev/null 2>/dev/null || echo "Please install jq."

if [ ! -f "$1" ]; then
    echo "File not found"
    exit 1
fi

if [ "$(cat $1 | jq '.success' -M)" != "true" ]; then
    echo "Diary status != true"
    exit 1
fi

diary="$(cat $1 | jq '.data.diary' -M)"
if [ "$diary" = "null" ]; then
    echo "Cannot get diary data"
    exit 1
fi

diary="$(cat $1 | jq '.data.diary | type' -M --raw-output)"
if [ "$diary" = "array" ]; then
    echo "Каникулы"
    exit 0
fi

# eval is necessary here
diary_for_day="$(eval "cat $1 | jq '.data.diary.\"$2\"' -M")"
if [ "$diary_for_day" = "null" ]; then
    echo "Праздник / день не существует"
    exit 0
fi

lessons_length="$(echo "$diary_for_day" | jq '. | length' -M)"
for ((i=0;$i<$lessons_length;i++)); do
    # jq with --raw-output doesn't print quotes
    lesson="$(echo "$diary_for_day" | jq '.['$i'].subject' -M --raw-output)"

    if [ "$lesson" = "$3" ]; then
        echo "$(echo "$diary_for_day" | jq '.['$i'].homework' -M --raw-output)"
        exit 0
    fi
done

