# ApexTestResultResults
Automated job that can produce apex test results of complete org. Can send an email notification with the test result


Pre requisite to deploy and run the code:
------------------------------------------

1. Create a Custom Metadata Type Named - ApexTestResultConfig__mdt ( Please use the exact API name). Keep visiblity as public.

2. Create a custom text field with the lable Name - Value and API name as Value__c.

3. Add the below custom metadata type records:

Label Name | ApexTestResultConfig Name | Value__c
---------------------------------------------------
EmailList  |   EmailList	       | Add all the email address that should receive the test result report

										 	 AccountHandlerTest,CaseHandlerTest,OpportunityCallTest

4. Schedule the Apex jobs:

<-- To be added ---->

