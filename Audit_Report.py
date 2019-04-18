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
import string
reload(sys)
sys.setdefaultencoding('utf-8')


print os.getcwd()

#imports csv_filename as argument for csv load functino later on in the code. 
script, milestone_csv, opportunity_csv, account_csv, contract_csv = argv

path = "C:\Users\Mitchell.Dawson\Desktop"
os.chdir(path)
print os.getcwd()

today = datetime.today().strftime("%Y-%m-%d_%H-%M-%S")

workbook_filename = "Milestone_Summary_Report_" + str(today) + ".xlsx"

print workbook_filename
#creates workbook with name (using xlsx writer module)
workbook = xlsxwriter.Workbook(workbook_filename)

#number formats
money_format = workbook.add_format({'num_format': '$#,##0'})
percnt_format = workbook.add_format({'num_format': '0.00%'})

#cycling through column names for excel workbook writer
letters = list(string.ascii_uppercase)
print letters




#1. imports milestones from csv file and loads values into 2x dimensional matrix - in string format. 
milestone_matrix = import_milestone(milestone_csv)
opportunity_matrix = import_opportunities(opportunity_csv)
account_matrix = import_accounts(account_csv)
contract_matrix = import_contract(contract_csv)

#create a unique list of contract ID's from the milestone matrix
ContractIdList = unique_list(milestone_matrix,'CONTRACT__C')
print len(ContractIdList), '//Contract Id List'

#creates a contract id name dictionary
ContractIDName = {}
for i in ContractIdList:
    for j in opportunity_matrix:
        if i == j['CONTRACTID']:
            ContractIDName.update({str(j['CONTRACTID']):j['NAME']})
        else:
            pass
print ContractIDName

worksheet = workbook.add_worksheet('Summary')
worksheet.write('B2', "Contracts")
pos = 3
for i in ContractIDName:
    cell = 'B' + str(pos)
    worksheet.write(cell, ContractIDName[i])
    name = ContractIDName[i]
    name2 = str(r"internal:'") + str(name[0:30]) + str(r"'!A1")
    print name2
    cell = 'C' + str(pos)
    worksheet.write_url(cell, name2 )
    pos += 1

for contractID in ContractIdList:
    name = ContractIDName[contractID]
    name2 = name[0:30]               
    print name2
    worksheet = workbook.add_worksheet(name2)

    #creates worksheet with name 'Summary Sheet'
    worksheet.write('B2', name2)
    worksheet.write('B3', "Cashflow Summary")
    worksheet.write_url('B4', 'internal:Summary!A1')
    worksheet.write('F3', '=SUBTOTAL(9,F6:F733)', money_format)
    worksheet.write('R3', '=SUBTOTAL(9,R6:R733)', money_format)

    pos = 0 #column starting at A reference
    Headings = ['Milestone ID','Contract','Project Name','Milestone Name','Percentage','Milestone Value','Due Date','Status','Invoice','Comment']
    Headings2 = {'Milestone ID':'ID','Contract':'CONTRACT__C','Project Name':'PROJECT_NAME_CONTRACT__C','Milestone Name':'NAME','Percentage':'PERCENTAGE__C','Milestone Value':'MILESTONE_VALUE__C','Due Date':'DUE_DATE__C','Status':'STATUS__C','Invoice':'INVOICE__C','Comment':'COMMENT__C'}
    for i in Headings:
        cell = letters[pos] + str(5)
        worksheet.write(cell, i)
        pos += 1

    pos = 12 #column starting at A reference
    for i in Headings:
        cell = letters[pos] + str(5)
        worksheet.write(cell, i)
        pos += 1    

    line = 6
    excel_matrix = []
    for i in milestone_matrix:
        if i['CONTRACT__C']==contractID and i['RECORDTYPEID']=='0120K000000yfFUQAY':
            pos = 0
            for j in Headings:
                cell = letters[pos] + str(line)
                col = str(j)
                #print col
                data = i[Headings2[col]]
                if col == 'Milestone Value':
                    worksheet.write(cell,float(data), money_format)
                elif col == 'Due Date':
                    parse(col)
                elif col == 'Percentage' and data!="":
                    worksheet.write(cell,float(data)/100, percnt_format)
                else:  
                    worksheet.write(cell,data)
                pos += 1
            line += 1

    line = 6
    excel_matrix = []
    for i in milestone_matrix:
        if i['CONTRACT__C']==contractID and i['RECORDTYPEID']=='0120K000000yfFVQAY':
            pos = 12
            for j in Headings:
                cell = letters[pos] + str(line)
                col = str(j)
                data = i[Headings2[col]]
                if col == 'Milestone Value':
                    worksheet.write(cell,float(data), money_format)
                elif col == 'Percentage' and data!="":
                    worksheet.write(cell,float(data)/100, percnt_format)
                else:  
                    worksheet.write(cell,data)
                pos += 1
            line += 1












workbook.close()