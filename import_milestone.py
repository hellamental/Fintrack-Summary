import os
import csv

#csv_file = 'milestone_extract.csv'

def import_milestone(csv_filename):
    
    f = open(csv_filename)
    csv_f = csv.reader(f)
    csv_dictf = csv.DictReader(f)

    milestone_matrix = [] #creates a new list for csv file to import milestones into.

    for row in csv_dictf:
        if(row['STATUS__C']!='Forecast' and row['DUPLICATED_MILESTONE__C']=='false'):
            milestone_matrix.append(row)
        else:
            pass
    """

    do yo want to build a snow mannn
    print milestone_matrix[0]
    print "hello"
    milestone_matrix2 = []
    for row in csv_f:
        if(row[44]!='Forecast' and row[53]=='false'):
	    #list_of_IDs.append(row[0])
	    #count += 1
            milestone_matrix2.append(row)
        else:
            pass
    print len(milestone_matrix2), '//len before cull'
    del milestone_matrix2[0]
    #print len(milestone_matrix), '//len after cull'

    #print milestone_matrix
    """
    return milestone_matrix


#import_milestone(csv_file)

def import_accounts(csv_filename):
    
    f = open(csv_filename)
    csv_dictf = csv.reader(f)

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

path = "C:\Users\mceda\OneDrive - Verdia Pty Ltd\Fintracker Export Project\Fintrack Script"
os.chdir(path)
csv_file = 'MilestoneExtract.csv'
import_milestone(csv_file)