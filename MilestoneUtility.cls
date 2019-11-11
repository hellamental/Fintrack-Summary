public class MilestoneUtility{
    
    static Map<string, List<Sales_Milestones_Auto_Creation__mdt>> salesMilestonesbyOpportunityAllocation {set;get;}
     
    public static Map<string, List<Sales_Milestones_Auto_Creation__mdt>> getMileStonesAutoCreationbyOppAllocation(){
        
        if(salesMilestonesbyOpportunityAllocation !=null && salesMilestonesbyOpportunityAllocation.size() > 0){
            
            return salesMilestonesbyOpportunityAllocation;
        }else{
        
            List<Sales_Milestones_Auto_Creation__mdt> salesMilestones = MetadataDAO.getAllSalesMilestonesAutoCreation();
            salesMilestonesbyOpportunityAllocation = new Map <string, List<Sales_Milestones_Auto_Creation__mdt>>();
            List<Milestone__c> createMilestones = new List<Milestone__c>();
            Map<string, id> salesMilestoneRecordType = new Map<string,id>();
            
            Map<String,Schema.RecordTypeInfo> rtMapByName2 = RecordTypeDAO.getRecordTypes(Schema.SObjectType.Milestone__c);
            id invoiceRecordTypeId = rtMapByName2.get(Constant.MILESTONE_INVOICE_RECORDTYPE).getRecordTypeId();
            id poRecordTypeId = rtMapByName2.get(Constant.MILESTONE_PO_RECORDTYPE).getRecordTypeId();
              
            salesMilestoneRecordType.put(Constant.SALESMILESTONE_INVOICE_MILESTONE,invoiceRecordTypeId);
            salesMilestoneRecordType.put(Constant.SALESMILESTONE_VENDOR_PAYMENT_MILESTONE,poRecordTypeId);
            
            
            for(Sales_Milestones_Auto_Creation__mdt salesMilestone :salesMilestones){
                List <Sales_Milestones_Auto_Creation__mdt> milestoneAutocreation = new List <Sales_Milestones_Auto_Creation__mdt>();
                
                if(salesMilestonesbyOpportunityAllocation.get(salesMilestone.Opportunity_Allocation__c)==NULL){
                    milestoneAutocreation = new List <Sales_Milestones_Auto_Creation__mdt>();
                }
                else{
                    milestoneAutocreation = salesMilestonesbyOpportunityAllocation.get(salesMilestone.Opportunity_Allocation__c);
                }
                milestoneAutocreation.add(salesMilestone);
                salesMilestonesbyOpportunityAllocation.put(salesMilestone.Opportunity_Allocation__c, milestoneAutocreation );
                
            }
            
            return salesMilestonesbyOpportunityAllocation;
        }
     }


     public static void createMilestones(Contract contractRec){
        Map<String,Schema.RecordTypeInfo> rtMapByName2 = RecordTypeDAO.getRecordTypes(Schema.SObjectType.Milestone__c);

        id invoiceRecordTypeId = rtMapByName2.get(Constant.MILESTONE_INVOICE_RECORDTYPE).getRecordTypeId();
        id poRecordTypeId = rtMapByName2.get(Constant.MILESTONE_PO_RECORDTYPE).getRecordTypeId();
       

        Set<id> contractIds= new Set<id>();
        contractIds.add(contractRec.Id);
        List<Opportunity> opportunities =  OpportunityDAO.getProjectsFromContract(contractIds);

        //List<Milestone__c> deleteMilestones = MilestoneDAO.getMileStonesForProject(opptyIDs);
        List<Milestone__c> createMilestones = new List<Milestone__c>();
        Map<string, id> salesMilestoneRecordType = new Map<string,id>();
        
        salesMilestoneRecordType.put(Constant.SALESMILESTONE_INVOICE_MILESTONE,invoiceRecordTypeId);
        salesMilestoneRecordType.put(Constant.SALESMILESTONE_VENDOR_PAYMENT_MILESTONE,poRecordTypeId);
        
        Map<string, List<Sales_Milestones_Auto_Creation__mdt>> salesMilestonesbyOpportunityAllocation = MilestoneUtility.getMileStonesAutoCreationbyOppAllocation();
        
        for(Opportunity oppty :opportunities){
            for(Milestone__c contractMilestone :contractRec.Milestones__r){

                Decimal amnt= 0.0;
                if(contractMilestone.RecordTypeID == poRecordTypeId){
                    amnt = oppty.Project_Value_for_PO_Milestone__c;
                }else{
                     amnt = oppty.Project_Value_for_Invoice_Milestone__c;
                }
                createMilestones.add(new Milestone__c(Name= contractMilestone.Name, 
                                                      Percentage__c = contractMilestone.Percentage__c, 
                                                      Status__c = contractMilestone.Status__c, 
                                                      RecordTypeID = contractMilestone.RecordTypeID, 
                                                      Services__c = contractMilestone.Services__c,
                                                      Opportunity__c = oppty.id,
                                                      Contract__c = contractMilestone.Contract__c,
                                                      Milestone_Value__c  = amnt * (contractMilestone.Percentage__c/100),
                                                      Due_Date__c = contractMilestone.Due_Date__c,
                                                      Milestone_Type__c = contractMilestone.Milestone_Type__c,
                                                      Invoice__c = contractMilestone.Invoice__c));
                                                           
            }
        }
        
        if(createMilestones.size()>0){
            insert createMilestones;
        }
    
     }
}