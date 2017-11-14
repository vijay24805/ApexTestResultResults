# ApexTestResultResults
Automated job that can produce apex test results of complete org. Can send an email notification with the test result


Pre requisite to deploy and run the code:
------------------------------------------

1. Create a Custom Metadata Type Named - ApexTestResultConfig__mdt ( Please use the exact API name). Keep visiblity as public.

2. Create a custom text field with the lable Name - Value and API name as Value__c.

3. Add the below custom metadata type records:

a. Label Name -> EmailList , ApexTestResultConfig Name -> EmailList , Value__c -> Add all the email address that should receive the test result report

b. Label Name -> FolderId , ApexTestResultConfig Name -> FolderId , Value__c -> Add the SFDC ID of a folder where all the test report files can be stored

c. Label Name -> TestClasses , ApexTestResultConfig Name -> TestClasses , Value__c -> There are two option that can be set in values:
										 a. To get report of all the test class in Org enter -> Test
										 b. To get report on specific test classes-> Add all the test class names comma separated example:
										 	 AccountHandlerTest,CaseHandlerTest,OpportunityCallTest
											 
4. Schedule the Apex jobs:

<-- To be added ---->

