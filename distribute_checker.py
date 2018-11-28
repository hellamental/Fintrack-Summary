from sys import argv
from import_milestone import *
from remove_duplicate import *
from excel_file_writer import *
import xlsxwriter

script, milestone_csv = argv

#creates workbook with name (using xlsx writer module)
workbook = xlsxwriter.Workbook('duplicate_Check2.xlsx')

#creates worksheet with name 'Summary Sheet'
worksheet = workbook.add_worksheet('Summary sheet')

#import milestone ands attach to milestone matrix

milestone_matrix = import_milestone(milestone_csv)

#create unique contract ID list
contractIdList = []
for i in milestone_matrix:
    if i[17] not in contractIdList:
        contractIdList.append(i[17])
    else:
        pass

print len(contractIdList)   
print contractIdList

count = 0 
for i in contractIdList:
    
    RelOppIdList = []
    MilestoneID = []
    for j in milestone_matrix:   
        if j[17] == i: 
            RelOppIdList.append(j[29])
            MilestoneID.append(j[0])    
        else:
            pass
    RelOppIdList = unique_list2(RelOppIdList)
    
    if len(RelOppIdList) > 1 and ('' in RelOppIdList):
        print i
        print RelOppIdList
        worksheet.write(count,0,MilestoneID[0])
        worksheet.write(count,1,i)

        count += 1

print count 



workbook.close()