<apex:component controller="MilestoneAddEditController" allowDML="TRUE">
  <apex:attribute name="MilestonesRecords" description="Received list of Milestone Wrapper records" type="MilestoneWrapper[]" assignTo="{!mileStones}" required="true"/>
  <apex:attribute name="ContractIdVal" description="" type="string" assignTo="{!contractId}" required="false"/>
  <apex:attribute name="ProjectIdVal" description="" type="string" assignTo="{!projectId}" required="false"/>
  <apex:attribute name="titleVal" description="" type="string" assignTo="{!title}" required="true"/>
  <apex:attribute name="recordTypeIdVal" description="" type="string" assignTo="{!recordTypeId}" required="true"/>
  <apex:attribute name="paymentMileStone" description="" type="boolean" assignTo="{!isPaymentMilestone}" required="false"/>
  <apex:attribute name="editMode" description="" type="boolean" assignTo="{!isEditMode}" required="false"/>
  <apex:attribute name="prjValue" description="" type="decimal" assignTo="{!projValue}" required="false"/>
   
<apex:variable value="{!0.00}" var="Total"/>
  <script type="text/javascript">
      function calculateMSValue(obj1,obj2, obj3){
        var el = document.getElementById(obj1);
        var e2 = document.getElementById(obj2); 
        var e3 = document.getElementById(obj3);
        e3.value= ((el.value/100) * (e2.value)).toFixed(2);
      
          
          
      }
      
      function calculateMSPercentage(obj1,obj2, obj3){
        var el = document.getElementById(obj1);
        var e2 = document.getElementById(obj2); 
        var e3 = document.getElementById(obj3);
        
        var amntHere = el.value;
        amntHere = amntHere.replace(/,/g, '')
        e3.value= ((amntHere/e2.value ) * 100).toFixed(2);
      }
      
</script>

  <apex:pageBlock title="{!title}" rendered="{!isEditMode}">
      <apex:inputText id="totVal" value="{!projValue}" style="visibility: hidden;"></apex:inputText>
      
      <apex:variable value="{!0}" var="rowNum"/>  
      <apex:pageBlockTable value="{!mileStones}" var="ms" title="Invoice Milestone">
      
          <apex:column headerValue="Select">
              <apex:inputCheckbox value="{!ms.isChecked}" rendered="{!!ms.milestone.Read_Only__c}"/>
              <!--<apex:outputLink value="/{!ms.milestone.Id}" rendered="{!NOT(ISBLANK(ms.milestone.Id))}" target="_blank">View</apex:outputLink> -->
          </apex:column>
          
        
          <apex:column headerValue="{!$ObjectType.Milestone__c.fields.Milestone_Type__c.Label}">
              <apex:inputField value="{!ms.milestone.Milestone_Type__c}" rendered="{!!ms.milestone.Read_Only__c}">
                   <apex:actionSupport event="onchange" action="{!doCalculations}" rerender="mainPanel"  status="loadingScreen" >
                        <apex:param value="{!rowNum}" name="rowToUpd" assignTo="{!rowToUpd}"/>
                   </apex:actionSupport>
              </apex:inputField>
              <apex:variable var="rowNum" value="{!rowNum + 1}"/>
               <apex:outputField value="{!ms.milestone.Milestone_Type__c}" rendered="{!ms.milestone.Read_Only__c}"/>
          </apex:column>
          
          <apex:column headerValue="{!$ObjectType.Milestone__c.fields.Name.Label}">
              <apex:inputField value="{!ms.milestone.Name}" rendered="{!!ms.milestone.Read_Only__c}">
              </apex:inputField>
              <apex:outputField value="{!ms.milestone.Name}" rendered="{!ms.milestone.Read_Only__c}"/>

          </apex:column>

         
           <apex:column headerValue="{!$ObjectType.Milestone__c.fields.Percentage__c.Label}">
               <apex:outputPanel layout="block" styleClass="requiredInput">
                   <apex:outputPanel layout="block" styleClass="requiredBlock"/>
                   
                   <apex:inputField id="pcrnt" value="{!ms.milestone.Percentage__c}" onchange="calculateMSValue('{!$Component.pcrnt}','{!$Component.totVal}','{!$Component.msValue}');" rendered="{!!ms.milestone.Read_Only__c}"/>
                   <apex:outputField value="{!ms.milestone.Percentage__c}" rendered="{!ms.milestone.Read_Only__c}"/>

               </apex:outputPanel>
              
          </apex:column>
           <apex:column headerValue="{!$ObjectType.Milestone__c.fields.Due_Date__c.Label}">
               <apex:outputPanel layout="block" styleClass="requiredInput">
                   <apex:outputPanel layout="block" styleClass="requiredBlock"/>
                   <apex:inputField value="{!ms.milestone.Due_Date__c}" rendered="{!!ms.milestone.Read_Only__c}"/>
               </apex:outputPanel>
               <apex:outputField value="{!ms.milestone.Due_Date__c}" rendered="{!ms.milestone.Read_Only__c}"/>

          </apex:column>         
          <apex:column headerValue="{!$ObjectType.Milestone__c.fields.Milestone_Value__c.Label}">
              <bold><apex:inputField id="msValue" value="{!ms.milestone.Milestone_Value__c}"   style="font-weight: bold;" onchange="calculateMSPercentage('{!$Component.msValue}','{!$Component.totVal}','{!$Component.pcrnt}');" styleclass="splper" rendered="{!!ms.milestone.Read_Only__c}"/></bold>
              <apex:outputField value="{!ms.milestone.Milestone_Value__c}"  rendered="{!ms.milestone.Read_Only__c}" />

                
          </apex:column>  
          
           <apex:column headerValue="{!$ObjectType.Milestone__c.fields.Purchase_Order__c.Label}" rendered="{!isPaymentMilestone}">
               <apex:inputField value="{!ms.milestone.Purchase_Order__c}" rendered="{!!ms.milestone.Read_Only__c}"/>
               <apex:outputField value="{!ms.milestone.Purchase_Order__c}" rendered="{!ms.milestone.Read_Only__c}"/>

          </apex:column>  
           
          <apex:column headerValue="{!$ObjectType.Milestone__c.fields.Vendor_Invoice_Reference__c.Label}" rendered="{!isPaymentMilestone}">
              <apex:inputField value="{!ms.milestone.Vendor_Invoice_Reference__c}" rendered="{!!ms.milestone.Read_Only__c}"/>
                             <apex:outputField value="{!ms.milestone.Vendor_Invoice_Reference__c}" rendered="{!ms.milestone.Read_Only__c}"/>

          </apex:column>  
          
           <apex:column headerValue="{!$ObjectType.Milestone__c.fields.Services__c.Label}" >
              <apex:inputField value="{!ms.milestone.Services__c}" rendered="{!!ms.milestone.Read_Only__c}"/>
                                           <apex:outputField value="{!ms.milestone.Services__c}" rendered="{!ms.milestone.Read_Only__c}"/>

          </apex:column> 
            
          <apex:column headerValue="{!$ObjectType.Milestone__c.fields.Status__c.Label}">
              <apex:outputPanel layout="block" styleClass="requiredInput">
                   <apex:outputPanel layout="block" styleClass="requiredBlock"/>
                   <apex:inputField value="{!ms.milestone.Status__c}" rendered="{!!ms.milestone.Read_Only__c}"/>
              </apex:outputPanel>
                                                         <apex:outputField value="{!ms.milestone.Status__c}" rendered="{!ms.milestone.Read_Only__c}"/>

          </apex:column>  
      </apex:pageBlockTable>
      
      <apex:pageBlockButtons location="top">
          <apex:commandButton value="Add more" action="{!addMoreMS}"/>
          <apex:commandButton value="Delete" action="{!deleteMS}"/> 
      </apex:pageBlockButtons>
      </apex:pageBlock>
      
      <apex:pageBlock title="{!title}" rendered="{!!isEditMode}">
      <apex:variable value="{!0}" var="rowNum"/>  
      <apex:pageBlockTable value="{!mileStones}" var="ms" title="Invoice Milestone">
          
          
          <apex:column headerValue="{!$ObjectType.Milestone__c.fields.Name.Label}">
               <apex:outputLink value="/{!ms.milestone.Id}" rendered="{!NOT(ISBLANK(ms.milestone.Id))}" target="_blank">{!ms.milestone.Name}</apex:outputLink>
          </apex:column>
          <apex:column headerValue="{!$ObjectType.Milestone__c.fields.Percentage__c.Label}">
              <apex:outputField value="{!ms.milestone.Percentage__c}"/>
          </apex:column>
           <apex:column headerValue="{!$ObjectType.Milestone__c.fields.Due_Date__c.Label}">
               <apex:outputField value="{!ms.milestone.Due_Date__c}"/>
          </apex:column>         
          <apex:column headerValue="{!$ObjectType.Milestone__c.fields.Milestone_Value__c.Label}">
              <apex:outputField value="{!ms.milestone.Milestone_Value__c}"/>
          </apex:column>  
         
           <apex:column headerValue="{!$ObjectType.Milestone__c.fields.Purchase_Order__c.Label}" rendered="{!isPaymentMilestone}">
               <apex:outputField value="{!ms.milestone.Purchase_Order__c}"/>
          </apex:column>
          <apex:column headerValue="{!$ObjectType.Milestone__c.fields.Vendor_Invoice_Reference__c.Label}" rendered="{!isPaymentMilestone}">
              <apex:outputField value="{!ms.milestone.Vendor_Invoice_Reference__c}"/>     
          </apex:column> 
          
           <apex:column headerValue="{!$ObjectType.Milestone__c.fields.Services__c.Label}" >
              <apex:outputField value="{!ms.milestone.Services__c}"/>
          </apex:column> 
          
           <apex:column headerValue="{!$ObjectType.Milestone__c.fields.Status__c.Label}">
              <apex:outputField value="{!ms.milestone.Status_Image__c}"/>
          </apex:column>  
           <apex:column headerValue="{!$ObjectType.Milestone__c.fields.Invoice__c.Label}" rendered="{!NOT(isPaymentMilestone)}">
              <apex:outputField value="{!ms.milestone.Invoice__c}"/>
          </apex:column>      
      </apex:pageBlockTable>
      
      </apex:pageblock>
</apex:component>