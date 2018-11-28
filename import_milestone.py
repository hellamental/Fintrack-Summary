import csv

#csv_file = 'milestone_extract.csv'

def import_milestone(csv_filename):
    
    f = open(csv_filename)
    csv_f = csv.reader(f)

    milestone_matrix = [] #creates a new list for csv file to import milestones into.

    for row in csv_f:
        if(row[44]!='Forecast' and row[53]=='false'):
	    #list_of_IDs.append(row[0])
	    #count += 1
            milestone_matrix.append(row)
        else:
            pass
    #print len(milestone_matrix), '//len before cull'
    del milestone_matrix[0]
    #print len(milestone_matrix), '//len after cull'

    #print milestone_matrix
    return milestone_matrix


#import_milestone(csv_file)

def import_accounts(csv_filename):
    
    f = open(csv_filename)
    csv_f = csv.reader(f)

    account_names = [] #creates a new list for csv file to import milestones into.

    for row in csv_f:
	   contract_matrix.append(row)
    
    del contract_matrix[0]
    #print milestone_matrix
    return contract_matrix


#import_milestone(csv_file)

def import_opportunities(csv_filename):
	f = open(csv_filename)
	csv_f = csv.reader(f)

	opportunity_matrix = []

	for row in csv_f:
		opportunity_matrix.append(row)

	del opportunity_matrix[0]

	return opportunity_matrix	