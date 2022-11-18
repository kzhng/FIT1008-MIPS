year = int(input("What year is it? "))
if year % 4 == 0 and (year % 400 == 0 or year % 100 != 0):
    print("Is a leap year")
else:
    print("Is not a leap year")