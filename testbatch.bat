ECHO off
REM Fintrack Python Batch File

:: See the title at the top
CALL cd C:\Salesforce\Dataloader\bin

CALL .\process.bat C:\Salesforce\DataExports csvMilestoneExtractProcess
ECHO Ran process1 csvMilestoneExtractProcess

CALL .\process.bat C:\Salesforce\DataExports csvOpportunityExtractProcess
ECHO Ran process2 csvOpportunityExtractProcess

CALL .\process.bat C:\Salesforce\DataExports csvOpportunityExtractProcess
ECHO Ran process2 csvOpportunityExtractProcess

CALL .\process.bat C:\Salesforce\DataExports csvContractExtractProcess
ECHO Ran process2 csvContractExtractProcess

CALL .\process.bat C:\Salesforce\DataExports csvAccountExtractProcess
ECHO Ran process2 csvAccountExtractProcess

ECHO COPY C:\Salesforce\DataExports\MilestoneExtract.csv C:\Users\mceda\OneDrive - Verdia Pty Ltd\Fintracker Export Project\Fintrack Script
ECHO COPY C:\Salesforce\DataExports\OpportunityExtract.csv C:\Users\mceda\OneDrive - Verdia Pty Ltd\Fintracker Export Project\Fintrack Script

ECHO CALL cd C:\Users\mceda\OneDrive - Verdia Pty Ltd\Fintracker Export Project\Fintrack Script\
ECHO CALL python main.py MilestoneExtract.csv OpportunityExtract.csv 

PAUSE