import csv

def import_milestone(csv_filename):

	f = open(csv_filename)
	csv_f = csv.reader(f)

	milestone_matrix = []

	for row in csv_f:
		if(row[44]!='Forecast'):
			#list_of_IDs.append(row[0])
			count += 1
			milestone_matrix.append(row)
	
	del milestone_matrix[0]

	return milestone_matrix

def import_opportunities(csv_filename):
	f = open(csv_filename)
	csv_f = csv.reader(f)

	opportunity_matrix = []

	for row in csv_f:
		opportunity_matrix.append(row)

	del opportunity_matrix[0]

	return opportunity_matrix	
		
#print 'Real Milestones '
#print count 
#print milestone_matrix

# lay out the date in the top row.

#Icontract_ids = []
#count = 0 #reset count 

#csv_f.seek(0,0)

#creates a new list called contract_ids of invoice milestones that are not forecast
#vendor payment milestones & removes all the duplicate contract_ids from the list. 

"""for row in milestone_matrix:
	if(row[40]=='Invoice_Milestone' and row[44]!='Forecast'):
		Icontract_ids.append(row[17])
		count += 1

#print contract_ids
print 'invoice milestone count'
print count

Iunique_ids = remove(Icontract_ids)
print 'unique invoice contract ids'
print Iunique_ids
print len(Iunique_ids)


count = 0 # reset count
Vcontract_ids = []

for row in milestone_matrix:
	if(row[40]=='Vendor_Payment_Milestone' and row[44]!='Forecast'):
		Vcontract_ids.append(row[17])
		count += 1

print 'vendor milestone count'
print count

Vunique_ids = remove(Vcontract_ids)
print 'unique vendor contract ids'
print Vunique_ids
print len(Vunique_ids)

#due date is row[20]
#milestone_name is row[3]
#Owner_ID is row[1]
#unique_MS_ID is row[0]
#invoice_Id is row[24]
#milestone_value is row[27]
#opportunity_ID is row[28]
#Percentage is row[32]
#Project_Name is row[35]"""