from datetime import datetime, date
from dateutil.parser import *
from remove_duplicate import *

def str_to_datetime(milestone_matrix):

    dates_list = []
    for i in milestone_matrix:
        dates_list.append(i['DUE_DATE__C'])

    del dates_list[0]
#   print (final_date_list)
    
    count = 0
    final_date_list2 = []
    for i in dates_list:
            if i == '':
                print 'true'
            else: 
                x = parse(i) 
                final_date_list2.append(x)
                #final_date_list2.append(datetime.strptime(x, '%d%M%Y'))
                #print final_date_list2[-1]
    
    #print (final_date_list2)
    #print len(final_date_list2)

    return final_date_list2

def str_to_datetime_remove_duplicates(milestone_matrix):

    dates_list = []
    for i in milestone_matrix:
        dates_list.append(i[20])

    dates_list = remove_duplicates(dates_list)

    del dates_list[0]
    #print (final_date_list)
    
    count = 0
    final_date_list2 = []
    for i in date_list:
            if i == '':
                print 'true' 
            else: 
                #print i
                x = parse(i) 
                final_date_list2.append(x)
                #final_date_list2.append(datetime.strptime(x, '%d%M%Y'))
                #print final_date_list2[-1]

    
    #print (final_date_list2)
    #print len(final_date_list2)

    earliest_date = min(final_date_list2)
    latest_date = max(final_date_list2)

    return final_date_list2
    return earliest_date
    return latest_date


