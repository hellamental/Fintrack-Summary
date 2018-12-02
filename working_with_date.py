#working with dates

from datetime import date
from datetime import datetime
from datetime import timedelta
from datetime_convert import *

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
		weekstart = today
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
		
def date_mapping(min_date, max_date):

	#this creates the list of dates from max to min and the day of the week that it starts on
	weekday = min_date.weekday()
	if weekday != 0:
		print weekday
		weekstart_min = min_date - timedelta(days=weekday)
		print weekstart_min
	else:
		weekstart_min = min_date
		print "Weekstart Min", weekstart_min
	

	list_of_dates_dtf = [] #dtf = date time format
	list_of_dates = [] #stf = string type format
	date = weekstart_min
	while date < max_date:
		list_of_dates_dtf.append(date) 
		list_of_dates.append(date.strftime("%d-%m-%Y"))
		date = date + timedelta(days=7)

	return list_of_dates_dtf

def date_check(date_in,list_of_dates_dtf):
#this function takes the date entered and checks if it within 7 days of of the dates in the list. 	
	for i in list_of_dates_dtf:
		if date_in >= i and date_in < i + timedelta(days=7):
			print "yes" , date_in, i
		else:
			print "no" 

def TopRowDateList(milestone_matrix):
	DateList = str_to_datetime(milestone_matrix)#converts dates from str to datetime
	final_DateList = remove_duplicates(DateList)#removes duplicates from datelist

	min_date = min(final_DateList)#returns min & max date
	max_date = max(final_DateList)
	
	TopRowDateList = date_mapping(min_date, max_date) #maps dates from min to max from earliest monday
	return TopRowDateList


def remove_duplicates(duplicate):
	final_list = []
	for num in duplicate:
		if num not in final_list:
			final_list.append(num)
	return final_list


def unique_list(array,position):
	unique_list = []
	for i in array:
		if i[position] not in unique_list:
			unique_list.append(i[position])
	unique_list = sorted(unique_list)
	return unique_list

def unique_list2(array):
	unique_list = []
	for i in array:
		if i not in unique_list:
			unique_list.append(i)
	unique_list = sorted(unique_list)
	return unique_list	

def matrix_creator_3D(TopRowList,UniqueIdList,Matrix,ContractIDName):
	w, h, d = len(TopRowList)+2, len(UniqueIdList)+1, len(Matrix[0]);
	excel_matrix = [[[0 for x in range(w)] for y in range(h)] for z in range(d)]
	
	#adds weekstart dates to each element in first row of matrix.
	ycount = 0
	xcount = 2
	zcount = 0
	for i in TopRowList:    
		x = i#.strftime("%d-%m-%Y")
		excel_matrix[zcount][ycount][xcount]=x 
		xcount += 1

	#adds Opportunity ID list to each element in first col of matrix.
	ycount = 1
	xcount = 1
	zcount = 0 
	for i in UniqueIdList:
		excel_matrix[zcount][ycount][xcount]=i
		ycount += 1

	ycount = 1
	xcount = 0
	zcount = 0
	for i in UniqueIdList:
		excel_matrix[zcount][ycount][xcount] = ContractIDName[i]
		ycount += 1

	return excel_matrix

def excel_matrix_populator(milestone_matrix,excel_matrix,IdName,Idlist,Milestone_Type):
	
	#print IdName
	for i in milestone_matrix:
		
		if i['RECORD_TYPE_NAME__C'] == Milestone_Type:
			due_Date = i['DUE_DATE__C']
			if IdName == 'ContractIdList':
				oppID = i['CONTRACT__C']
			elif IdName == 'OppIdList':
				oppID = i['OPPORTUNITY__C']
			else: #oppIdList
				pass 	
			
			invoice_C = i['INVOICE__C'] #i[24]
			due_Date = i['DUE_DATE__C'] #i[20]	
			milestone_name = i['NAME'] #i[3]
			percentage = i['PERCENTAGE__C'] #i[32]
			prjct_name = i['PROJECT_NAME_CONTRACT__C'] #i[35]
			status = i['STATUS__C'] #i[44]
			
			if due_Date == '':
				pass
			else:
				k = parse(due_Date)
				#print excel_matrix[0]
				for j in excel_matrix[0][0]: #for j in line 1 of excel matrix 
					#print type(j), j, 'J'
					#print type(k), k, 'K'
					if type(j)!=int and k >= j and k < j + timedelta(days=7):
					#print excel_matrix.index(j)
						#print type(oppID)
						#print j
						col = excel_matrix[0][0].index(j)
						row = Idlist.index(oppID)+1  #this line is causing an error for Opp IDs
						#print row
						dep = 0
						dollar_val = float(i['MILESTONE_VALUE__C'])
						if excel_matrix[dep][row][col] == 0:
							excel_matrix[dep][row][col] = '='+str(dollar_val)
							excel_matrix[2][row][col] = status
							excel_matrix[1][row][col] = str(milestone_name)+' - '+str(prjct_name)+' - '+str(status)+' - $'+str(dollar_val)+' - '+str(percentage)+'% - '+due_Date #add due date
							
						else:
							excel_matrix[dep][row][col] = excel_matrix[dep][row][col]+'+'+str(dollar_val)
							excel_matrix[1][row][col] = excel_matrix[1][row][col]+'\n\n'+str(milestone_name)+' - '+str(prjct_name)+' - '+str(status)+' - $'+str(dollar_val)+' - '+str(percentage)+'% - '+due_Date#add due date
							excel_matrix[2][row][col] = status
					else:
						pass
			pass

def excel_matrix_populator_site(milestone_matrix,excel_matrix,Id,Idlist,Milestone_Type):
	
	#print Id
	for i in milestone_matrix:
		
		if i['RECORD_TYPE_NAME__C'] == Milestone_Type and i['CONTRACT__C'] == Id:
			due_Date = i['DUE_DATE__C'] #i[20]
			oppID = i['OPPORTUNITY__C'] #i[29]	
			milestone_name = i['NAME'] #i[3]
			percentage = i['PERCENTAGE__C'] #i[32]
			prjct_name = i['PROJECT_NAME_CONTRACT__C'] #i[35]
			status = i['STATUS__C'] #i[44]
			if due_Date == '':
				pass
			else:
				k = parse(due_Date)
				#print excel_matrix[0]
				for j in excel_matrix[0][0]: #for j in line 1 of excel matrix 
					#print type(j), j, 'J'
					#print type(k), k, 'K'
					if type(j)!=int and k >= j and k < j + timedelta(days=7):
					#print excel_matrix.index(j)
						#print type(oppID)
						#print j
						col = excel_matrix[0][0].index(j)
						row = Idlist.index(oppID)+1
						#print row
						dep = 0
						dollar_val = float(i['MILESTONE_VALUE__C'])
						if excel_matrix[dep][row][col] == 0:
							excel_matrix[dep][row][col] = '='+str(dollar_val)
							excel_matrix[1][row][col] = status
						else:
							excel_matrix[dep][row][col] = excel_matrix[dep][row][col]+'+'+str(dollar_val)
					else:
						pass
			pass


def excel_matrix_populator_site2(milestone_matrix,excel_matrix,IdName,Idlist,Milestone_Type,ContractId):
	
	#print IdName
	for i in milestone_matrix:
		
		if i['RECORD_TYPE_NAME__C'] == Milestone_Type:
			due_Date = i['DUE_DATE__C'] #i[20]
			if IdName == 'ContractIdList' and i['CONTRACT__C']!='':
				oppID = i['CONTRACT__C']
			elif IdName == 'OppIdList':
				oppID = i['OPPORTUNITY__C']
			else: #oppIdList
				pass 	
			milestone_name = i['NAME'] #i[3]
			percentage = i['PERCENTAGE__C'] #i[32]
			prjct_name = i['PROJECT_NAME_CONTRACT__C'] #i[35]
			invoice_C = i['INVOICE__C']  #i[24]
			CntrctId = i['CONTRACT__C'] #i[17]
			status = i['STATUS__C'] #i[44]

			if due_Date != '' and ContractId == CntrctId:
				k = parse(due_Date)
				#print excel_matrix[0]
				for j in excel_matrix[0][0]: #for j in line 1 of excel matrix 
					#print type(j), j, 'J'
					#print type(k), k, 'K'
					if type(j)!=int and k >= j and k < j + timedelta(days=7):
					#print excel_matrix.index(j)
						#print type(oppID)
						#print j
						col = excel_matrix[0][0].index(j)
						row = Idlist.index(oppID)+1  #this line is causing an error for Opp IDs
						#print row
						dep = 0
						dollar_val = float(i['MILESTONE_VALUE__C'])
						if excel_matrix[dep][row][col] == 0:
							excel_matrix[dep][row][col] = '='+str(dollar_val)
							excel_matrix[2][row][col] = status
							excel_matrix[1][row][col] = str(milestone_name)+' - '+str(prjct_name)+' - '+str(status)+' - $'+str(dollar_val)+' - '+str(percentage)+'% - '+due_Date #add due date
							
						else:
							excel_matrix[dep][row][col] = excel_matrix[dep][row][col]+'+'+str(dollar_val)
							excel_matrix[1][row][col] = excel_matrix[1][row][col]+'\n\n'+str(milestone_name)+' - '+str(prjct_name)+' - '+str(status)+' - $'+str(dollar_val)+' - '+str(percentage)+'% - '+due_Date#add due date
							excel_matrix[2][row][col] = status
					else:
						pass
			else:
				pass
			pass