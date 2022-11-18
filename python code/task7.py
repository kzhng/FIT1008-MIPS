num_cities = int(input("number of cities? "))
num_days = int(input("number of days? "))

table = [0]*num_cities

def matrixoftemp(cities, days, matrix):
    x = 0
    y = 0
    templist = 0
    temp = 0
    while x < cities:
        templist = [0]*days
        print("City {}".format(x))
        y = 0
        while y < days:
            temp = int(input("temperature? "))
            templist[y] = temp
            y = y + 1
        matrix[x] = templist
        x = x + 1
    return matrix

def findmax(my_list):
    max = 0
    i = 0
    val = 0
    n = len(my_list)
    while i < n:
        val = my_list[i]
        if val > max:
            max = val
        i = i + 1
    return max

table = matrixoftemp(num_cities, num_days, table)

option = 0
while option != 2:
    print("Pick an option")
    print("1. Find max temperature of a city")
    print("2. quit")
    option = int(input("what option? "))
    if option == 1:
        city = int(input("What city? "))
        citylist = table[city]
        maxtemp = findmax(citylist)
        print("Max temperature is {}".format(maxtemp))




