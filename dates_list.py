#working with dates

from datetime import date
from datetime import datetime
from datetime import timedelta

def dates_list():
	#date objects #get todays date from the simple today() method from the date
	days_of_week = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday']
	today = date.today()
	weekday = today.weekday()
	print today
	print weekday
	print days_of_week[weekday]

	day = today.day
	month = today.month
	year = today.year

	print day
	print month
	print year

	#week_start=weekday
	#if weekday!=week_start
	if weekday != 0:
		weekstart = today - timedelta(days=weekday)
		print weekstart
	else:
		week_start = today
		print weekstart

	next_week = weekstart + timedelta(days=7)
	print next_week

	week = weekstart
	list_of_weeks = [week.strftime("%d-%m-%Y")]
	for i in range(0,12):
		week = week + timedelta(days=7)
		list_of_weeks.append(week.strftime("%d-%m-%Y"))  #strftime("%a,%d %B,%y") = Mon,24 October,18

	return list_of_weeks
	#print list_of_weeks.strftime("%a,%d %B,%y")
		
main()


