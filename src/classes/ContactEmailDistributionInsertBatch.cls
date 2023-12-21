public class ContactEmailDistributionInsertBatch implements Database.Batchable<sObject>{
    public List <Contact_Email_Distribution__c> contactEmailDistributionInsertList = new List<Contact_Email_Distribution__c>();
    
    public ContactEmailDistributionInsertBatch(List<Contact_Email_Distribution__c> contactEmailDistributionList){
        contactEmailDistributionInsertList = contactEmailDistributionList;          
    }
    
    public List<SObject> start(Database.BatchableContext BC){
        return contactEmailDistributionInsertList;
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        update scope;
    }
    
    public void finish(Database.BatchableContext BC){
        
    }
}