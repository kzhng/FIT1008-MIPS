size = int(input("what size is your list? "))
the_list = [0]*size


def find_range(length, array):
    i = 0
    max = 0
    min = float("inf")
    while i < length:
        item = int(input("enter an integer: "))
        if item < min:
            min = item
        elif item > max:
            max = item
        array[i] = item
        i = i + 1
    range_list = max - min
    return range_list


range_list = find_range(size, the_list)
print("range of the list is {}".format(range_list))
