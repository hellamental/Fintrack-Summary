from sys import argv
import os
import csv
from datetime import datetime, date, timedelta
from dateutil.parser import *

script, Milestones_Extract = argv
 
f = open(Milestones_Extract)
csv_dictf = csv.DictReader(f)

milestone_matrix = [] #creates a new list for csv file to import milestones into.
today = datetime.today()

for row in csv_dictf:
    if(row['STATUS__C']=='Planned' and row['RECORDTYPEID']=='0120K000000yfFVQAY' and parse(row['DUE_DATE__C'])<today):
        milestone_matrix.append(row)
    else:
        pass

for i in milestone_matrix:
    x = today + timedelta(days=8)
    i['DUE_DATE__C'] = x.strftime("%d/%m/%Y")
    print i['ID'], i['DUE_DATE__C']

#changes path to desktop
#path = "C:\Users\mceda\Desktop" #personal home pc
path = "C:\Users\Mitchell.Dawson\Desktop" #work machine
os.chdir(path)

with open('Vendor_Bringforward.csv', mode='wb') as vendor_bringforward:
    milestone_write = csv.writer(vendor_bringforward, delimiter=',')

    milestone_write.writerow(['ID','DUE_DATE__C'])
    for i in milestone_matrix:
        milestone_write.writerow([i['ID'], i['DUE_DATE__C']])