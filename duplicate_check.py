#Milestone Prep Script
from sys import argv
import os
import csv

script, Project_Values, test2 = argv

path = "C:\Users\Mitchell.Dawson\Desktop" #work machine
os.chdir(path)
print os.getcwd()

f = open(Project_Values)
csv_f = csv.reader(f)

Existing_List = []
for row in csv_f:
    Existing_List.append(row)

print Existing_List

f2= open(test2)
csv_f2 = csv.reader(f2)

Current_List = []

for row in csv_f2:
    Current_List = []
print Current_List

New_Opps = []
for i in Current_List:
    if i not in Existing_List:
        New_Opps.append(i)    

print len(New_Opps)
#print excel_matrix         

ycount = 0
xcount = 0
with open('DuplicateCheck.csv', mode='wb') as Milestone_Upload:
    milestone_write = csv.writer(Milestone_Upload, delimiter=',')

    milestone_write.writerow(['Opp ID'])
    for i in New_Opps:
        milestone_write.writerow(i)
        ycount += 1


