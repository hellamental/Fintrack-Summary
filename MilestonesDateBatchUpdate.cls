global class VendorMSDateBringForward2 implements Database.Batchable<sObject>, Database.Stateful{

    List<Milestone__c> listRecords = new List<Milestone__c>();

    global Database.QueryLocator start(Database.BatchableContext bc){
            String query = 'Select Id, Status__c, Vendor_Invoice_Date__c From Milestone__c';
            return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Milestone__c> scope){
    
        for(Milestone__c obj : (Milestone__c[]) scope){
            if(obj.Status__c == 'Milestone Complete - Invoice Pending' && obj.Vendor_Invoice_Date__c != date.today()){
                obj.Vendor_Invoice_Date__c = date.today();
                listRecords.add(obj);
            }
        }
    }

    global void finish(Database.BatchableContext bc){
        system.debug('list to be deleted size :: '+listRecords.size());
        if(!listRecords.isEmpty()){
            update listRecords;
        }
    }
}

//SCHEDUABLE COMPONENT
global class VendorMSDateBringForward2schedulable implements Schedulable{
    global void execute(SchedulableContext sc){
        VendorMSDateBringForward2 milestoneBatch = new VendorMSDateBringForward2();
        database.executebatch(milestoneBatch);
    }
}