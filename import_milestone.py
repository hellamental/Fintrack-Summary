import os
import csv

#csv_file = 'milestone_extract.csv'

def import_milestone(csv_filename):
    
    f = open(csv_filename)
    csv_f = csv.reader(f)
    csv_dictf = csv.DictReader(f)

    milestone_matrix = [] #creates a new list for csv file to import milestones into.

    for row in csv_dictf:
        if(row['STATUS__C']!='Forecast' and row['DUPLICATED_MILESTONE__C']=='false' and row['CONTRACT_STAGE__C']!='Inactive' and row['OPPORTUNITY_STAGE__C']!='Closed Lost'):
            if(row['CONTRACT__C']=='' and row['OPPORTUNITY__C']==''):
                pass
            else:
                milestone_matrix.append(row)
        else:
            pass

    return milestone_matrix
#and row['OPPORTUNITY_STAGE__C']!='Closed Lost'#

#import_milestone(csv_file)

def import_accounts(csv_filename):
    
    f = open(csv_filename)
    csv_dictf = csv.DictReader(f)

    account_matrix = [] #creates a new list for csv file to import milestones into.

    for row in csv_dictf:
	   account_matrix.append(row)
    
    #del contract_matrix[0]
    #print milestone_matrix
    return account_matrix


#import_milestone(csv_file)

def import_opportunities(csv_filename):
	f = open(csv_filename)
	csv_dictf = csv.DictReader(f)

	opportunity_matrix = []

	for row in csv_dictf:
		opportunity_matrix.append(row)

	#del opportunity_matrix[0]

	return opportunity_matrix	

def import_contract(csv_filename):
    
    f = open(csv_filename)
    csv_dictf = csv.DictReader(f)

    contract_matrix = [] #creates a new list for csv file to import milestones into.

    for row in csv_dictf:
        #contract_matrix.append(row)
        
        if(row['STATUS']!='Inactive'):
            contract_matrix.append(row)
        else:
            pass
        
    return contract_matrix