import os
import csv
from datetime import date
from datetime import datetime
from datetime import timedelta
from datetime_convert import *

def import_milestone2(csv_filename,contractId):
    
    f = open(csv_filename)
    csv_f = csv.reader(f)
    csv_dictf = csv.DictReader(f)

    milestone_matrix = [] #creates a new list for csv file to import milestones into.

    for row in csv_dictf:
        #if(row['STATUS__C']!='Forecast' and row['STATUS__C']!='Planned' and row['DUPLICATED_MILESTONE__C']=='false' and (contractId in row['CONTRACT__C'])):
        if(row['STATUS__C']!='Forecast' and row['DUPLICATED_MILESTONE__C']=='false' and (contractId in row['CONTRACT__C'])):   
            milestone_matrix.append(row)
        else:
            pass

    return milestone_matrix

def import_opportunities2(csv_filename,contractId):
    f = open(csv_filename)
    csv_dictf = csv.DictReader(f)

    opportunity_matrix = []

    for row in csv_dictf:
        if(contractId in row['PROJECT_CONTRACT__C']):
            opportunity_matrix.append(row)
        else:
            pass

    #del opportunity_matrix[0]

    return opportunity_matrix

#returns column name from number input

def excel_column_Ref(number_of_columns): #returns the lettered column reference of input number of columns

    ascii_uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    alphabet_list = []


    char = ascii_uppercase[number_of_columns]
    #print len(ascii_uppercase)
    #print char

def colnum_string(n):
    string = ""
    while n > 0:
        n, remainder = divmod(n - 1, 26)
        string = chr(65 + remainder) + string
    return string

#print colnum_string(353)
#output:AB

def get_cell_ref2(column_no,row_no):
    col_letter = colnum_string(column_no)
    cell_ref = col_letter + str(row_no)
    #print cell_ref
    return cell_ref

def col_reference(start_col,finish_col):
    colstart_letter = colnum_string(start_col)
    colfin_letter = colnum_string(finish_col)
    range1 = colstart_letter + ':' + colfin_letter
    return range1

def col_reference_row(start_col,finish_col,row,row2):
    colstart_letter = colnum_string(start_col)
    colfin_letter = colnum_string(finish_col)
    range1 = colstart_letter + str(row) + ':' + colfin_letter + str(row2)
    return range1

def col_reference_row2(col_ref,row,row2):
    Separate_col_ref = col_ref.split(":")
    range1 = Separate_col_ref[0] + str(row) + ':' + Separate_col_ref[1] + str(row2)
    return range1

def collapse_column(start_col, finish_col, worksheet):
    colstart_letter = colnum_string(start_col)
    colfin_letter = colnum_string(finish_col)
    range2 = colnum_string(finish_col+1)+ ':' +colnum_string(finish_col+1)
    range1 = colstart_letter + ':' + colfin_letter
    #print range1
    #print range2
    worksheet.set_column(range1, None, None, {'level': 1, 'hidden': False})
    worksheet.set_column(range2, None, None, {'collapsed': False})

def write_to_excel2(excel_matrix,excel_offset_col,excel_offset_row,worksheet,workbook):
    money_format = workbook.add_format({'num_format': '$#,##0'})
    money_format.set_font_size(9)
    paid_format = workbook.add_format()
    paid_format.set_bg_color('#92D050')
    paid_format.set_num_format('$#,##0')
    paid_format.set_font_size(9)
    awaiting_payment = workbook.add_format()
    awaiting_payment.set_bg_color('#FFFF00')
    awaiting_payment.set_num_format('$#,##0')
    awaiting_payment.set_font_size(9)
    overdue = workbook.add_format()
    overdue.set_bg_color('#FF0000')
    overdue.set_num_format('$#,##0')
    overdue.set_font_size(9)
    BlackBackWhiteText = workbook.add_format()
    BlackBackWhiteText.set_num_format('$#,##0')
    BlackBackWhiteText.set_bg_color('black')
    BlackBackWhiteText.set_font_color('white')
    BlackBackWhiteText.set_font_size(9)
    BlackBackWhiteText.set_bold()
    pct_format = workbook.add_format({'num_format': '0.0%'})
    pct_format.set_font_size(9)



    numdepth = len(excel_matrix)
    numcols = len(excel_matrix[0][0])
    numrows = len(excel_matrix[0])

    #print numdepth
    #print numcols
    #print numrows  

    #writes excel matrix to excel file
    zcount = 0
    xcount = 0
    while xcount < numcols:
        ycount = 0
        while ycount < numrows:
            x = excel_matrix[zcount][ycount][xcount]
            comment = str(excel_matrix[1][ycount][xcount])
            payment_status = excel_matrix[2][ycount][xcount]
            if type(x) == datetime:
                value = 'WC ' + x.strftime("%d/%m %Y")
                payment_status = 'BlackBackWhiteText'
            else:
                value = x
            if value == 0:
                pass
            else:
                if payment_status == 'Paid':
                    cell_format = paid_format
                elif payment_status == 'Awaiting Payment':
                    cell_format = awaiting_payment
                elif payment_status == 'Overdue':
                    cell_format = overdue
                elif payment_status == 'BlackBackWhiteText':
                    cell_format = BlackBackWhiteText
                else:
                    cell_format = money_format
                worksheet.write(ycount+excel_offset_row,xcount+excel_offset_col,value,cell_format)
                cell = get_cell_ref2(xcount+excel_offset_col+1,ycount+excel_offset_row+1)
                #worksheet.write(ycount+excel_offset_row,xcount+excel_offset_col,value)
                if comment == '0':
                    pass
                else:
                    worksheet.write_comment(cell, comment, {'visible': False,'width': 300, 'height':300})

            ycount += 1
        xcount += 1

#this code creates summary formulas at both far right side columns and underneath all rows
    col_ref2 = 'F:K'
    #print col_ref2
    row = excel_offset_row
    #worksheet.write(row,numcols+excel_offset_col,'SUM OF MILESTONES')
    row = excel_offset_row+1
    for i in range(0,numrows-1):
        row += 1 
        formula = '=IF(SUM('+col_reference_row2(col_ref2,row,row)+')<>0,(SUM('+col_reference_row2(col_ref2,row,row)+')),"")'
        worksheet.write_formula(row-1,11,formula,money_format)
        formula = '=IFERROR(E'+str(row)+'-L'+str(row) + ',"")'
        worksheet.write_formula(row-1,12,formula,money_format)
        formula = '=IFERROR(IF(F'+str(row)+'/E'+str(row)+'<>0,F'+str(row)+'/E'+str(row)+',""),"")'
        worksheet.write_formula(row-1,13,formula,pct_format)
        formula = '=IFERROR(IF(G'+str(row)+'/E'+str(row)+'<>0,G'+str(row)+'/E'+str(row)+',""),"")'
        worksheet.write_formula(row-1,14,formula,pct_format)
        formula = '=IFERROR(IF(H'+str(row)+'/E'+str(row)+'<>0,H'+str(row)+'/E'+str(row)+',""),"")'
        worksheet.write_formula(row-1,15,formula,pct_format)
        formula = '=IFERROR(IF(I'+str(row)+'/E'+str(row)+'<>0,I'+str(row)+'/E'+str(row)+',""),"")'
        worksheet.write_formula(row-1,16,formula,pct_format)
        formula = '=IFERROR(IF(J'+str(row)+'/E'+str(row)+'<>0,J'+str(row)+'/E'+str(row)+',""),"")'
        worksheet.write_formula(row-1,17,formula,pct_format)
        formula = '=IFERROR(IF(K'+str(row)+'/E'+str(row)+'<>0,K'+str(row)+'/E'+str(row)+',""),"")'
        worksheet.write_formula(row-1,18,formula,pct_format)
        formula = '=IF(SUM(N'+str(row)+':S'+str(row)+')<>0,SUM(N'+str(row)+':S'+str(row)+'),"")'
        worksheet.write_formula(row-1,19,formula,pct_format)


    col = excel_offset_col+1
    for i in range(0,numcols-6):
        col_ref2 = col_reference(col,col)
        col += 1
        formula = '=SUBTOTAL(9,'+col_reference_row2(col_ref2,excel_offset_row,excel_offset_row+numrows)+')'
        worksheet.write_formula(excel_offset_row+numrows,col-2,formula,BlackBackWhiteText)

"""
#function collapses the columns for dates earlier that one month ago. 
    collapse_column(excel_offset_col+4,today_col-8,worksheet)
    oppID_col = colnum_string(excel_offset_col+1)+':'+colnum_string(excel_offset_col+1)
    worksheet.set_column(oppID_col, 40)

    collapse_column(excel_offset_col+4,today_col-8,worksheet)
    collapse_column(today_col+12,numcols+excel_offset_col-4,worksheet)
    col_ref = col_reference(today_col-8,numcols+10)
    worksheet.set_column(col_ref, 14.28)

    insPymtLeged(workbook,worksheet,today_col) #//COME BACK TO THIS COMMENT!
"""
#    col = excel_matrix[0].index(i)
#    row = excel_matrix.index(i)
#    x = str(i)
#    worksheet.write(row,col,dollar_val,money_format)
#print excel_matrix
