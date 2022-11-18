size = int(input("what size is your list? "))
the_list = [0]*size
i = 0
k = 0
count = 0

while i < size:
    item = int(input("enter an integer: "))
    the_list[i] = item
    i = i + 1

target = int(input("number you want to count? "))

while k < size:
    number = the_list[k]
    if target == number:
        count = count + 1
    k = k + 1

print(count)