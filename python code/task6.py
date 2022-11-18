size = int(input("what size is your list? "))
the_list = [0]*size
i = 0
k = 0
count = 0

while i < size:
    item = int(input("enter an integer: "))
    the_list[i] = item
    i = i + 1

a = int(input("give a: "))
b = int(input("give b: "))


def make_count_list(x, y):
    c = y - x
    c = c + 1
    count_list = [0]*c
    i = 0
    number = 0
    while i < c:
        number = a + i
        count_list[i] = number
        i = i + 1
    return count_list

def frequency_count(my_list, range_list):
    j = 0
    val = 0
    k = 0
    count = 0
    n = len(my_list)
    c = len(range_list)
    item = 0
    while j < c:
        val = range_list[j]
        k = 0
        count = 0
        while k < n:
            item = the_list[k]
            if item == val:
                count = count + 1
            k = k + 1
        if count != 0:
            print("{} appears {} times".format(val, count))
        j = j + 1



frequency_count(the_list, make_count_list(a, b))
