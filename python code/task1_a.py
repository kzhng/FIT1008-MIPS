def leap_year_check(year):
    if year % 4 == 0 and (year % 400 == 0 or year % 100 != 0):
        print("Is a leap year")
        return True
    else:
        print("Is not a leap year")
        return False


def is_leap_year(year):
    leap_year = leap_year_check(year)
    return leap_year


my_year = int(input("What year is it? "))
is_leap_year(my_year)