global class XeroInvoiceStatusBatchable implements Database.Batchable<sObject>,  Database.AllowsCallouts, Database.Stateful {
    
    String query;
    global Map<String,XeroInvoice> xeroByInvoiceNumber;
    Map<String, String> xeroSetting;
    global Integer successfullRecords;
    global Integer errorRecords;
    global String message;

    global XeroInvoiceStatusBatchable() {
        this.successfullRecords = 0;
        this.errorRecords = 0;
        query = 'Select Id, Name, VD_Invoice_Stage__c, Amount_Paid__c, Xero_Invoice_Number__c From VD_Invoice__c Where Get_Status_from_Xero__c = true';
        message = '';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
    
        xeroSetting = XeroCalloutUtility.getXeroSettings();
        List<XeroInvoice>  xeroInvoices ;
        if(Test.isRunningTest() == false){
           xeroInvoices = XeroAccountingApi.getInvoicesModifiedAfter(System.today().addDays(-Integer.valueOf(xeroSetting.get('Number_of_Invoice_Days'))));
        }
        else{
            xeroInvoices = TestDataUtility.getXeroInvoices();
        }
        xeroByInvoiceNumber = new Map<String,XeroInvoice>();
        if(!xeroInvoices.isEmpty()){
            for(XeroInvoice xero : xeroInvoices){
                xeroByInvoiceNumber.put(xero.InvoiceNumber, xero);
            }   
        }
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<VD_Invoice__c > scope) {
        List<VD_Invoice__c> paidInvoices = new List<VD_Invoice__c>();
        for(VD_Invoice__c xero : scope){
              System.debug('****INVOICE EXECUTE'+xero );
                
            if(xeroByInvoiceNumber.containsKey(xero.Xero_Invoice_Number__c)){
                XeroInvoice xerInv = xeroByInvoiceNumber.get(xero.Xero_Invoice_Number__c);
                System.debug('****Xero Invoices *****'+xerInv.Status );
                if(xerInv.Status == Constant.XERO_INVOICE_VOIDED && xero.VD_Invoice_Stage__c !=Constant.XERO_INVOICE_CANCELLED){
                    xero.VD_Invoice_Stage__c =  Constant.XERO_INVOICE_CANCELLED;
                    paidInvoices.add(xero); 
                }
                else if(xerInv.AmountPaid != xero.Amount_Paid__c){
                    if(xerInv.AmountDue != 0 && xerInv.AmountPaid != 0){
                        xero.VD_Invoice_Stage__c = Constant.XERO_INVOICE_STATUS_PARTIALLY_PAID;
                    }else if(xerInv.AmountDue == 0){
                        xero.VD_Invoice_Stage__c = Constant.XERO_INVOICE_STATUS_PAID;
                    }
                    xero.Amount_Paid__c = xerInv.AmountPaid;
                    xero.Remaining_Amount__c = xerInv.AmountDue;
                    xero.VD_Due_Date__c = xerInv.DueDateString != null && xerInv.DueDateString != '' ? getDateFromDateString(xerInv.DueDateString) : null;
                    paidInvoices.add(xero); 
                }

                
            }
        }
        if(!paidInvoices.isEmpty()){
            try{
                update paidInvoices;
                successfullRecords += paidInvoices.size();
            }catch(Exception ex){
                errorRecords += paidInvoices.size();
                message += ex.getMessage();
            }
            
        }
    }

   public  Date getDateFromDateString(String dueDate){
        String[] myDateOnly = dueDate.split('-');
        Integer year = Integer.valueOf(myDateOnly[0]);
        Integer month = Integer.valueOf(myDateOnly[1]);
        myDateOnly = myDateOnly[2].split('T');
        Integer dateI = Integer.valueOf(myDateOnly[0]);
        return Date.newInstance(year, month, dateI);
    }
    
    global void finish(Database.BatchableContext BC) {
        Integer totalNumberOfRecords = successfullRecords+errorRecords;
        Messaging.reserveSingleEmailCapacity(1);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        string emailId  = xeroSetting.get('Xero_Email');
        String[] toAddresses = new String[] {emailId};
        mail.setToAddresses(toAddresses);
        string subject  = ErrorRecords > 0 ? Label.UPDATE_XERO_INVOICE_STATUS_FAILED: Label.UPDATE_XERO_INVOICE_STATUS_SUCCESSFUL;
        mail.setSubject(subject);

        // Specify the text content of the email.
        string body = Label.TOTAL_NUMBER_OF_RECORDS + totalNumberOfRecords + '\n';
        body += Label.SUCCESSFUL_NUMBER_OF_RECORDS + successfullRecords+'\n';
        body += Label.FAILED_NUMBER_OF_RECORDS + ErrorRecords;
        body+= message;
        mail.setPlainTextBody(body);

        // Send the email you have created.
        if(ErrorRecords > 0 )
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
}