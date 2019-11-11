from sys import argv
import os
import csv
import xlsxwriter
import pandas as pd


script, pipeline_extract1, pipeline_extract2 = argv

path = r"D:\Verdia Pty Ltd\Systems Tools and IT - Salesforce\Data Extracts\Opportunities"
os.chdir(path)
print os.getcwd()


#pipeline_extract1 = "OpportunityExtract_20191101.csv"
pipeline1 = pd.read_csv(pipeline_extract1)


pipeline2 = pd.read_csv(pipeline_extract2)

#pipeline1['VD_PROJECT_VALUE__C'] = pipeline1['VD_PROJECT_VALUE__C'].map('${:,.2f}'.format)
#print pipeline1.head()


pipeline1 = pipeline1.query("RECORDTYPEID == '0120K000000yfFWQAY'") 
pipeline1 = pipeline1.dropna(subset =['SALES_TEAM__C']) 
#Total = pipeline1['VD_PROJECT_VALUE__C'].sum()
#print Total

#g1 = pipeline1.groupby(['STAGENAME'])['VD_PROJECT_VALUE__C'].sum()
g1 = pipeline1.groupby(['STAGENAME'])['VD_PROJECT_VALUE__C'].sum().reset_index(name='Project Value')
#g1.drop(['Project Complete','Deliver','Develop','Evaluate','Finance Application'])
g1['Project Value'] = g1['Project Value']/1000000
#g1['Project Value'] = g1['Project Value'].map('${:,.2f}M'.format)

print g1

pipeline2 = pipeline2.query("RECORDTYPEID == '0120K000000yfFWQAY'") 
pipeline2 = pipeline2.dropna(subset =['SALES_TEAM__C']) 

g2 = pipeline2.groupby(['STAGENAME'])['VD_PROJECT_VALUE__C'].sum().reset_index(name='Project Value')
#g1.drop(['Project Complete','Deliver','Develop','Evaluate','Finance Application'])
g2['Project Value'] = g2['Project Value']/1000000
#g2['Project Value'] = g2['Project Value'].map('${:,.2f}M'.format)

print g2

g3 = pd.merge(g1,g2, on='STAGENAME')
g3['Difference'] = g3['Project Value_y'] - g3['Project Value_x'] 

g3['Project Value_y'] = g3['Project Value_y'].map('${:,.2f}M'.format)
g3['Project Value_x'] = g3['Project Value_x'].map('${:,.2f}M'.format)
g3['Difference'] = g3['Difference'].map('${:,.2f}M'.format)
print g3
#today = datetime.today().strftime("%Y-%m-%d_%H-%M-%S")

#workbook_filename = "Pipeline Analysis_" + str(today) + ".xlsx"

#print workbook_filename
#workbook = xlsxwriter.Workbook(workbook_filename)

#worksheet = workbook.add_worksheet('Summary sheet') #------------------------->
#worksheet.write('B2', "Project Fintracker") #------------------------->
#worksheet.write('B3', "Cashflow Summary") #------------------------->
#worksheet.write('B4', "Project Fintracker") #------------------------->
#worksheet.write('B5', "Cashflow Summary") #update all cells with cel reference summing stage totals. 



#opportunity_matrix = import_opportunities(opportunity_csv)