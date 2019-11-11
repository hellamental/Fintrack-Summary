Comparison File

          <apex:column headerValue="{!$ObjectType.Milestone__c.fields.Milestone_Type__c.Label}">
              <apex:inputField value="{!ms.milestone.Milestone_Type__c}" rendered="{!!ms.milestone.Read_Only__c}">
                   <apex:actionSupport event="onchange" action="{!doCalculations}" rerender="mainPanel"  status="loadingScreen" >
                        <apex:param value="{!rowNum}" name="rowToUpd" assignTo="{!rowToUpd}"/>
                   </apex:actionSupport>
              </apex:inputField>
              <apex:variable var="rowNum" value="{!rowNum + 1}"/>
               <apex:outputField value="{!ms.milestone.Milestone_Type__c}" rendered="{!ms.milestone.Read_Only__c}"/>
          </apex:column>


          <apex:column headerValue="{!$ObjectType.Milestone__c.fields.Due_Date__c.Label}">
               <apex:outputPanel layout="block" styleClass="requiredInput">
                   <apex:outputPanel layout="block" styleClass="requiredBlock"/>
                   <apex:inputField value="{!ms.milestone.Due_Date__c}" rendered="{!!ms.milestone.Read_Only__c}"/>
               </apex:outputPanel>
               <apex:outputField value="{!ms.milestone.Due_Date__c}" rendered="{!ms.milestone.Read_Only__c}"/>

          </apex:column>