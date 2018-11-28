from sys import argv
from import_milestone import import_milestone
from remove_duplicate import *
from datetime import datetime, date
from excel_file_writer import write_to_excel
from dateutil.parser import *
from datetime_convert import *
from working_with_date import *
import xlsxwriter

#imports csv_filename as argument for csv load functino later on in the code. 
script, csv_filename = argv


#creates workbook with name (using xlsx writer module)
workbook = xlsxwriter.Workbook('Project Fintrack Summary.xlsx')

#creates worksheet with name 'Summary Sheet'
worksheet = workbook.add_worksheet('Summary sheet')

#1. imports milestones from csv file and loads values into 2x dimensional matrix - in string format. 
milestone_matrix = import_milestone(csv_filename)

#creates a unique list from 29th element of milestone matrix
OppIdList = unique_list(milestone_matrix,29)
del OppIdList[0] #deletes the heading to leave only values of list.
#print OppIdList
#x = OppIdList.index('') #identfies the position of any blanks and assigns index to x variable
#del OppIdList[x] deletes x indexed value from list.



#convert str format to datetime
DateList = str_to_datetime(milestone_matrix)
final_DateList = remove_duplicates(DateList) # removes duplicate dates from list into milestone date list

min_date = min(final_DateList)
max_date = max(final_DateList)

print "Min Date", min_date
print "Max Date", max_date

#takes min milestones and calculates closest monday date, and maps all dates from min to max in a list
TopRowDateList = date_mapping(min_date, max_date)
#print TopRowDateList


#trying to feed values into matrix
w, h = len(TopRowDateList)+1, len(OppIdList)+1;
excel_matrix = [[0 for x in range(w)] for y in range(h)]

print len(TopRowDateList)
print len(OppIdList)

#adds weekstart dates to each element in first row of matrix.
ycount = 0
xcount = 1

for i in TopRowDateList:    
        x = i#.strftime("%d-%m-%Y")
        excel_matrix[ycount][xcount]=x 
        xcount += 1

#adds Opportunity ID list to each element in first col of matrix.
ycount = 1
xcount = 0

for i in OppIdList:
        excel_matrix[ycount][xcount]=i
        ycount += 1

#adds desired money format to excel writer 
money_format = workbook.add_format({'num_format': '$#,##0.00'})
del milestone_matrix[0] #deletes headers from milestone matrix, leaving only values. 

numrows = len(excel_matrix)
numcols = len(excel_matrix[0])

numrows2 = len(OppIdList)
print numrows
print numcols
print numrows2
#print excel_matrix[0]

for i in milestone_matrix:
    
    if i[40] == "Invoice_Milestone":
        due_Date = i[20]
        oppID = i[29]
        if due_Date == '':
            pass
        else:
            k = parse(due_Date)
            #print excel_matrix[0]
            for j in excel_matrix[0]: #for j in line 1 of excel matrix 
                if type(j)!=int and k >= j and k < j + timedelta(days=7):
                #print excel_matrix.index(j)
                    #print type(oppID)
                    col = excel_matrix[0].index(j)
                    row = OppIdList.index(oppID)+1
                    dollar_val = float(i[27])
                    if excel_matrix[row][col] == 0:
                        excel_matrix[row][col] = '='+str(dollar_val)
                    else:
                        excel_matrix[row][col] = excel_matrix[row][col]+'+'+str(dollar_val)
                else:
                    pass
    else:
        pass

numcols = len(excel_matrix[0])
numrows = len(excel_matrix)


xcount = 0
while xcount < numcols:
    ycount = 0
    while ycount < numrows:
        x = excel_matrix[ycount][xcount]
        if type(x) == datetime:
            value = x.strftime("%d-%m-%Y")
        else:
            value = x
        if value == 0:
            pass
        else:
            #worksheet.write(ycount,xcount,value)
        ycount += 1
    xcount += 1


#    col = excel_matrix[0].index(i)
#    row = excel_matrix.index(i)
#    x = str(i)
#    worksheet.write(row,col,dollar_val,money_format)
#print excel_matrix

"""
numrows = len(excel_matrix)
numcols = len(excel_matrix[0])
print numrows
print numcols
row = 0
col = 0
while row < numrows:
    col = 0
    while col < numcols:
        if excel_matrix[row][col] == int(0):
            pass
        else:
            x = excel_matrix[row][col]#.strftime("%d-%m-%Y")
            worksheet.write(row,col,x)
        col += 1
    row += 1

""""""
for i in excel_matrix:
    row = i.index
    print row
    #worksheet.write(row,col,value)
""""""
count = 1
for i in TopRowDateList:
    x = i.strftime("%d-%m-%Y")
    excel_matrix.insert(count, x)
    count += 1
"""
#print excel_matrix

#print excel_matrix



"""
money_format = workbook.add_format({'num_format': '$#,##0'})
del milestone_matrix[0]
row = 12
count = 0
for i in milestone_matrix:
    x = i[20]
    if x == '':
        pass
    else:
        k = parse(x)
        for j in TopRowDateList:
            if k >= j and k < j + timedelta(days=7):
                col = count + 3
                dollar_val = float(i[27])
                worksheet.write(row,col,dollar_val,money_format)
            else:
                pass
        count += 1
        row += 1    


"""

"""
money_format = workbook.add_format({'num_format': '$#,##0.00'})
del milestone_matrix[0]
row = 12
count = 0
for i in milestone_matrix:
    
    if i[40] == "Invoice_Milestone":
        due_Date = i[20]
        if due_Date == '':
            pass
        else:
            k = parse(due_Date)
            for j in TopRowDateList:
                if k >= j and k < j + timedelta(days=7):
                    col = TopRowDateList.index(j) + 3
                    row = OppIdList.index(i[29]) + 12
                    dollar_val = float(i[27])
                    worksheet.write(row,col,dollar_val,money_format)
                else:
                    pass
            count += 1
    else:
        pass    
"""
"""
#try to paste a formula into excel as a string and convert it to a formula so that it shows the addition of two milesotnes

x = "=10.51*5+406" #this method of pasting in as a string works for the write_formula method. 

worksheet.write_formula('A1', x, money_format)

"""

#closes the excel workbook
workbook.close()










"""
#2.get earliest and latests dates from milestone date list



1. imports milestones from csv file and loads values into 2x dimensional matrix - complete (function called import_milestone)
2. converts dates in list from string to datetime - complete (function called str_to_datetime)
3. gets earliest and latest due date from milestones - complete 
4. creates a new list of all monday start dates from earliest to last date - complete (function called date_mapping)
5. 
 
 - returns a list of all unique contract IDs and match with account name in dictionary(list) due date: milestone value (may have to import account information and filter - see if it can be avoided)
 - loop through all milestones, if contract ID matches, loop through due date - if due date matches - map the dollar value to the cell.
 - creates a new summary page for every unique contract number
 - order dates according to due date




creates an excel file and maps data to it








"""








