#Milestone Prep Script

from sys import argv
import xlsxwriter


#changes path to desktop
#path = "C:\Users\mceda\Desktop" #personal home pc
path = "C:\Users\Mitchell.Dawson\Desktop" #work machine
os.chdir(path)
print os.getcwd()

Project_Values = argv

workbook_filename = "MilestoneUpload.xlsx" 
print workbook_filename
workbook = xlsxwriter.Workbook(workbook_filename)
