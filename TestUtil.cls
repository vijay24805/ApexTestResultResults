public with sharing class TestUtil {
	
	public static ApexTestResultConfig__mdt custMeta =[select id,Value__c from ApexTestResultConfig__mdt where developername='TestClasses'];
	
	public static ID enqueueTests() {
		String queryTestClasses = '%'+custMeta.Value__c;
		String[] queryApexTestClasses = custMeta.Value__c.split(',');
		system.debug(queryTestClasses);
		system.debug(queryApexTestClasses);
		ApexClass[] testClasses = [SELECT Id FROM ApexClass WHERE Name like :queryTestClasses 
																OR Name in :queryApexTestClasses limit 2];
		if (testClasses.size() > 0) {
			ApexTestQueueItem[] queueItems = new List<ApexTestQueueItem>();
			for (ApexClass cls : testClasses) {
                queueItems.add(new ApexTestQueueItem(ApexClassId=cls.Id));
            }
		insert queueItems;
		ApexTestQueueItem item = [SELECT ParentJobId FROM ApexTestQueueItem WHERE Id=:queueItems[0].Id LIMIT 1];
		System.debug('ParentId '+ item.parentjobid);
		return item.parentjobid;
		}
	 return null;
	 	
	}
	
	
	public static void checkClassStatus(ID jobId) {
		 ApexTestQueueItem[] items = [SELECT ApexClass.Name, Status, ExtendedStatus FROM ApexTestQueueItem
		 								WHERE ParentJobId=:jobId];
		 								
		 for (ApexTestQueueItem item : items) {
		 	String extStatus = item.extendedstatus == null ? '' : item.extendedStatus;
			System.debug(item.ApexClass.Name + ': ' + item.Status + extStatus);
		 }
	}
	
    public static void checkMethodStatus(ID jobId) {
    	ApexTestResult[] results = [SELECT Outcome, ApexClass.Name, MethodName, Message, StackTrace
    									FROM ApexTestResult WHERE AsyncApexJobId=:jobId];
    	Document d = new Document();
    	String regex ='[-,:,\' \']';
    	d.Name = 'TestResult' + String.valueof(Datetime.now()).replaceAll(regex,'');
    	String myContent='';
    	for (ApexTestResult atr : results) {
    		System.debug(atr.ApexClass.Name + '.' + atr.MethodName + ': ' + atr.Outcome);
    		myContent=myContent + atr.ApexClass.Name + '.' + atr.MethodName + ': ' + atr.Outcome + '\n';
    		if (atr.message != null) {
    			System.debug(atr.Message + '\n at ' + atr.StackTrace);
    			myContent = myContent + atr.Message + '\n at ' + atr.StackTrace;
    		}
    	}	
    	d.Body = Blob.valueOf(myContent);
    	d.ContentType = 'text/plain';
    	d.developerName = 'TestResult' + String.valueof(Datetime.now()).replaceAll(regex,'');
		d.FolderId ='00537000000QyVs';
		d.Type = 'txt';
		insert d;
		System.debug('Id of doc ' + d.id);
		sendEmail(d);

   }
   
   
   public static void sendEmail(Document docId){
   		Document doc = [select id, name, body, contenttype, developername, type 
      											from Document where id = :docId.id];
    	Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
    	attach.setContentType(doc.contentType);
    	attach.setFileName(doc.developerName+'.'+doc.type);
    	attach.setInline(false);
    	attach.Body = doc.Body;
    	list<string> emailList = new list<string>{'vijay24805@gmail.com'};
    	String subject ='Daily Test Run Results';       
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
        mail.setToAddresses(emailList);
        mail.setReplyTo(UserInfo.getUserEmail());
        mail.setSenderDisplayName(UserInfo.getUserName());
        mail.setSubject(subject);
        //mail.setEntityAttachments(ids);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
        mail.setPlainTextBody('Test');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
   }
   
   public static void getOrgCodeCoverageInfo(){
	HttpRequest req = new HttpRequest();
	req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
	req.setHeader('Content-Type', 'application/json');
	req.setEndpoint(URL.getSalesforceBaseURL().toExternalForm()+'/services/data/v38.0/tooling/query/?q=Select+id,ApexClassorTrigger.Name,NumLinesCovered,NumLinesUncovered+from+ApexCodeCoverageAggregate');
	req.setMethod('GET');
	Http h = new Http();
	HttpResponse res = h.send(req);  
	system.debug('Response ' + res.getbody());	
	ApexClassCodeCoverageResponse.ApexClassCodeCoverage rec = ApexClassCodeCoverageResponse.parse(res.getbody());
   	system.debug('Records ====> ' + rec.records.size());
   }
   
}