global class XeroPurchaseBillStatusBatchable implements Database.Batchable<sObject>,  Database.AllowsCallouts, Database.Stateful {
    
    String query;
    global Map<String,XeroInvoice> xeroByReference;
    Map<String, String> xeroSetting;
    global Integer successfullRecords;
    global Integer errorRecords;
    global String message;

    global XeroPurchaseBillStatusBatchable() {
        this.successfullRecords = 0;
        this.errorRecords = 0;
        query = 'Select Xero_Id__c, Amount_Paid__c, Xero_Reference__c,Bill_Due_Date__c, Remaining_Amount__c, id,Name,Contract__c,Due_Date__c, Milestone_Type__c,Milestone_Value__c,Opportunity__c,Percentage__c,Status__c,Parent_Opportunity_Record_Type__c,RecordTypeId,Purchase_Order__c,Vendor_Invoice_Reference__c,Awaiting_Payment_Selected_Date__c,Milestone_Paid_Date__c,PlannedPaymentDate__c From   Milestone__c Where Get_Status_from_Xero__c = true';
        message = '';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
    
        xeroSetting = XeroCalloutUtility.getXeroSettings();
        List<XeroInvoice>  xeroInvoices;
        if(Test.isRunningTest() == false){
            //xeroInvoices = XeroAccountingApi.getInvoicesModifiedAfter(System.today().addDays(-Integer.valueOf(xeroSetting.get('Number_of_Purchase_Bills'))));
            xeroInvoices = XeroAccountingApi.getInvoicesModifiedAfter(System.today().addDays(-1));
        }else{
            xeroInvoices = TestDataUtility.getXeroPOs();
        }
        xeroByReference = new Map<String,XeroInvoice>();
        if(!xeroInvoices.isEmpty()){
            for(XeroInvoice xero : xeroInvoices){
                System.debug('****Reference from Xero'+xero.InvoiceNumber);
                if(xero.InvoiceNumber != null && xero.Type == Constant.BILL_TYPE )
                xeroByReference.put(xero.InvoiceNumber, xero);
            }   
        }
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Milestone__c > scope) {
        List<Milestone__c> milestonesToUpd = new List<Milestone__c>();
        for(Milestone__c xero : scope){
              System.debug('****INVOICE EXECUTE'+xero );
                
            if(xeroByReference.containsKey(xero.Xero_Reference__c)){
                XeroInvoice xerInv = xeroByReference.get(xero.Xero_Reference__c);
                System.debug('****Xero Invoices *****'+xerInv.Status );
                
                //xero.Status__c = xerInv.Status;
                switch on xerInv.Status {
                    when 'Draft' {
                        xerInv.Status = 'Ready for Payment';
                    }
                    when 'SUBMITTED' {
                        xerInv.Status = 'Ready for Payment';
                    }
                    when 'AUTHORISED' {
                        if(xerInv.AmountDue != 0 && xerInv.AmountPaid != 0){
                        xero.Status__c = Constant.XERO_INVOICE_STATUS_PARTIALLY_PAID;}
                        else{
                        xerInv.Status = 'Awaiting Payment';}
                        xero.Awaiting_Payment_Selected_Date__c = date.today();
                    }
                    when 'PAID' {
                        xerInv.Status = 'Paid';
                    }
                    when else {
                        
                    }
                }
                
                if(xero.Status__c != xerInv.Status || xero.Amount_Paid__c != xerInv.AmountPaid || xero.Remaining_Amount__c != xerInv.AmountDue || xero.Bill_Due_Date__c != getDateFromDateString(xerInv.DueDateString) || xero.PlannedPaymentDate__c =! getDatefromNETJSON(xerInv.PlannedPaymentDate)){
                    xero.Amount_Paid__c = xerInv.AmountPaid;  
                    xero.Remaining_Amount__c = xerInv.AmountDue; 
                    xero.Bill_Due_Date__c = xerInv.DueDateString != null && xerInv.DueDateString != '' ? getDateFromDateString(xerInv.DueDateString) : null;
                    xero.PlannedPaymentDate__c = xerInv.PlannedPaymentDate != null && xerInv.PlannedPaymentDate != '' ? getDatefromNETJSON(xerInv.PlannedPaymentDate) : null;
                    milestonesToUpd.add(xero);
                }

                
                
                
                
                
                /*

                if(xerInv.Status == Constant.XERO_INVOICE_VOIDED && xero.Status__c !=Constant.XERO_INVOICE_CANCELLED){
                    xero.Status__c =  Constant.XERO_INVOICE_CANCELLED;
                    //milestonesToUpd.add(xero); 
                }
                else if(xerInv.AmountPaid != xero.Amount_Paid__c){
                    if(xerInv.AmountDue != 0 && xerInv.AmountPaid != 0){
                        xero.Status__c = Constant.XERO_INVOICE_STATUS_PARTIALLY_PAID;
                    }else if(xerInv.AmountDue == 0){
                        xero.Status__c = Constant.XERO_INVOICE_STATUS_PAID;
                        xero.Milestone_Paid_Date__c = date.today();
                    
                    }else{
                         xero.Status__c = Constant.MILESTONE_STATUS_AWAITING_PAYMENT;
                         xero.Awaiting_Payment_Selected_Date__c = date.today();
                    }
                    xero.Amount_Paid__c = xerInv.AmountPaid;
                    xero.Remaining_Amount__c = xerInv.AmountDue;
                    //xero.Bill_Due_Date__c = xerInv.DueDateString != null && xerInv.DueDateString != '' ? getDateFromDateString(xerInv.DueDateString) : null;
                    //xero.PlannedPaymentDate__c = xerInv.PlannedPaymentDate != null && xerInv.PlannedPaymentDate != '' ? getDatefromNETJSON(xerInv.PlannedPaymentDate) : null;
                    xero.Xero_Id__c = xerInv.InvoiceId != null ? xerInv.InvoiceId : '';
                    //milestonesToUpd.add(xero); 
                }

                xero.Bill_Due_Date__c = xerInv.DueDateString != null && xerInv.DueDateString != '' ? getDateFromDateString(xerInv.DueDateString) : null;
                xero.PlannedPaymentDate__c = xerInv.PlannedPaymentDate != null && xerInv.PlannedPaymentDate != '' ? getDatefromNETJSON(xerInv.PlannedPaymentDate) : null;
                milestonesToUpd.add(xero);*/ 
            }
        }
        if(!milestonesToUpd.isEmpty()){
            try{
                update milestonesToUpd;
                successfullRecords += milestonesToUpd.size();
            }catch(Exception ex){
                errorRecords += milestonesToUpd.size();
                message += ex.getMessage();
            }
            
        }
    }

    public Date getDateFromDateString(String dueDate){
        String[] myDateOnly = dueDate.split('-');
        Integer year = Integer.valueOf(myDateOnly[0]);
        Integer month = Integer.valueOf(myDateOnly[1]);
        myDateOnly = myDateOnly[2].split('T');
        Integer dateI = Integer.valueOf(myDateOnly[0]);
        return Date.newInstance(year, month, dateI);}
        
    public Date getDatefromNETJSON(String JSONDate){
        String myJSONstring = JSONDate.remove('/Date(');
        myJSONstring = myJSONstring.remove('000+0000)/');
        system.debug(myJSONstring);
        Integer DateSeconds = Integer.valueOf(myJSONstring);
        system.debug(DateSeconds);
        Datetime dT = Datetime.newInstanceGMT(1970,1,1,0,0,0).addSeconds(DateSeconds);
        return Date.newInstance(dT.year(), dT.month(), dT.day());
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
