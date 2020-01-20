public without sharing class OpportunityTriggerHandler {         
   
    public static void createMilestonesforSalesOppty(Map<Id, Opportunity> newOpportunities, Map<Id, Opportunity> oldOpportunities) {
    
        Map<String,Schema.RecordTypeInfo> rtMapByName  = RecordTypeDAO.getRecordTypes(Schema.SObjectType.Opportunity);
        Map<String,Schema.RecordTypeInfo> rtMapByName2 = RecordTypeDAO.getRecordTypes(Schema.SObjectType.Milestone__c);
        Id bankDirectRecordTypeId = rtMapByName.get(Constant.OPPORTUNITY_BANKDIRECT_RECORDTYPE).getRecordTypeId();
        id invoiceRecordTypeId = rtMapByName2.get(Constant.MILESTONE_INVOICE_RECORDTYPE).getRecordTypeId();
        id poRecordTypeId = rtMapByName2.get(Constant.MILESTONE_PO_RECORDTYPE).getRecordTypeId();
        Map<Id, String> opptyAllocation = new Map<Id, String>();
        List <Opportunity> opportunities = new List<Opportunity>();
        Set<id> opptyIDs = new Set<Id>();
    
    
        for(Opportunity oppty :newOpportunities.values()){
            if(oppty.recordtypeid == bankDirectRecordTypeId && oppty.Opportunity_Allocation__c != NULL &&
            ((oldOpportunities == NULL && oppty.StageName != NULL && oppty.CloseDate != NULL && oppty.VD_Project_Value__c != NULL && oppty.Opportunity_Allocation__c != NULL)||
            (oppty.VD_Project_Value__c != NULL &&
            (oldOpportunities.get(oppty.Id).StageName != oppty.StageName
            || oldOpportunities.get(oppty.Id).CloseDate != oppty.CloseDate
            || oldOpportunities.get(oppty.Id).VD_Project_Value__c != oppty.VD_Project_Value__c
            || oldOpportunities.get(oppty.id).Opportunity_Allocation__c != oppty.Opportunity_Allocation__c)))){   
                opptyAllocation.put(oppty.id, oppty.Opportunity_Allocation__c);    
                opportunities.add(oppty);
                opptyIDs.add(oppty.id);
            }
        }
        
        if(opptyAllocation.size()>0){
            List<Milestone__c> deleteMilestones = MilestoneDAO.getMileStonesForProject(opptyIDs);
            List<Milestone__c> createMilestones = new List<Milestone__c>();
            Map<string, id> salesMilestoneRecordType = new Map<string,id>();
            
            salesMilestoneRecordType.put(Constant.SALESMILESTONE_INVOICE_MILESTONE,invoiceRecordTypeId);
            salesMilestoneRecordType.put(Constant.SALESMILESTONE_VENDOR_PAYMENT_MILESTONE,poRecordTypeId);
            
            Map<string, List<Sales_Milestones_Auto_Creation__mdt>> salesMilestonesbyOpportunityAllocation = MilestoneUtility.getMileStonesAutoCreationbyOppAllocation();
            
            for(Opportunity oppty :opportunities){
                for(Sales_Milestones_Auto_Creation__mdt salesMilestone :salesMilestonesbyOpportunityAllocation.get(oppty.Opportunity_Allocation__c)){
                system.debug('OpptyAllocation'+ oppty.Opportunity_Allocation__c);
                system.debug('OpptyAllocationGet'+ salesMilestonesbyOpportunityAllocation.get(oppty.Opportunity_Allocation__c));
                
                    createMilestones.add(new Milestone__c(Name= salesMilestone.Label, 
                                                          Percentage__c = salesMilestone.Percentage__c, 
                                                          Status__c = Constant.MILESTONE_STATUS_FORECAST, 
                                                          RecordTypeID = salesMilestoneRecordType.get(salesMilestone.Milestone_Type__c), 
                                                          Services__c = salesMilestone.Services__c,
                                                          Opportunity__c = oppty.id,
                                                          Due_Date__c = oppty.CloseDate.addMonths(integer.valueof(salesMilestone.Month_After_Contract_Start__c))));
                                                               
                }
            }
            if(deleteMilestones.size()>0){
                delete deleteMilestones;
                Database.emptyRecycleBin(deleteMilestones);
            }
            if(createMilestones.size()>0){
                insert createMilestones;
            }
        
        
        }
    }
    
    
    public static void upsertContractFromOppty(Map<Id, Opportunity> newOpportunities, Map<Id, Opportunity> oldOpportunities) {
   
        Map<String,Schema.RecordTypeInfo> rtMapByName  = RecordTypeDAO.getRecordTypes(Schema.SObjectType.Opportunity);
        Map<String,Schema.RecordTypeInfo> rtMapByName2 = RecordTypeDAO.getRecordTypes(Schema.SObjectType.Milestone__c);
        Id bankDirectRecordTypeId = rtMapByName.get(Constant.OPPORTUNITY_BANKDIRECT_RECORDTYPE).getRecordTypeId();
        id invoiceRecordTypeId = rtMapByName2.get(Constant.MILESTONE_INVOICE_RECORDTYPE).getRecordTypeId();
        id poRecordTypeId = rtMapByName2.get(Constant.MILESTONE_PO_RECORDTYPE).getRecordTypeId();
        Map<Id, String> opptyAllocation = new Map<Id, String>();
        List <Opportunity> opportunities = new List<Opportunity>();
        Set<id> opptyIDs = new Set<Id>();
        
        List<Contract> contractsToUpsert = new  List<Contract>();
        try{
    
        for(Opportunity oppty :newOpportunities.values()){
            if(oppty.recordtypeid == bankDirectRecordTypeId && oppty.StageName != NULL &&
               (oppty.StageName == Constant.OPPORTUNITY_STAGE_PAID_FEASIBILITY ||
                oppty.StageName == Constant.OPPORTUNITY_STAGE_WON) && 
                ((oldOpportunities == NULL)||
                     (oldOpportunities != NULL 
                     && oldOpportunities.get(oppty.Id).StageName !=oppty.StageName))){
                     
                opportunities.add(oppty);
            }
        }
        
        for(Opportunity oppty :opportunities){
            ContractUtil contractUtility = new ContractUtil();
            Contract contractRec = contractUtility.createUpdContract(oppty);
            contractsToUpsert.add(contractRec);
            
             
        }
        
        
        if(contractsToUpsert.size() > 0){
        
            upsert contractsToUpsert;
        }
        
        }catch(DMLException ex){
    
             for(Opportunity oppty :opportunities){
                oppty.addError(ex.getDMLMessage(0));
             }
        
        }catch(Exception ex){
        
             for(Opportunity oppty :opportunities){
                oppty.addError(ex.getMessage());
             }
        }
    }
    public static void updateMilestonesPostRFQ(Map<Id, Opportunity> newOpportunities, Map<Id, Opportunity> oldOpportunities) {

        Map<String,Schema.RecordTypeInfo> rtMapByName  = RecordTypeDAO.getRecordTypes(Schema.SObjectType.Opportunity);
        Map<String,Schema.RecordTypeInfo> rtMapByName2 = RecordTypeDAO.getRecordTypes(Schema.SObjectType.Milestone__c);
        Map<id, decimal> projectValueDifference = new Map<id, decimal>();
        Map<id, decimal> vendorCostDifference = new Map<id, decimal>();
        Set<id> projectsIDs = new Set<id>();
        Set<id> contractIDs = new Set<id>();

        // Post RFQ changes for project value (invoice to client)    
        for(Opportunity oppty :newOpportunities.values()){
            if(oldOpportunities <> NULL &&
               oppty.Post_RFQ_Project_Value__c <> oldOpportunities.get(oppty.id).Post_RFQ_Project_Value__c){
                if(oldOpportunities.get(oppty.id).Post_RFQ_Project_Value__c == NULL){
                    projectValueDifference.put(oppty.id, oppty.Post_RFQ_Project_Value__c - oppty.VD_Project_Value__c);
                    contractIDs.add(oppty.Project_Contract__c);
                    projectsIDs.add(oppty.id);

                }
                if(oldOpportunities.get(oppty.id).Post_RFQ_Project_Value__c <> NULL && 
                    oppty.Post_RFQ_Project_Value__c <> NULL && 
                    oppty.Post_RFQ_Project_Value__c <> oldOpportunities.get(oppty.id).Post_RFQ_Project_Value__c
                    ){
                    projectValueDifference.put(oppty.id, oppty.Post_RFQ_Project_Value__c - oldOpportunities.get(oppty.id).Post_RFQ_Project_Value__c );
                    contractIDs.add(oppty.Project_Contract__c);
                    projectsIDs.add(oppty.id);
                }
            }
        }
        // Post RFQ for Vendor Cost
        Set<id> projectIDsforVendorPayment = new Set<id>();

        for(Opportunity oppty :newOpportunities.values()){
            if(oldOpportunities <> NULL && 
               oppty.Post_RFQ_Vendor_Cost__c <> NULL &&
               oppty.Post_RFQ_Vendor_Cost__c <> oldOpportunities.get(oppty.id).Post_RFQ_Vendor_Cost__c){

                vendorCostDifference.put(oppty.id,oppty.Post_RFQ_Vendor_Cost__c);
                projectIDsforVendorPayment.add(oppty.id); 
            }
        }
/*
        for(Opportunity oppty :newOpportunities.values()){
            if(oldOpportunities <> NULL &&
               oldOpportunities.get(oppty.id).Post_RFQ_Vendor_Cost__c <> NULL && 
               oppty.Post_RFQ_Vendor_Cost__c <> NULL && 
               oppty.Post_RFQ_Vendor_Cost__c <> oldOpportunities.get(oppty.id).Post_RFQ_Vendor_Cost__c){

                vendorCostDifference.put(oppty.id,oppty.Post_RFQ_Vendor_Cost__c - oldOpportunities.get(oppty.id).Post_RFQ_Vendor_Cost__c);
                projectIDsforVendorPayment.add(oppty.id); 
            }
            if(oldOpportunities <> NULL &&
                oldOpportunities.get(oppty.id).Post_RFQ_Vendor_Cost__c == NULL && oppty.Post_RFQ_Vendor_Cost__c <> NULL){
                System.debug('******vendorCostDifference Map***');
                vendorCostDifference.put(oppty.id, oppty.Post_RFQ_Vendor_Cost__c - (oppty.VD_Project_Value__c - oppty.Verdia_Revenue2_Dollar__c ));
                //projectsIDs.add(oppty.id);
                projectIDsforVendorPayment.add(oppty.id);
            }
        }*/

        System.debug('******vendorCostDifference Map***'+vendorCostDifference);
        // Search for Last Invoice milestone
        Map<id, Milestone__c> lastMilestone = new Map<id, Milestone__c>();
        List<Milestone__c> projectContractMilestones = MilestoneDAO.getMileStonesForProjectwithVariance(projectsIDs);
        
        for(Milestone__c milestone:projectContractMilestones ){

            if(milestone.Opportunity__c <> NULL  && milestone.Status__c == Constant.MILESTONE_STATUS_PLANNED && milestone.recordtypeid == rtMapByName2.get(Constant.MILESTONE_INVOICE_RECORDTYPE).getRecordTypeId()){
                if(lastMilestone.get(milestone.Opportunity__c) == null){
                    lastMilestone.put(milestone.Opportunity__c, milestone);                   
                }
            }
        }

        // Search for All Vendor Payment Milestone
        List<Milestone__c> updateLastMilestoneValue = new List<Milestone__c>();
        Map<id, Milestone__c> lastVendorMilestone = new Map<id, Milestone__c>();
        List<Milestone__c> projectContractVendorMilestones = new List<Milestone__c>();
        if(projectIDsforVendorPayment.size()>0){
            projectContractVendorMilestones = MilestoneDAO.getMileStonesForProjectwithVariance(projectIDsforVendorPayment);
            for(Milestone__c milestone:projectContractVendorMilestones ){
        
                 if(milestone.Opportunity__c <> NULL  && milestone.recordtypeid == rtMapByName2.get(Constant.MILESTONE_PO_RECORDTYPE).getRecordTypeId() &&  milestone.Status__c == Constant.MILESTONE_STATUS_PLANNED){

                     milestone.Milestone_Value__c = (milestone.Percentage__c/100) * vendorCostDifference.get(milestone.Opportunity__c);
                     updateLastMilestoneValue.add(milestone);
                     /*
                     if(lastVendorMilestone.get(milestone.Id) == null){
                         lastVendorMilestone.put(milestone.Id, milestone);

                         updateLastMilestoneValue.add(milestone);

                     }*/
                 }
             }
        }

       

        // Update invoice  milestone
        if(lastMilestone.size()>0){
            for(Milestone__c milestone :lastMilestone.values()){
                if(milestone.Opportunity__c <> NULL && projectValueDifference.get(milestone.Opportunity__c) !=null){
                    milestone.Milestone_Value__c = milestone.Milestone_Value__c + projectValueDifference.get(milestone.Opportunity__c);              
                }
                updateLastMilestoneValue.add(milestone);
            }
        }
        // Update vendor  milestone
        /*
        System.debug('***lastVendorMilestone'+ lastVendorMilestone);
        if(lastVendorMilestone <> NULL){
            for(Milestone__c milestone :lastVendorMilestone.values()){
                if(milestone.Opportunity__c <> NULL && vendorCostDifference.get(milestone.Opportunity__c) !=null){
                    milestone.Milestone_Value__c = milestone.Milestone_Value__c + vendorCostDifference.get(milestone.Opportunity__c);              
                }
                updateLastMilestoneValue.add(milestone);
            }
        }*/

        update updateLastMilestoneValue;

        List<Milestone__c> updateMilestonePercentage = new List<Milestone__c>();

        if(projectContractMilestones<>NULL){
            for(Milestone__c milestone:projectContractMilestones ){
                if(milestone.recordtypeid == rtMapByName2.get(Constant.MILESTONE_INVOICE_RECORDTYPE).getRecordTypeId()){
                    milestone.Percentage__c = (milestone.Milestone_Value__c / milestone.Post_RFQ_Value__c)*100;
                     if( milestone.Percentage__c!=null){
                         milestone.Percentage__c =  milestone.Percentage__c.setScale(2);
                    }
                    updateMilestonePercentage.add(milestone);
                }
            }
        }
        if(projectContractVendorMilestones<>NULL){
            for(Milestone__c milestone:projectContractVendorMilestones ){
                if(milestone.recordtypeid == rtMapByName2.get(Constant.MILESTONE_PO_RECORDTYPE).getRecordTypeId()){
                    milestone.Percentage__c = (milestone.Milestone_Value__c / milestone.Post_RFQ_Vendor_Cost__c)*100;
                     if( milestone.Percentage__c!=null){
                         milestone.Percentage__c =  milestone.Percentage__c.setScale(2);
                    }
                    updateMilestonePercentage.add(milestone);
                }
            }
        }
        update updateMilestonePercentage;
        // Update Contract Post RFQ Value

        for(Opportunity oppty :newOpportunities.values()){
            if(oppty.StageName == Constant.OPPORTUNITY_STAGE_DELIVER || oppty.StageName == Constant.OPPORTUNITY_STAGE_CLOSED_LOST){
                
                if(oppty.Project_Contract__c <>NULL){
                contractIDs.add(oppty.Project_Contract__c);
                }
            }
        }
        if(contractIDs.size()>0){
            List<Opportunity> projects = OpportunityDAO.getProjectsFromContract(contractIDs);
            Map<id, decimal> contractPostRFQ = new Map<id, decimal>();
            Map<id, decimal> contractPostRFQVendorCost = new Map<id, decimal>();
            Map<id, boolean> contractPostRFQNotCompleted = new Map<id, boolean>();
             for(Opportunity project:projects ){

                if(project.Post_RFQ_Project_Value__c != NULL){
                    if(contractPostRFQ.get(project.Project_Contract__c)==NULL  ){
                        contractPostRFQ.put(project.Project_Contract__c, project.Post_RFQ_Project_Value__c);
                    } else {
                        decimal sumPostRFQ;
                        sumPostRFQ = contractPostRFQ.get(project.Project_Contract__c) + project.Post_RFQ_Project_Value__c;
                        contractPostRFQ.put(project.Project_Contract__c,sumPostRFQ);
                    }
                }else{
                    contractPostRFQNotCompleted.put(project.Project_Contract__c,true);
                }

                if(project.Post_RFQ_Vendor_Cost__c != NUll){
                    if(contractPostRFQVendorCost.get(project.Project_Contract__c) == NULL){
                        contractPostRFQVendorCost.put(project.Project_Contract__c, project.Post_RFQ_Vendor_Cost__c);
                    } else{
                        decimal sumPostRFQCost;
                        sumPostRFQCost = contractPostRFQVendorCost.get(project.Project_Contract__c) + project.Post_RFQ_Vendor_Cost__c;
                        contractPostRFQVendorCost.put(project.Project_Contract__c, sumPostRFQCost);
                    }

                } 
                
            }
            List<Contract> updateContract = new List<Contract>();
            for(id id :contractIDs){
                boolean postRFQNoCompleted = false;
                if(contractPostRFQNotCompleted.get(id) != null){
                    postRFQNoCompleted = contractPostRFQNotCompleted.get(id);
                }
                string postRFQMessage = postRFQNoCompleted ? Label.Post_RFQ_Comments_IN_Complete_Projects: Label.Post_RFQ_Comments;

                Contract contract = new Contract(id=id, Post_RFQ_Contract_Value__c = contractPostRFQ.get(id), Post_RFQ_Comments__c = postRFQMessage, Post_RFQ_Vendor_Cost__c = contractPostRFQVendorCost.get(id));
                updateContract.add(contract);
            
            }
            if(updateContract.size()>0){
                update updateContract;
            }
        }
    }
    public static void createNextMeeting(Map<Id, Opportunity> newOpportunities, Map<Id, Opportunity> oldOpportunities) {
       // Map <id, date > salesOpptyMeetingDate = new Map<id, date>();
       // Map <id, id> advisorId = new Map <id, id>();
        Set <String> opptyKey = new Set <String>();
        Map <id, String> opptyIdKey = new Map <id,String>();

        for(Opportunity oppty :newOpportunities.values()){
            if(oldOpportunities.get(oppty.id).Next_Meeting_Date__c <> oppty.Next_Meeting_Date__c && oppty.Next_Meeting_Date__c<> NULL){
               // salesOpptyMeetingDate.put(oppty.Id, oppty.Next_Meeting_Date__c);
              //  advisorId.put(oppty.Id, oppty.Ownerid);
                string key = string.valueof(oppty.ownerid) + string.valueof(oppty.id) + string.valueof(oppty.Next_Meeting_Date__c);
                opptyKey.add(key);
                opptyIdKey.put(oppty.id, key);

            }
        }

        List<Event> meetings = new List<Event>(); 
        if(opptyKey.size()>0){
            meetings = EventDAO.getSalesOpptyEvent(opptyKey);
        }
        system.debug('kengo'+meetings.size());
        Map <id, String> eventKey = new Map <id, String>();
        if(meetings.size()>0){
            for(Event meeting :meetings){
                eventKey.put(meeting.whatid, meeting.Event_Key__c);
            }
        }

        list<Event> createMeeting = new List<Event>();

        for(Opportunity oppty :newOpportunities.values()){
            if(oldOpportunities.get(oppty.id).Next_Meeting_Date__c <> oppty.Next_Meeting_Date__c && oppty.Next_Meeting_Date__c<> NULL
            &&   eventKey.get(oppty.id) <> opptyIdKey.get(oppty.id)){
                Integer d = oppty.Next_Meeting_Date__c.day();
                Integer mo = oppty.Next_Meeting_Date__c.month();
                Integer yr = oppty.Next_Meeting_Date__c.year();
                DateTime DT = DateTime.newInstance(yr, mo, d);

                Event meeting = new Event(Ownerid = oppty.ownerid, whatid = oppty.id, StartDateTime = DT+0.5, EndDateTime = DT+0.5417, Type = 'Meeting', Subject ='Meeting', Description = oppty.Next_Steps__c);
                createMeeting.add(meeting);

                system.debug('eventkey'+eventKey.get(oppty.id));
                system.debug('eventkey'+opptyIdKey.get(oppty.id));

            }
        }

        if(createMeeting.size()>0){
            insert createMeeting;
        }
    }
    public static boolean executed;

    public static void createActivity(Map<Id, Opportunity> newOpportunities, Map<Id, Opportunity> oldOpportunities) {

        if (executed == null || executed == false){

            Set <Id> opptyIds = new Set <Id>();
            List <Activity_History__mdt> allActivityHistory = MetaDataDAO.getAllActivityHistory();
            List <Event> createEvents = new List <Event>();
            Map<String,Schema.RecordTypeInfo> rtMapByName  = RecordTypeDAO.getRecordTypes(Schema.SObjectType.Opportunity);
            id opptyRecordTypeId;

            
            for(Opportunity oppty :newOpportunities.values()){

                if(oppty.VALIDATION_TRIGGER_OFF__C == FALSE){
                    for(Activity_History__mdt activity:allActivityHistory){
    
                        if(activity.RecordType__c<>NULL){
                            opptyRecordTypeId = rtMapByName.get(activity.RecordType__c).getRecordTypeId();
                        }
    
                        if(activity.RecordType__c==NULL || (opptyRecordTypeId<> NULL && opptyRecordTypeId == oppty.recordtypeid)  ){
    
                            if((Datetime)oldOpportunities.get(oppty.id).get(activity.Activity_End__c) <> (Datetime)oppty.get(activity.Activity_End__c) &&  (Datetime)oppty.get(activity.Activity_End__c) <> NULL && activity.Activity_Start_2__c == NULL){       
                               if(  ((Datetime)oppty.get(activity.Activity_Start__c) == NULL || (Datetime)oppty.get(activity.Activity_Start__c)> (Datetime)oppty.get(activity.Activity_End__c))){
                                    oppty.addError('Please make sure '+ (String)activity.Activity_Start__c +' is populated and the date is before ' + (String)activity.Activity_End__c );
    
                                }else{
    
                                   Event event = new Event(Activity_Step__c = activity.label, Subject = activity.label, Stage__c =activity.Stage__c, Whatid = oppty.Id, Ownerid = oppty.Ownerid, StartDateTime =(Datetime)oppty.get(activity.Activity_Start__c), EndDateTime = (Datetime)oppty.get(activity.Activity_Start__c), End_Date_Custom__c = (Datetime)oppty.get(activity.Activity_End__c)); 
                                   createEvents.add(event);
                                   opptyIds.add(oppty.id);
                                                        system.debug('***startdate3***'+(Datetime)oppty.get(activity.Activity_Start__c));
                                    system.debug('***enddate3***'+(Datetime)oppty.get(activity.Activity_End__c));   
    
                                }
    
    
                               
                            }
                            else if(activity.Activity_Start_2__c <> NULL //&& (Datetime)oppty.get(activity.Activity_Start_2__c) <> NULL 
                            && (Datetime)oppty.get(activity.Activity_Start__c) == NULL 
                            && (Datetime)oldOpportunities.get(oppty.id).get(activity.Activity_End__c) <> (Datetime)oppty.get(activity.Activity_End__c) 
                            && (Datetime)oppty.get(activity.Activity_End__c)<>NULL){       
    
                               if((Datetime)oppty.get(activity.Activity_Start_2__c)==NULL  ||(Datetime)oppty.get(activity.Activity_Start_2__c)> (Datetime)oppty.get(activity.Activity_End__c) ){
                                    oppty.addError('Please make sure '+ (String)activity.Activity_Start_2__c +' is populated and the date is before ' + (String)activity.Activity_End__c );
                                }
                                else{
                                   Event event = new Event(Activity_Step__c = activity.label, Subject = activity.label, Stage__c =activity.Stage__c, Whatid = oppty.Id, Ownerid = oppty.Ownerid, StartDateTime =(Datetime)oppty.get(activity.Activity_Start_2__c), EndDateTime = (Datetime)oppty.get(activity.Activity_Start_2__c),  End_Date_Custom__c = (Datetime)oppty.get(activity.Activity_End__c)); 
                                   createEvents.add(event);
                                   opptyIds.add(oppty.id);    
    
                             
                                }
    
    
    
    
                            }
                             //       system.debug('***startdate2***'+(Datetime)oppty.get(activity.Activity_Start_2__c));
                               //     system.debug('***enddate2***'+(Datetime)oppty.get(activity.Activity_End__c));   
                              //      system.debug('***ActivityLabel***'+activity.label)); 
    
    
                            else if((Datetime)oppty.get(activity.Activity_Start__c)<>NULL && (Datetime)oldOpportunities.get(oppty.id).get(activity.Activity_Start__c) <>(Datetime)oppty.get(activity.Activity_Start__c) && (Datetime)oppty.get(activity.Activity_End__c) == NULL){       
                               Event event = new Event(Activity_Step__c = activity.label, Subject = 'Current Step: '+activity.label, Stage__c =activity.Stage__c, Whatid = oppty.Id, Current_Step__c = true, Ownerid = oppty.Ownerid, StartDateTime =(Datetime)oppty.get(activity.Activity_Start__c), EndDateTime = (Datetime)oppty.get(activity.Activity_Start__c) ); 
                               createEvents.add(event);
                                opptyIds.add(oppty.id); 
                              //  oppty.Current_Step__c = activity.label;
                              //  updateOpportunity.add(oppty);
                                                        system.debug('***startdate1***'+(Datetime)oppty.get(activity.Activity_Start__c));
                                    system.debug('***enddate1***'+(Datetime)oppty.get(activity.Activity_End__c));   
    
                            }
                        }
                    }
                }
            }

            if(createEvents.size()>0){
            List <Event> activities = EventDAO.getOpptyActivity(opptyIds);

            if(activities.size()>0){
                delete activities;
            }

            insert createEvents;
          //  update updateOpportunity;

            executed = true;

            }

        }

    }












}