import pandas as pd
import os

"""
for filename in os.listdir(directory):
    if filename.endswith(".xlsx")
        print(os.path.join(directory,filename)) 
        continue
    else:
        continue
"""


df1 = pd.read_excel (r'C:\Users\Mitchell.Dawson\Dropbox\NGER 2019\1 - Recevied Docs\10.1 Manildra flour mill\Data Request Form-NGER FY2019 - Manildra Mill rev.xlsx')


to_drop = ['Unnamed: 0','Unnamed: 6','Unnamed: 7','Unnamed: 8','Unnamed: 9']
df1.drop(to_drop, inplace=True, axis=1)

rows_to_drop = list(range(0,33)) + list(range(133,243))
#print rows_to_drop

df1.drop(df1.index[rows_to_drop], inplace=True)
df1.reset_index(inplace=True)
df1 = df1[pd.notnull(df1['Unnamed: 3'])]
df1 = df1[pd.notnull(df1['Unnamed: 2'])]
#print df.head(10)

#print(df1)

total_rows = len(df1.index)
print total_rows

writer = pd.ExcelWriter(r'C:\Users\Mitchell.Dawson\Dropbox\NGERS scripts\export_dataframe.xlsx', engine='xlsxwriter')

df1.to_excel (writer, sheet_name='Sheet1', header=True)

#test
df2 = pd.read_excel (r'C:\Users\Mitchell.Dawson\Dropbox\NGER 2019\1 - Recevied Docs\10.2 Narrandera Flour Mills\NFM Data Request Form-NGER 2019.xlsx')


to_drop = ['Unnamed: 0','Unnamed: 6','Unnamed: 7','Unnamed: 8','Unnamed: 9']
df2.drop(to_drop, inplace=True, axis=1)

rows_to_drop = list(range(0,33)) + list(range(133,243))
#print rows_to_drop

df2.drop(df2.index[rows_to_drop], inplace=True)
df2.reset_index(inplace=True)
df2 = df2[pd.notnull(df2['Unnamed: 3'])]
df2 = df2[pd.notnull(df2['Unnamed: 2'])]
#print df.head(10)

#print(df1)


df2.to_excel (writer, sheet_name='Sheet1', startrow=total_rows+1, header=False)
writer.save()

#test