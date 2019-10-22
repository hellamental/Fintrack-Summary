import pandas as pd
import os

path = r"C:\Salesforce\DataExports" 
os.chdir(path)
print os.getcwd()


data = pd.read_csv('MilestoneExtract.csv')
data.drop(columns=['DUPLICATED_MILESTONE__C','COMMENT__C'], inplace=True)

print data.head()

print data.info()
