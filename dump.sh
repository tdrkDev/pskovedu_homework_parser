#!/bin/bash

# Set your own ones
COOKIE='PHPSESSID...'
DIARY_ID='AB12C3...'

construct_link() {
    echo 'https://one.pskovedu.ru/edv/index/report/diary/'$DIARY_ID'?date='$1'&homework-mode=previous'
}

d=$(date -d "$(date "+%Y")-09-01" '+%Y%m01'); w=$(date -d $d '+%w'); i=$(( (8 - $w) % 7)); answer=$(( $d + $i ));
unset d w i

minDate=$(date --date=$answer --utc "+%s")
maxDate=$(date "+%s")
betweenDates=$(date --date='1970-01-08' --utc "+%s")
days=("Понедельник" "Вторник" "Среда" "Четверг" "Пятница")

mkdir -p temp

if [ -z "$1" ] || [ -z "$2" ]; then
echo "Usage: ./dump.sh 'item' 'day of week (1-5)'"
exit 1
fi

idp=$(date --date='1970-01-'$2 --utc "+%s")

echo "Поиск д/з по предмету $1 в день недели ${days[$(expr $2 - 1)]}..."

for ((i=$minDate;$i<=$maxDate;i+=$betweenDates)); do
    linkDate=$(date --date="@$i" --utc "+%d.%m.%Y")
    itemDate=$(date --date="@$(expr $i + $idp)" --utc "+%d.%m.%Y")
    link="$(construct_link $linkDate)"

    curl "$link" --cookie "$COOKIE" > temp/$linkDate.xls 2>/dev/null
    homework="$(python reader.py temp/$linkDate.xls $1 $2 2>/dev/null)"

    ([ -z "$homework" ] || [ "$homework" = "nan" ]) && homework="Не задано"

    echo "$itemDate: $homework"
done

echo "Очистка временных данных..."

rm -rf temp
