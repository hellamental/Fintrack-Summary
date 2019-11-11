public class MilestoneCreateExt{

    public List<MilestoneWrapper> mileStonesInvoice {set;get;}
    public List<MilestoneWrapper> mileStonesPO {set;get;}
    public string contractId {set;get;}
    public string projectId {set;get;}
    
    public string invoiceRecordTypeId{set;get;}
    public string poRecordTypeId{set;get;}
    public boolean isEditMode{set;get;}
    
    Set<Id> recordIds = new Set<Id>();
    Boolean isContract;
    Boolean isProject;
    Integer index{set;get;}

    public Decimal projectValueforInvoice {set;get;}
    public Decimal projectValueforPO {set;get;}

    public string rcrdTypeOfProject{set;get;}

    
    public MilestoneCreateExt (ApexPages.StandardController stdController){
        SObject genericObject = stdController.getRecord();
        isContract = genericObject instanceof Contract;
        isProject = genericObject instanceof Opportunity;
        init();
        if(isContract){
            contractId = (string) genericObject.get('Id');
            recordIds.add(contractId);
        }
        else if(isProject){
             
             projectId = (string) genericObject.get('Id');
             contractId = (string) genericObject.get('Project_Contract__c');
             rcrdTypeOfProject = (string) genericObject.get('RecordTypeId');
             
             rcrdTypeOfProject = Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(rcrdTypeOfProject).getname();

             
             recordIds.add(projectId);
        }

        projectValueforInvoice = (Decimal) genericObject.get('Project_Value_for_Invoice_Milestone__c'); 
        projectValueforPO = (Decimal) genericObject.get('Project_Value_for_PO_Milestone__c'); 
        
        Map<String,Schema.RecordTypeInfo> rtMapByName  = RecordTypeDAO.getRecordTypes(Schema.SObjectType.Milestone__c);
        invoiceRecordTypeId = rtMapByName.get(Constant.MILESTONE_INVOICE_RECORDTYPE).getRecordTypeId();
        poRecordTypeId = rtMapByName.get(Constant.MILESTONE_PO_RECORDTYPE).getRecordTypeId();
        findAllMilestones();
        getallMilestonesFromAssociatedProject();
        //addMore();
            
    }
    
    public void init(){
        mileStonesInvoice = new List<MilestoneWrapper>();
        mileStonesPO = new List<MilestoneWrapper>();
        contractId = null;
        projectId = null;
        index = 0;
      
    }    
    
    public boolean enableDistributeButton{Set;Get;}
    public void findAllMilestones(){

        List<Milestone__c> tempMileStones = new List<Milestone__c>();
        if(isContract){
            tempMileStones = MilestoneDAO.getMileStonesForContract(recordIds);
        }
        else if(isProject){
            tempMileStones = MilestoneDAO.getMileStonesForProject(recordIds);
        }
        for(Milestone__c mStone: tempMileStones){
            
            MilestoneWrapper mStoneWrap = new MilestoneWrapper(mStone,index);
            if(mStone.recordTypeId == invoiceRecordTypeId){
                mileStonesInvoice.add(mStoneWrap);
                if(mStoneWrap.mileStone.Milestone_Type__c == Constant.MILESTONE_TYPE_ON_CONTRACT &&
                    mStoneWrap.mileStone.Status__c != Constant.MILESTONE_STATUS_PLANNED &&
                    mStoneWrap.mileStone.Status__c != Constant.MILESTONE_STATUS_READY_TO_INVOICE){
                     enableDistributeButton = true;
                }
               
            }else if (mStone.recordTypeId == poRecordTypeId){
                mileStonesPO.add(mStoneWrap);
            }
            
            index++;
        }
        
    }  

    public void getallMilestonesFromAssociatedProject(){

        if(isContract){
            Set<id> conIds = new Set<id>();
            conIds.add(contractId);
            List<Milestone__c> mstones = MilestoneDAO.getMileStonesForSolarLightProject(conIds);
            if(mstones.size() > 0){
                enableDistributeButton = false;
            }

        }

    }
    public PageReference save(){
        try{
            if(calculateMilestoneValue()){
                System.debug('***** Save method started *****');
                boolean isValidated = validateMileStone();
                if(isValidated){
                    List<Milestone__c> mStones = new List<Milestone__c>();
                    for(MilestoneWrapper mStone: mileStonesInvoice){
                        mStones.add(mStone.mileStone);
                    }
                    for(MilestoneWrapper mStone: mileStonesPO){
                        mStones.add(mStone.mileStone);
                    }
                
                    if(mStones.size() > 0 ){
                        upsert mStones;
                        
                        init();
                        findAllMilestones();
                        getallMilestonesFromAssociatedProject();
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.Milestone_Save_Message));
                        isEditMode = false;
                        
                    }
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Milestone_Mandatory_Field_Missing));
                }
            }
        }catch(DMLException ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getDMLMessage(0)));
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));

        }
        return null;
        
        
    }
    
    
    public boolean validateMileStone(){
        
        for(MilestoneWrapper mStone: mileStonesInvoice){
                    
          if(mStone.mileStone.Status__c == null || mStone.mileStone.Percentage__c == null || mStone.mileStone.Due_Date__c == null){
              
              return false;
          }
        }
        for(MilestoneWrapper mStone: mileStonesPO){
                    
          if(mStone.mileStone.Status__c == null || mStone.mileStone.Percentage__c == null || mStone.mileStone.Due_Date__c == null){
              
              return false;
          }
        }
        return true;
        
    }
    
    
    public void enableEditMode(){
        if(isProject && mileStonesInvoice.size() == 0 && rcrdTypeOfProject !='Paid Feasibility Project'){

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Use_Distribute_button));


        }else{
            isEditMode = true;
        }

        
    }
    
    public decimal totalMilestoneInvoicePercentage{set;get;}
    public decimal totalMilestonePOpercentage {set;get;}
    public decimal totalMilestoneInvoiceValue{set;get;}
    public decimal totalMilestonePOValue {set;get;}

    public boolean calculateMilestoneValue(){
        totalMilestoneInvoicePercentage = 0.0;
        totalMilestonePOpercentage = 0.0;
        totalMilestoneInvoiceValue = 0.0;
        totalMilestonePOValue = 0.0;

         for(MilestoneWrapper mStone: mileStonesInvoice){
                    
             if(mStone.mileStone.Percentage__c != null 
                                && projectValueforInvoice !=null){
                  //mStone = calculateMilestonevalue(mStone,projectValueforInvoice);

                  //if(mStone.mileStone.Milestone_Type__c != Constant.MILESTONE_TYPE_VARIANCE ){
                    totalMilestoneInvoicePercentage += (mStone.mileStone.Percentage__c);
                    totalMilestoneInvoiceValue += mStone.mileStone.Milestone_Value__c;
                 // }
              }
        }
        for(MilestoneWrapper mStone: mileStonesPO){
                    
              if(mStone.mileStone.Percentage__c != null 
                                && projectValueforPO !=null){
                  //mStone = calculateMilestonevalue(mStone,projectValueforPO);

                  //if(mStone.mileStone.Milestone_Type__c != Constant.MILESTONE_TYPE_VARIANCE ){
                    totalMilestonePOPercentage += (mStone.mileStone.Percentage__c);
                    totalMilestonePOValue += mStone.mileStone.Milestone_Value__c;
                  //}
              }
        }
        boolean isValidated = true;
        //totalMilestoneInvoicePercentage =  totalMilestoneInvoicePercentage.setScale(2); 
        //totalMilestonePOPercentage = totalMilestonePOPercentage.setScale(2); 
        if(projectValueforInvoice != null && projectValueforInvoice !=0 &&
           projectValueforInvoice != totalMilestoneInvoiceValue){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                       String.format(Label.Invoice_Milestone_Sum_Error,
                                                                     new String[]{
                                                                         String.valueOf(totalMilestoneInvoiceValue),
                                                                         String.valueOf(projectValueforInvoice)})
                                                      ));
            //isValidated = false;
        }
        if(projectValueforPO != null && projectValueforPO !=0 && 
           projectValueforPO != totalMilestonePOValue){
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                       String.format(Label.Vendor_Payment_Milestones_Sum_Error,
                                                                     new String[]{
                                                                         String.valueOf(totalMilestonePOValue),
                                                                         String.valueOf(projectValueforPO)})
                                                      ));
            //isValidated = false;
        }
        /*       
 *  if(totalMilestoneInvoicePercentage !=100){

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,String.format(Label.Invoice_Percentage_Sum_Error, new String[]{String.valueOf(totalMilestoneInvoicePercentage)}) ));
           isValidated = false;
        }
        if(totalMilestonePOPercentage !=100 && projectValueforPO!=null && projectValueforPO!=0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,String.format(Label.PO_Percentage_Sum_Error, new String[]{String.valueOf(totalMilestonePOPercentage)}) )); 
            isValidated = false;

        }*/

        return isValidated;
       
    } 

    /*MilestoneWrapper calculateMilestonevalue(MilestoneWrapper mstoneWrapper, decimal projValue){
        mstoneWrapper.mileStone.Milestone_Value__c = Math.Round(projValue * (mstoneWrapper.mileStone.Percentage__c/100));
        return mstoneWrapper;
    }*/
   

    public void distrubtionOfContractDeposit(){
        if(contractId !=null){
             Set<id> contractIds= new Set<id>();
            contractIds.add(contractId);
            List<Contract> contracts = ContractDAO.getAllContracts(contractIds);
            if(contracts.size() > 0){
                // Validate if amount is same
                List<Opportunity> projects = OpportunityDAO.getProjectsFromContract(contractIds);
                Decimal totalVal = 0.0;

                Set<Id> projectIds = new Set<Id>();

                for(Opportunity proj: projects){
                    projectIds.add(proj.Id);
                    if(proj.Pre_Post_RFQ_Value__c !=null){
                        totalVal += proj.Pre_Post_RFQ_Value__c;
                    }
                    
                }

                if(totalVal == contracts[0].Pre_Post_Contract_Value__c){

                    List<Milestone__c> mileStones = MilestoneDAO.getMileStonesForProject(projectIds);

                    if(mileStones.size() == 0){
                        MilestoneUtility.createMilestones(contracts[0]);
                        // Delete milestones present on the contract
                        List<Milestone__c> milestonesInContct = contracts[0].Milestones__r;
                        List<Milestone__c> milestonesToBeDeleted = new List<Milestone__c>();
                        for(Milestone__c mStone: milestonesInContct){
                             if(mStone.Milestone_Type__c != Constant.MILESTONE_TYPE_ON_CONTRACT){
                                milestonesToBeDeleted.add(mStone);
                             }
                        }

                        if(milestonesToBeDeleted.size() > 0){
                            delete milestonesToBeDeleted;
                        }
                       

                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.Distribution_successful));


                    }else{
                        // Error Msg for milestone
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Milestone_already_created));

                    }
                    

                }else{
                    // Error Msg for difference in Project value & Contract value
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Project_Value_Difference));

                }

                
            }
            
        }
        
    }
    
    
    

}