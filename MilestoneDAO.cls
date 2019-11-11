public class MilestoneDAO{
    
    public static List<Milestone__c> getMileStonesForContractAndOpportunity(Set<Id> contractIds) {
        List<Milestone__c> mileStones =  [Select Id,
                                                   Name,
                                                   Contract__c,
                                                   Due_Date__c,
                                                   Milestone_Type__c,
                                                   Milestone_Value__c,
                                                   Opportunity__c,
                                                   Percentage__c,
                                                   Status__c,
                                                   Parent_Opportunity_Record_Type__c,
                                                   RecordTypeId,
                                                   Purchase_Order__c,
                                                   Vendor_Invoice_Reference__c,
                                                   Status_Image__c,
                                                   Services__c,
                                                   Invoice__c
                                            From   Milestone__c
                                            Where  Contract__c In :contractIds
                                            Order by Due_Date__c ASC];
       if( mileStones== null|| mileStones.isEmpty()){
           mileStones = new List<Milestone__c>();
       }
       
       return mileStones;
    }
    
    public static List<Milestone__c> getMileStonesForContract(Set<Id> contractIds) {
        List<Milestone__c> mileStones =  [Select Id,
                                                   Name,
                                                   Contract__c,
                                                   Due_Date__c,
                                                   Milestone_Type__c,
                                                   Milestone_Value__c,
                                                   Opportunity__c,
                                                   Percentage__c,
                                                   Status__c,
                                                   RecordTypeId,
                                                   Purchase_Order__c,
                                                   Vendor_Invoice_Reference__c,
                                                   Status_Image__c,
                                                   Services__c,
                                                   Read_Only__c,
                                                   Invoice__c
                                            From   Milestone__c
                                            Where  Contract__c In :contractIds
                                            AND Opportunity__c = null 
                                            Order by Due_Date__c ASC];
       if( mileStones== null|| mileStones.isEmpty()){
           mileStones = new List<Milestone__c>();
       }
       
       return mileStones;
    }
    
    
     public static List<Milestone__c> getMileStonesForProject(Set<Id> projectIds) {
        List<Milestone__c> mileStones =  [Select Id,
                                                   Name,
                                                   Contract__c,
                                                   Due_Date__c,
                                                   Milestone_Type__c,
                                                   Milestone_Value__c,
                                                   Opportunity__c,
                                                   Percentage__c,
                                                   Status__c,
                                                   RecordTypeId,
                                                   Purchase_Order__c,
                                                   Vendor_Invoice_Reference__c,
                                                   Status_Image__c,
                                                   Services__c,
                                                   Read_Only__c,
                                                   Invoice__c
                                            From   Milestone__c
                                            Where  Opportunity__c In :projectIds
                                            Order by Due_Date__c ASC];
       if( mileStones== null|| mileStones.isEmpty()){
           mileStones = new List<Milestone__c>();
       }
       
       return mileStones;
    }


        public static List<Milestone__c> getMilestones(Set<Id> milestoneIDs) {
        List<Milestone__c> mileStones =  [Select Id,
                                                   Name,
                                                   Contract__c,
                                                   Due_Date__c,
                                                   Milestone_Type__c,
                                                   Milestone_Value__c,
                                                   Opportunity__c,
                                                   Percentage__c,
                                                   Status__c,
                                                   Parent_Opportunity_Record_Type__c,
                                                   RecordTypeId,
                                                   Purchase_Order__c,
                                                   Vendor_Invoice_Reference__c,
                                                   Status_Image__c,
                                                   Services__c
                                            From   Milestone__c
                                            Where  id In :milestoneIDs
                                            Order by Due_Date__c ASC];
       if( mileStones== null|| mileStones.isEmpty()){
           mileStones = new List<Milestone__c>();
       }
       
       return mileStones;
    }
     public static List<Milestone__c> getMileStonesForProjectwithoutVariance(Set<Id> projectIds) {
        Map<String,Schema.RecordTypeInfo> rtMapByName2 = RecordTypeDAO.getRecordTypes(Schema.SObjectType.Milestone__c);
        List<Milestone__c> mileStones =  [Select Id,
                                                   Name,
                                                   Contract__c,
                                                   Due_Date__c,
                                                   Milestone_Type__c,
                                                   Milestone_Value__c,
                                                   Opportunity__c,
                                                   Percentage__c,
                                                   Status__c,
                                                   RecordTypeId,
                                                   Post_RFQ_Value__c,
                                                   Post_RFQ_Vendor_Cost__c,
                                                   Services__c
                                            From   Milestone__c
                                            Where  Milestone_Type__c != :Constant.MILESTONE_TYPE_VARIANCE 
                                            And    Opportunity__c In :projectIds
                                            Order by Due_Date__c DESC];
       if( mileStones== null|| mileStones.isEmpty()){
           mileStones = new List<Milestone__c>();
       }
       
       return mileStones;
    }

    public static List<Milestone__c> getMileStonesForProjectwithVariance(Set<Id> projectIds) {
        Map<String,Schema.RecordTypeInfo> rtMapByName2 = RecordTypeDAO.getRecordTypes(Schema.SObjectType.Milestone__c);
        List<Milestone__c> mileStones =  [Select Id,
                                                   Name,
                                                   Contract__c,
                                                   Due_Date__c,
                                                   Milestone_Type__c,
                                                   Milestone_Value__c,
                                                   Opportunity__c,
                                                   Percentage__c,
                                                   Status__c,
                                                   RecordTypeId,
                                                   Post_RFQ_Value__c,
                                                   Post_RFQ_Vendor_Cost__c,
                                                   Services__c,
                                                   Read_Only__c
                                            From   Milestone__c
                                            Where  Opportunity__c In :projectIds
                                            Order by Due_Date__c ASC];
       if( mileStones== null|| mileStones.isEmpty()){
           mileStones = new List<Milestone__c>();
       }
       
       return mileStones;
    }


     public static List<Milestone__c> getMileStonesForSolarLightProject(Set<Id> contractIds) {
       Map<String,Schema.RecordTypeInfo> rtMapByName  = RecordTypeDAO.getRecordTypes(Schema.SObjectType.Opportunity);

        List<Milestone__c> mileStones =  [Select Id,
                                                   Name,
                                                   Contract__c,
                                                   Due_Date__c,
                                                   Milestone_Type__c,
                                                   Milestone_Value__c,
                                                   Opportunity__c,
                                                   Percentage__c,
                                                   Status__c,
                                                   RecordTypeId,
                                                   Purchase_Order__c,
                                                   Vendor_Invoice_Reference__c,
                                                   Status_Image__c,
                                                   Services__c,
                                                   Read_Only__c
                                            From   Milestone__c
                                            Where  Contract__c In :contractIds
                                            AND    Opportunity__c !=null
                                            AND    (Opportunity__r.Recordtypeid =:rtMapByName.get(Constant.OPPORTUNITY_SOLAR_PROJECT_RECORDTYPE).getRecordTypeId() OR Opportunity__r.Recordtypeid =:rtMapByName.get(Constant.OPPORTUNITY_LIGHTING_PROJECT_RECORDTYPE).getRecordTypeId())
                                            Order by Due_Date__c ASC];
       if( mileStones== null|| mileStones.isEmpty()){
           mileStones = new List<Milestone__c>();
       }
       
       return mileStones;
    }



      public static List<Milestone__c> getDistributedMileStonesForProjects(Set<String> contractAndMileStoneType) {
       Map<String,Schema.RecordTypeInfo> rtMapByName  = RecordTypeDAO.getRecordTypes(Schema.SObjectType.Opportunity);

        List<Milestone__c> mileStones =  [Select Id,
                                                   Name,
                                                   Contract__c,
                                                   Due_Date__c,
                                                   Milestone_Type__c,
                                                   Milestone_Value__c,
                                                   Opportunity__c,
                                                   Percentage__c,
                                                   Status__c,
                                                   RecordTypeId,
                                                   Purchase_Order__c,
                                                   Vendor_Invoice_Reference__c,
                                                   Status_Image__c,
                                                   Services__c,
                                                   Read_Only__c,
                                                   Contract_Id_Milestone_Type__c,
                                                   Invoice__c
                                            From   Milestone__c
                                            Where  Contract_Id_Milestone_Type__c In :contractAndMileStoneType
                                            AND Opportunity__c != null 
                                            AND  (Opportunity__r.Recordtypeid =:rtMapByName.get(Constant.OPPORTUNITY_SOLAR_PROJECT_RECORDTYPE).getRecordTypeId() OR Opportunity__r.Recordtypeid =:rtMapByName.get(Constant.OPPORTUNITY_LIGHTING_PROJECT_RECORDTYPE).getRecordTypeId())
                                            Order by Due_Date__c ASC];
       if( mileStones== null|| mileStones.isEmpty()){
           mileStones = new List<Milestone__c>();
       }
       
       return mileStones;
    }
}