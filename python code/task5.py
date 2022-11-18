size = int(input("what size is your list? "))
the_list = [0]*size
x = 0

while x < size:
    item = int(input("enter an integer: "))
    the_list[x] = item
    x = x + 1

def minfn(my_list):
    min = float("inf")
    y = 0
    number = 0
    length = len(my_list)
    while y < length:
        number = my_list[y]
        if number < min:
            min = number
        y = y + 1
    return min

print("The minimum temperature is {}".format(minfn(the_list)))


