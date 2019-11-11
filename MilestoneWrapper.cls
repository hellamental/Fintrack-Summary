public class MilestoneWrapper{
    
    public boolean isChecked{set;get;}
    public Milestone__c mileStone{set;get;}
    
    public Integer index{set;get;}
    
    public MilestoneWrapper(string contractId, string projectId, string rcrdTypeId, Integer indx){
        
        mileStone = new Milestone__c(Contract__c= contractId, Opportunity__c = projectId, recordTypeId= rcrdTypeId);
        
        mileStone = (Milestone__c)Milestone__c.sObjectType.newSObject(rcrdTypeId, true);
        mileStone.Contract__c= contractId;
        mileStone.Opportunity__c= projectId;
        index = indx;
        isChecked = false;
    }
    
    public MilestoneWrapper(Milestone__c mStone, Integer indx ){
        
        mileStone = mStone;
        index = indx;
        isChecked= false;
    }
    
    
}