#!/bin/bash

# Set your own ones
COOKIE='_ym_... PHP...'
DIARY_ID='19177F31....'

construct_link() {
    echo 'https://one.pskovedu.ru/edv/index/diary/'$DIARY_ID'?date='$1''
}

month="$(date "+%m")"
if (($month<9)); then
d=$(date -d "$(expr $(date "+%Y") - 1)-09-01" '+%Y%m01'); w=$(date -d $d '+%w'); i=$(( (8 - $w) % 7)); answer=$(( $d + $i ));
else
d=$(date -d "$(date "+%Y")-09-01" '+%Y%m01'); w=$(date -d $d '+%w'); i=$(( (8 - $w) % 7)); answer=$(( $d + $i ));
fi

unset d w i

minDate=$(date --date=$answer --utc "+%s")
maxDate=$(date "+%s")
betweenDates=$(date --date='1970-01-08' --utc "+%s")
days=("Понедельник" "Вторник" "Среда" "Четверг" "Пятница" "Суббота")
quarters=("placeholder" "I" "II" "III" "IV" "Error")

mkdir -p temp

if [ -z "$1" ] || [ -z "$2" ] || (($2>6)) || (($2<1)); then
echo "Usage: ./dump.sh 'subject' 'day of week (1-6)'"
exit 1
fi

idp=$(date --date='1970-01-'$2 --utc "+%s")

echo "Поиск д/з по предмету $1 в день недели ${days[$(expr $2 - 1)]}..."

quarter=1
prevHomework=""

echo -e "\n${quarters[$quarter]} четверть:\n"

for ((i=$minDate;$i<=$maxDate;i+=$betweenDates)); do
    linkDate=$(date --date="@$i" --utc "+%d.%m.%Y")
    itemDate=$(date --date="@$(expr $i + $idp)" --utc "+%d.%m.%Y")
    link="$(construct_link $linkDate)"

    curl "$link" --cookie "$COOKIE" > temp/$linkDate.json 2>/dev/null || exit 1

    argsDate="$(date --date="@$(expr $i + $idp)" --utc "+%d.%m"). ${days[$(expr $2 - 1)]}"
    homework="$(./read_homework.sh "temp/$linkDate.json" "$argsDate" "$1")"
    if [ "$?" != "0" ]; then
        echo "$itemDate: Ошибка: $homework"
        continue;
    fi

    ([ -z "$homework" ] || [ "$homework" = "null" ]) && homework="Не задано"

    if [ "$prevHomework" = "Каникулы" ] && [ "$homework" != "Каникулы" ]; then
        ((quarter++))
        echo -e "\n${quarters[$quarter]} четверть:\n"
    fi 

    prevHomework="$homework"
    echo "$itemDate: $homework"
done

echo "Очистка временных данных..."

rm -rf temp
