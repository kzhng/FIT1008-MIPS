size = int(input("what size is your list? "))
the_list = [0]*size
i = 0
k = 0

while i < size:
    item = int(input("enter an integer: "))
    the_list[i] = item
    i = i + 1

while k < size:
    print(the_list[k])
    k = k+2