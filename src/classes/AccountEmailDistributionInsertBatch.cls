public class AccountEmailDistributionInsertBatch implements Database.Batchable<sObject>{
    public List <Account_Email_Distribution__c> accountEmailDistributionInsertList = new List<Account_Email_Distribution__c>();
    
    public AccountEmailDistributionInsertBatch(List<Account_Email_Distribution__c> accountEmailDistributionList){
        accountEmailDistributionInsertList = accountEmailDistributionList;          
    }
    
    public List<SObject> start(Database.BatchableContext BC){
        system.debug('--accountEmailDistributionInsertList-->'+accountEmailDistributionInsertList);
        return accountEmailDistributionInsertList;
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        system.debug('--scope-->'+scope);
        Database.upsert(scope, false);
    }
    
    public void finish(Database.BatchableContext BC){
    }
}