# dump.sh

Чтение всех домашних заданий для конкретного предмета в конкретный день

Требует первичной настройки - необходимо заменить COOKIE и DIARY_ID на свои вверху скрипта.

COOKIE берется путем лазания по сайту с мониторингом сети из F12 браузера, 
в Request Headers запросов надо найти значение Cookie.

DIARY_ID берется через ссылку, откуда скачивали xls-файл (гляньте в загрузки в браузере).
Находится он тут:
```
https://one.pskovedu.ru/edv/index/report/diary/'нужный нам DIARY_ID'?date=29.11.2021&homework-mode=previous
```
Выглядит как большое количество букв и цифр.

Использование:
```bash
./dump.sh "предмет в именительном падеже с большой буквы" "день недели (1-6 как пн-сб)"
```

Будут выданы результаты от первого понедельника сентября до сегодняшнего дня.

# changelog

2.0: ```
Новости
* PskovEdu обновил бэкэнд. Теперь по запросу приходит json-файл.

Обновления
* Добавлен показ четвертей, каникул, праздников
* Удален reader.py за ненадобностью
* Создан read_homework.sh для чтения д/з из нового json-ответа
* Исправлен баг с созданием дат во второй половине учебного года
* Добавлен .gitignore
```
