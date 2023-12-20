Public class ContactEmailDistributionInsertQueueable implements Queueable,Database.AllowsCallouts {
    List<Contact_Email_Distribution__c> contactEmailDistributionInsertList = new List<Contact_Email_Distribution__c>();
    public ContactEmailDistributionInsertQueueable(List<Contact_Email_Distribution__c> contactEmailDistributionList){
        contactEmailDistributionInsertList.addAll(contactEmailDistributionList);
    }
    Public void execute(QueueableContext context) {
        try {
            upsert contactEmailDistributionInsertList;  
        } catch(Exception e) {
            System.debug('getMessage-->'+ e.getMessage());
        }
         
    }
}