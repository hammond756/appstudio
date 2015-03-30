# Aron Hammond
# Problem workshop 1: zellers.py
# 16-03-2015
#
# Returns on what day a certain date will be or has been (on the gregorian calendar)



def zellers(month_string, day, exact_year):

    # dictionary mapping encoding months with integers, list to store 31-day months and leap-year boolean
    month_index = {"March": 1, "April": 2, "May": 3, "June": 4, "July": 5, "August": 6, "September": 7, "October": 8,
                   "November": 9, "December": 10, "January": 11, "February": 12}
    long_months = [1, 3, 5, 6, 8, 10, 11]
    leap_year = exact_year % 4 != 0 and exact_year % 100 == 0 and exact_year % 400 != 0
    
    # check whether month_string is in the dictionary
    if month_index.has_key(month_string):
        month = month_index[month_string]
    else:
        print "Invalid month"
        return

    if day > 31 or day < 1:
        print "Invalid day"
        return
    # only accept 31 for the appropriate months
    elif day == 31 and month not in long_months:
        print "Invalid day"
        return
    # check if Feb 29 was entered for a leap year
    elif month_string == "February" and ((day == 29 and leap_year) or day == 30):
        print "Invalid day"
        return
        
    # don't accept years b.c. and warn for violation of gregorian era
    if exact_year < 0:
        print "Invalid year"
        return

    year = exact_year % 100 # magic number?
    century = exact_year / 100

    # correct the year for January and February
    if month >= 11:
        year -= 1

    week_days = 7       # days in the week
    leap_interval = 4   # leap year every 4 years
    
    # the algorithm (13, 1, 2, 5, magic numbers??)
    month_var = (13 * month - 1) / 5
    leap_offset = year / leap_interval
    century_leap = century / leap_interval
    total = month_var + leap_offset + century_leap + day + year - 2 * century
    # always positive. result of '%' in python gets sign of divisor
    result = total % week_days
    
    day_codes = {0: "Sunday", 1: "Monday", 2: "Tuesday", 3: "Wednesday", 4: "Thursday", 5: "Friday", 6: "Saturday"}

    print month_string, day, exact_year, "is on a", day_codes[result]
    if exact_year < 1583:
        print "    NB: Gregorian calendar was not in use in this year"

# birthday, today, the start of the millennium, before gregorian and april fools!
zellers("August", 18, 1994)
zellers("March", 16, 2015)
zellers("January", 1, 2000)
zellers("March", 2, 1500)
zellers("April", 1, 2015)
