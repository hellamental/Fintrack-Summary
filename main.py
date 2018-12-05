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
import sys
reload(sys)
sys.setdefaultencoding('utf-8')


print os.getcwd()

#imports csv_filename as argument for csv load functino later on in the code. 
script, milestone_csv, opportunity_csv, account_csv, contract_csv = argv

#path = "C:\Users\Mitchell.Dawson\Desktop"
path = r"C:\Users\Mitchell.Dawson\Verdia Pty Ltd\Verdia Internal - Documents\Project Delivery\00 PMO General\Project Financials\Autogen Fintracker"
#path = "C:\Users\mceda\Desktop"
os.chdir(path)
print os.getcwd()

today = datetime.today().strftime("%Y-%m-%d_%H-%M-%S")

workbook_filename = "Project_Fintrack_Summary_" + str(today) + ".xlsx"

print workbook_filename
#creates workbook with name (using xlsx writer module)
workbook = xlsxwriter.Workbook(workbook_filename)

#creates worksheet with name 'Summary Sheet'
worksheet = workbook.add_worksheet('Summary sheet')
worksheet.write('B2', "Project Fintracker")
worksheet.write('B3', "Cashflow Summary")

#1. imports milestones from csv file and loads values into 2x dimensional matrix - in string format. 
milestone_matrix = import_milestone(milestone_csv)
opportunity_matrix = import_opportunities(opportunity_csv)
account_matrix = import_accounts(account_csv)
contract_matrix = import_contract(contract_csv)

#print account_matrix[0] 

print len(milestone_matrix), '//Number of Milestones'
#creates a unique list of the contract numbers in the milestone matrix
ContractIdList = unique_list(milestone_matrix,'CONTRACT__C')
#print ContractIdList
OppIdList = []
for i in opportunity_matrix:
    prjct_contract = i['PROJECT_CONTRACT__C']
    if prjct_contract in ContractIdList:
        OppIdList.append(i['ID'])
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

print ContractIdList

ContractIDName = {}
for i in ContractIdList:
    for j in opportunity_matrix:
        if i == j['CONTRACTID']:
            ContractIDName.update({str(j['CONTRACTID']):j['NAME']})
        else:
            pass    

ProjectIDName = {'':"Contract Level"}
for i in OppIdList:
    for j in opportunity_matrix:
        if i == j['ID']:
            ProjectIDName.update({str(j['ID']):j['NAME']})
        else:
            pass    
#print ContractIDName
#print ProjectIDName
#print TopRowDateList
TopRowDateList = TopRowDateList(milestone_matrix)

excel_matrix = matrix_creator_3D(TopRowDateList,ContractIdList,milestone_matrix,ContractIDName,contract_matrix)

#adds desired money format to excel writer 

#deletes headers from milestone matrix, leaving only values. 
#del milestone_matrix[0]

numdep = len(excel_matrix)
numrows = len(excel_matrix[0])
numcols = len(excel_matrix[0][0]) 
print numdep
print numrows
print numcols

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


excel_offset_col = 1
excel_offset_row = 8
write_to_excel(excel_matrix,excel_offset_col,excel_offset_row,worksheet,workbook)


excel_offset_row = numrows + excel_offset_row + 10

excel_matrix = []
excel_matrix = matrix_creator_3D(TopRowDateList,ContractIdList,milestone_matrix,ContractIDName,contract_matrix)
excel_matrix_populator(milestone_matrix,excel_matrix,'ContractIdList',ContractIdList,"Vendor_Payment_Milestone")

write_to_excel(excel_matrix,excel_offset_col,excel_offset_row,worksheet,workbook)

excel_offset_row = 8



for i in ContractIdList:
    if i == '':
        pass
    else:
        name = ContractIDName[i]
        name2 = name[0:30]               
        worksheet_name = workbook.add_worksheet(name2)
    
        RelOppIdList = ['']
        for j in opportunity_matrix:   
            if j['PROJECT_CONTRACT__C'] == i: #if contract id of milestone matches the current contract id in the array, proceed to add opp id to list.
                RelOppIdList.append(j['ID'])    
            else:
                pass
        RelOppIdList = unique_list2(RelOppIdList)
        #print i, '//contract ID'
        #print RelOppIdList, '//OppIDList'
        #print len(RelOppIdList)

        excel_offset_col = 1
        excel_offset_row = 8

        milestone_types = ["Invoice_Milestone","Vendor_Payment_Milestone"]
        for milestone_type in milestone_types:  
                
            excel_matrix = []
            excel_matrix = matrix_creator_3D(TopRowDateList,RelOppIdList,milestone_matrix,ProjectIDName,contract_matrix)
            
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