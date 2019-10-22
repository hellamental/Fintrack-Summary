import pandas as pd

df = pd.read_excel (r'C:\Users\Mitchell.Dawson\Dropbox\NGER 2019\1 - Recevied Docs\10.1 Manildra flour mill\Data Request Form-NGER FY2019 - Manildra Mill rev.xlsx')


to_drop = ['Unnamed: 0','Unnamed: 6','Unnamed: 7','Unnamed: 8','Unnamed: 9']
df.drop(to_drop, inplace=True, axis=1)

rows_to_drop = list(range(0,33)) + list(range(133,243))
print rows_to_drop

df.drop(df.index[rows_to_drop], inplace=True)
df.reset_index(inplace=True)
#print df.head(10)

print(df)


