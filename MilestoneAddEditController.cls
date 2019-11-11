public class MilestoneAddEditController{

    public List<MilestoneWrapper> mileStones {set;get;}
    public string contractId {set;get;}
    public string projectId {set;get;}
    public string title {set;get;}
    public string recordTypeId {set;get;}
    public Integer rowToUpd{set;get;}
    public Boolean isPaymentMilestone{set;get;}
    public Boolean isEditMode{set;get;}
    public Decimal projValue{set;get;}
    
    public MilestoneAddEditController (){
       
        init();
    }
    
    public void init(){
        mileStones = new List<MilestoneWrapper>();
       
    }    
    
    
    
    public void addMoreMS(){
        
        mileStones.add( new MilestoneWrapper(contractId,projectId,recordTypeId,mileStones.size()+1));
    }

    public void editAll(){
        
        isEditMode = true;
    }
    

    
    public void deleteMS(){
    
        try{
        
            List<Milestone__c> mStones = new List<Milestone__c>();
            Integer counter = 0;
            List<Integer> indexToRemove = new List<Integer>();
            for(MilestoneWrapper mStone: mileStones){
            
                System.debug('*****IS CHECKED'+mStone.isChecked);
                System.debug('*****ID'+mStone.mileStone.Id);

                if(mStone.isChecked && mStone.mileStone.Id!=null){
                 
                    mStones.add(mStone.mileStone);
                }
                if(mStone.isChecked){
                    
                    indexToRemove.add(counter);
                }
                
                counter++;
            }
            boolean isdeleted = false;
            if(mStones.size() > 0 ){
                delete mStones;
                isDeleted = true;
                
                
            }
            if(indexToRemove.size() > 0){
                isDeleted = true;
                for(Integer index = indexToRemove.size()-1 ; index >= 0; index --){
                    mileStones.remove(indexToRemove.get(index));
                }
            }
            
            if(isDeleted){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.Milestone_Error_Message));
            }
        }catch(DMLException ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getDMLMessage(0)));
        }/*catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));

        }*/
    }
    
    public void doCalculations(){
        
        mileStones[rowToUpd].milestone.Name =  mileStones[rowToUpd].milestone.Milestone_Type__c;
    }

   
    

}