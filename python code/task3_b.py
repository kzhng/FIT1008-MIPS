size = int(input("what size is your list? "))
the_list = [0]*size

i = 0
max = 0
min = float("inf")
while i < size:
    item = int(input("enter an integer: "))
    if item < min:
        min = item
    elif item > max:
        max = item
    the_list[i] = item
    i = i + 1

range_list = max - min
print("range of the list is {}".format(range_list))