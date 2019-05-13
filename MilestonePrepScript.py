#Milestone Prep Script
from sys import argv
import os
import csv

script, Project_Values = argv

path = "C:\Users\Mitchell.Dawson\Desktop" #work machine
os.chdir(path)
print os.getcwd()

f = open(Project_Values)
csv_dictf = csv.DictReader(f)

PrjctValues_Matrix = []

for row in csv_dictf:
    PrjctValues_Matrix.append(row)

print len(PrjctValues_Matrix)

w, h = 4, len(PrjctValues_Matrix)*8;
excel_matrix = [[0 for x in range(w)] for y in range(h)]

milestone_value = {
        0: "IM1 Value", #Invoice
        1: "IM2 Value", #Invoice
        2: "IM3 Value", #Invoice
        3: "IM4 Value", #Invoice
        4: "IM5 Value", #Invoice
        5: "VM1 Value", #Vendor
        6: "VM2 Value", #Vendor
        7: "VM3 Value", #Vendor
    }

    milestone_value = {
        0: "IM1 Pct", #Invoice
        1: "IM2 Pct", #Invoice
        2: "IM3 Pct", #Invoice
        3: "IM4 Pct", #Invoice
        4: "IM5 Pct", #Invoice
        5: "VM1 Pct", #Vendor
        6: "VM2 Pct", #Vendor
        7: "VM3 Pct", #Vendor
    }

milestone_recordtype = = {
        0: "0120K000000yfFUQAY", #Invoice
        1: "0120K000000yfFUQAY", #Invoice
        2: "0120K000000yfFUQAY", #Invoice
        3: "0120K000000yfFUQAY", #Invoice
        4: "0120K000000yfFUQAY", #Invoice
        5: "0120K000000yfFVQAY", #Vendor
        6: "0120K000000yfFVQAY", #Vendor
        7: "0120K000000yfFVQAY", #Vendor
    }

milestone_type = {
        0: "1a - On Contract", 
        1: "I. 1b - On Confirmed Cost",
        2: "I. 2 - Supply / Delivery of Energy Efficient Equipment to site",
        3: "I. 3 - Issue of certificate(s) of practical completion",
        4: "I. 4a - Grid Connection"
        5: "V. 1 - Goods Delivered to site",
        6: "V. 2- Practical Completion",
        7: "V. 3 - Completion of all other works",
}

milestone_name = {
        0: "1a - On Contract",
        1: "I. 1b - On Confirmed Cost",
        2: "I. 2 - Supply / Delivery of Energy Efficient Equipment to site",
        3: "I. 3 - Issue of certificate(s) of practical completion",
        4: "I. 4a - Grid Connection"
        5: "V. 1 - Goods Delivered to site",
        6: "V. 2- Practical Completion",
        7: "V. 3 - Completion of all other works",
}

#print milestone.get(0)

xcount = 0
ycount = 0
for i in PrjctValues_Matrix:
    count = 0
    while count < 8:
        excel_matrix[ycount][0] = i['Opportunity / Project ID']
        excel_matrix[ycount][1] = '0120K000000yfFUQAY' #invoice milestone record type
        milestone_insert = str(milestone_value.get(count))
        excel_matrix[ycount][3] = i[milestone_insert]
        excel_matrix[ycount][2] = i['Opportunity / Project Name']
        count += 1
        ycount += 1

print len(excel_matrix)
#print excel_matrix         

ycount = 0
xcount = 0
with open('Milestone_Upload.csv', mode='wb') as Milestone_Upload:
    milestone_write = csv.writer(Milestone_Upload, delimiter=',')

    milestone_write.writerow(['Opp ID','Record Type', 'Milestone Value', 'Opp Name'])
    for i in excel_matrix:
        milestone_write.writerow(i)
        ycount += 1


