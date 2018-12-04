import xlsxwriter
from datetime import date
from datetime import datetime
from datetime import timedelta
from datetime_convert import *


def write_to_excel(array,row,col):
    
#    row = 0
#    col = 0

    for item in (array):
        worksheet.write(row, col, item)
        col += 1

    workbook.close()

def excel_column_Ref(number_of_columns): #returns the lettered column reference of input number of columns

    ascii_uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    alphabet_list = []


    char = ascii_uppercase[number_of_columns]
    #print len(ascii_uppercase)
    #print char


#returns column name from number input
def colnum_string(n):
    string = ""
    while n > 0:
        n, remainder = divmod(n - 1, 26)
        string = chr(65 + remainder) + string
    return string

#print colnum_string(353)
#output:AB

def collapse_column(start_col, finish_col, worksheet):
    colstart_letter = colnum_string(start_col)
    colfin_letter = colnum_string(finish_col)
    range2 = colnum_string(finish_col+1)+ ':' +colnum_string(finish_col+1)
    range1 = colstart_letter + ':' + colfin_letter
    #print range1
    #print range2
    worksheet.set_column(range1, None, None, {'level': 1, 'hidden': True})
    worksheet.set_column(range2, None, None, {'collapsed': True})

#collapse_column(5,10)

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



def insPymtLeged(workbook,worksheet,today_col):
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
    ReadyForPayment = workbook.add_format()
    ReadyForPayment.set_bg_color('#0080FF')
    ReadyForPayment.set_font_size(9)
    
    bold = workbook.add_format()
    bold.set_bold()
    incoming = ['Incoming','Planned','Ready to Invoice','Awaiting Payment','Paid','Overdue']
    inc_legend_format = [bold,money_format,ReadyForPayment,awaiting_payment,paid_format,overdue]
    outgoing = ['Outgoing','Planned','Ready for Payment','Awaiting Payment','Paid','Overdue']
    outg_leg_format = [bold,money_format,ReadyForPayment,awaiting_payment,paid_format,overdue]
    row = 1
    for i in incoming:
        inc_format = inc_legend_format[incoming.index(i)]
        worksheet.write(row,today_col,i,inc_format)
        row += 1
    row = 1
    for i in outgoing:
        outg_format = outg_leg_format[outgoing.index(i)]    
        worksheet.write(row,today_col+2,i,outg_format)
        row += 1

def get_cell_ref(column_no,row_no):
    col_letter = colnum_string(column_no)
    cell_ref = col_letter + str(row_no)
    #print cell_ref
    return cell_ref

#this code creates summary formulas at both far right side columns and underneath all rows
def summary_colum(start_col,finish_col,start_row,numrows,worksheet):    
    col_ref2 = col_reference(start_col,finish_col)
    #print col_ref2
    row = start_row
    for i in range(0,numrows):
        row += 1 
        formula = '=SUM('+col_reference_row2(col_ref2,row,row)+')'
        worksheet.write_formula(row-1,numcols+excel_offset_col+1,formula,money_format)

#def write_comment(cell_ref,value):

'''def Matrix3D(width, height ,depth):
    w, h, d = width, height, depth;
    excel_matrix = [[[1, 2, 3], [4, 5, 6], [7, 8, 9]], [[10, 11, 12], [13, 14, 15], [16, 17, 18]], [[19, 20, 21], [22, 23, 24], [25, 26, 27]]]

    print excel_matrix[0]
    print excel_matrix[0][0]
    print excel_matrix[0][0][0]

    for i in excel_matrix[1][0]:
    print i
    '''

def write_to_excel(excel_matrix,excel_offset_col,excel_offset_row,worksheet,workbook):
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
                cell = get_cell_ref(xcount+excel_offset_col+1,ycount+excel_offset_row+1)
                #worksheet.write(ycount+excel_offset_row,xcount+excel_offset_col,value)
                if comment == '0':
                    pass
                else:
                    worksheet.write_comment(cell, comment, {'visible': False,'width': 300, 'height':300})

            ycount += 1
        xcount += 1


#what is the column with todays date // want to return the column reference in order to collapse all columns up to that date - 1 month
    today = datetime.today()
    for j in excel_matrix[0][0]:
        if type(j)!=int and today >= j and today < j + timedelta(days=7):
            #print excel_matrix.index(j)
            #print type(oppID)
            today_col = excel_matrix[0][0].index(j) + excel_offset_col
            #print today_col
        else:
            pass    

#this code creates summary formulas at both far right side columns and underneath all rows
    col_ref2 = col_reference(excel_offset_col+2,numcols+excel_offset_col)
    #print col_ref2
    row = excel_offset_row
    for i in range(0,numrows):
        row += 1 
        formula = '=SUM('+col_reference_row2(col_ref2,row,row)+')'
        worksheet.write_formula(row-1,numcols+excel_offset_col+1,formula,money_format)
    col = excel_offset_col+1
    for i in range(0,numcols+2):
        col_ref2 = col_reference(col,col)
        col += 1
        formula = '=SUBTOTAL(9,'+col_reference_row2(col_ref2,excel_offset_row+2,excel_offset_row+numrows)+')'
        worksheet.write_formula(excel_offset_row+numrows,col-2,formula,BlackBackWhiteText)


#function collapses the columns for dates earlier that one month ago. 
    collapse_column(excel_offset_col+4,today_col-8,worksheet)
    oppID_col = colnum_string(excel_offset_col+1)+':'+colnum_string(excel_offset_col+1)
    worksheet.set_column(oppID_col, 40)

    collapse_column(excel_offset_col+4,today_col-8,worksheet)
    collapse_column(today_col+12,numcols+excel_offset_col,worksheet)
    col_ref = col_reference(today_col-8,numcols+10)
    worksheet.set_column(col_ref, 14.28)

    insPymtLeged(workbook,worksheet,today_col) #//COME BACK TO THIS COMMENT!

#    col = excel_matrix[0].index(i)
#    row = excel_matrix.index(i)
#    x = str(i)
#    worksheet.write(row,col,dollar_val,money_format)
#print excel_matrix

