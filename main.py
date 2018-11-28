from sys import argv
from import_milestone import *
from remove_duplicate import *
from datetime import datetime, date
from excel_file_writer import *
from dateutil.parser import *
from datetime_convert import *
from working_with_date import *
import xlsxwriter
import os

print os.getcwd()

#imports csv_filename as argument for csv load functino later on in the code. 
script, milestone_csv, contract_csv = argv

path = "C:\Users\mceda\Desktop"
os.chdir(path)
print os.getcwd()

today = datetime.today().strftime("%Y-%m-%d_%H-%M-%S")

workbook_filename = "Project_Fintrack_Summary_" + str(today) + ".xlsx"
print workbook_filename
#creates workbook with name (using xlsx writer module)
workbook = xlsxwriter.Workbook(workbook_filename)

#creates worksheet with name 'Summary Sheet'
worksheet = workbook.add_worksheet('Summary sheet')

#1. imports milestones from csv file and loads values into 2x dimensional matrix - in string format. 
milestone_matrix = import_milestone(milestone_csv)
contract_matrix = import_opportunities(contract_csv)

print len(milestone_matrix), '//Number of Milestones'
#creates a unique list from 29th element of milestone matrix
ContractIdList = unique_list(milestone_matrix,17)

OppIdList = []
for i in contract_matrix:
    if i[282] in ContractIdList:
        OppIdList.append(i[0])
    else:
        pass

#print OppIdList

print len(ContractIdList), '//Contract Id List'
try: 
    ind = ContractIdList.index('')
    del ContractIdList[ind]
except ValueError:
    pass
#del ContractIdList[0]

#print ContractIdList
#print OppIdList
#print ContractIdList
#del OppIdList[0] #deletes the heading to leave only values of list.
#del ContractIdList[0]
#print OppIdList
#x = OppIdList.index('') #identfies the position of any blanks and assigns index to x variable
#del OppIdList[x] deletes x indexed value from list.


ContractIDName = {}
for i in ContractIdList:
    for j in contract_matrix:
        if i == j[37]:
            ContractIDName.update({str(j[37]):j[5]})
        else:
            pass    

ProjectIDName = {'':"Contract Level"}
for i in OppIdList:
    for j in contract_matrix:
        if i == j[0]:
            ProjectIDName.update({str(j[0]):j[5]})
        else:
            pass    
#print ContractIDName
#print ProjectIDName
#print TopRowDateList
TopRowDateList = TopRowDateList(milestone_matrix)

excel_matrix = matrix_creator_3D(TopRowDateList,ContractIdList,milestone_matrix,ContractIDName)

#adds desired money format to excel writer 

#deletes headers from milestone matrix, leaving only values. 
#del milestone_matrix[0]

numrows = len(excel_matrix)
numcols = len(excel_matrix[0])
numdep = len(excel_matrix[0][0]) 
numrows2 = len(OppIdList)

#print numrows, "//num rows"
#print numcols, "//num cols"
#print numrows2
#print numdep, "/depth"


#print excel_matrix[0][10][0] # row 10

#print excel_matrix[0][0][10] # col 10

#print excel_matrix[10][0][0] # depth 10

#print ContractIdList
excel_matrix_populator(milestone_matrix,excel_matrix,'ContractIdList',ContractIdList,"Invoice_Milestone")


excel_offset_col = 3
excel_offset_row = 12
write_to_excel(excel_matrix,excel_offset_col,excel_offset_row,worksheet,workbook)


excel_offset_row = numrows + excel_offset_row + 10

excel_matrix = []
excel_matrix = matrix_creator_3D(TopRowDateList,ContractIdList,milestone_matrix,ContractIDName)
excel_matrix_populator(milestone_matrix,excel_matrix,'ContractIdList',ContractIdList,"Vendor_Payment_Milestone")

write_to_excel(excel_matrix,excel_offset_col,excel_offset_row,worksheet,workbook)

excel_offset_row = 12



for i in ContractIdList:
    if i == '':
        pass
    else:
        name = ContractIDName[i]
        name2 = name[0:30]               
        worksheet_name = workbook.add_worksheet(name2)
    
        RelOppIdList = ['']
        for j in contract_matrix:   
            if j[282] == i: #if contract id of milestone matches the current contract id in the array, proceed to add opp id to list.
                RelOppIdList.append(j[0])    
            else:
                pass
        RelOppIdList = unique_list2(RelOppIdList)
        #print i, '//contract ID'
        #print RelOppIdList, '//OppIDList'
        #print len(RelOppIdList)

        excel_offset_col = 3
        excel_offset_row = 12

        milestone_types = ["Invoice_Milestone","Vendor_Payment_Milestone"]
        for milestone_type in milestone_types:  
                
            excel_matrix = []
            excel_matrix = matrix_creator_3D(TopRowDateList,RelOppIdList,milestone_matrix,ProjectIDName)
            
            excel_matrix_populator_site2(milestone_matrix,excel_matrix,'OppIdList',RelOppIdList,milestone_type,i) # this is where the issue occurs on the second contract ID
            write_to_excel(excel_matrix,excel_offset_col,excel_offset_row,worksheet_name,workbook)    

            numrows = len(excel_matrix[0])
            excel_offset_row = numrows + excel_offset_row + 10


#insPymtLeged(workbook,worksheet,today_col)
#    col = excel_matrix[0].index(i)
#    row = excel_matrix.index(i)
#    x = str(i)
#    worksheet.write(row,col,dollar_val,money_format)
#print excel_matrix

#print excel_matrix

#print excel_matrix

#closes the excel workbook
workbook.close()