from sys import argv
from Fin_Recon_Functions import *
from excel_file_writer import *
import xlsxwriter
import os
import sys
reload(sys)
sys.setdefaultencoding('utf-8')


#import milestones and opportunities csv data
script, milestone_csv, opportunity_csv, contractId = argv

#filter out only milestones and opportunitites applicable to contract # and add to array
milestone_matrix = import_milestone2(milestone_csv,contractId)
project_matrix = import_opportunities2(opportunity_csv,contractId)

print len(milestone_matrix)
print len(project_matrix)

#set file output path
path = "C:\Users\Mitchell.Dawson\Desktop"
os.chdir(path)
print os.getcwd()

#set workbook name and create
today = datetime.today().strftime("%Y-%m-%d")
workbook_filename = "Project Recon Summary " + str(today) + ".xlsx"
workbook = xlsxwriter.Workbook(workbook_filename)

#creates worksheet with name 'Summary Sheet'
worksheet = workbook.add_worksheet('Summary sheet')

#sort project array by alphabetical order
project_matrix.sort(key = lambda project_matrix: project_matrix['NAME'])

for i in project_matrix:
    print i['ID'] + ' ' + i['NAME'] + ' ' + i['VD_PROJECT_VALUE__C'] + ' ' + i['POST_RFQ_PROJECT_VALUE__C']

#(opportunity) project information required - Site Name, System size, State, Project Cost (Pre RFQ), Project Cost (Post RFQ), Contract ID,
# Milestone information - Value, Project name

w, h, d = 12, len(project_matrix)+1, 2;
excel_matrix = [[[0 for x in range(w)] for y in range(h)] for z in range(d)]

x=0
ycount = 0
xcount = 0
zcount = 0
headings = ['ProjectID','Project Name','State','Pre RFQ Value','Post RFQ Value','Milestone1','Milestone2','Milestone3','Milestone4','Variation','Invoiced to Date','Left to Invoice']

for i in headings:
   excel_matrix[zcount][ycount][xcount] = i
   xcount += 1


ycount = 1
zcount = 0

for i in project_matrix:
    excel_matrix[zcount][ycount][0] = i['ID']
    excel_matrix[zcount][ycount][1] = i['NAME']
    excel_matrix[zcount][ycount][2] = i['OPPORTUNITY_STATE__C']
    excel_matrix[zcount][ycount][3] = float(i['VD_PROJECT_VALUE__C'])
    try:
        excel_matrix[zcount][ycount][4] = float(i['POST_RFQ_PROJECT_VALUE__C'])
    except:
        pass

    for j in milestone_matrix:
        if j['OPPORTUNITY__C'] == i['ID']:
            if j['MILESTONE_TYPE__C'] == '1a - On Contract':
                excel_matrix[zcount][ycount][5] = float(j['MILESTONE_VALUE__C'])
                excel_matrix[1][ycount][5] = j['STATUS__C']
            elif j['MILESTONE_TYPE__C'] == 'I. 2 - Supply / Delivery of Energy Efficient Equipment to site':
                excel_matrix[zcount][ycount][6] = float(j['MILESTONE_VALUE__C'])
                excel_matrix[1][ycount][6] = j['STATUS__C']
            elif j['MILESTONE_TYPE__C'] == 'I. 3 - Issue of certificate(s) of practical completion':
                excel_matrix[zcount][ycount][7] = float(j['MILESTONE_VALUE__C'])
                excel_matrix[1][ycount][7] = j['STATUS__C']
            elif j['MILESTONE_TYPE__C'] == 'I. 4a - Grid Connection':
                excel_matrix[zcount][ycount][8] = float(j['MILESTONE_VALUE__C'])
                excel_matrix[1][ycount][8] = j['STATUS__C']
            elif j['MILESTONE_TYPE__C'] == 'Other' or j['MILESTONE_TYPE__C'] == 'Variance':
                excel_matrix[zcount][ycount][9] = float(j['MILESTONE_VALUE__C'])
                excel_matrix[1][ycount][9] = j['STATUS__C']
            else: 
                pass
        else:
            pass
            

    ycount += 1

print excel_matrix

write_to_excel2(excel_matrix,0,2,worksheet,workbook)

            

workbook.close()