import sys
import OleFileIO_PL
import pandas as pd

days = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница"]

def locate_homework(item, x, start_pos):
    i = start_pos
    while (str(x.loc[i, :][1]).find(item) == -1):
        i += 1
        if i >= len(x) or str(x.loc[i, :][1]) == "nan":
            return "Предмет не найден"

    return x.loc[i, :][3]

def get_homework(name, item, day):
    with open(name, 'rb') as file:
        ole = OleFileIO_PL.OleFileIO(file)
        if ole.exists('Workbook'):
            d = ole.openstream('Workbook')

    x = pd.read_excel(d, engine='xlrd', sheet_name="Дневник", index_col=None)
    i = 0

    while (str(x.loc[i, :][0]).find(days[day]) == -1):
        i += 1
        if str(x.loc[i, :][0]) == None:
            print("Не обнаружен заданный день недели")
            return

    print(locate_homework(item, x, i + 2))

def main():
    name = str(sys.argv[1:][0])
    item = str(sys.argv[2:][0])
    day = int(sys.argv[3:][0]) - 1

    if day < 0 or day > 4:
        print("несуществующий рабочий день")
        return

    get_homework(name, item, day)

if __name__ == "__main__":
    main()  