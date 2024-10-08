@isTest
public class OpportunityOwnerChangeSchedulerTest {
    @testSetup static void loadData() {
        insert new Trigger_Control_Setting__c(SetupOwnerId=UserInfo.getOrganizationId(), Account__c=true);

        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Organization_Account').getRecordTypeId();

		Account acc = new Account();
        acc.Name = 'Test Account 1';
        acc.RecordTypeId = accRecordTypeId;
        Insert acc;

        Contact cont = new Contact();
        cont.AccountId = acc.Id;
        cont.FirstName = 'FName';
        cont.LastName = 'LName';
        cont.Email = 'test@email.com';
        cont.Phone = '9876543210';  
        cont.Contact_Status__c = 'Active';
        insert cont;
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Existing_Business').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = oppRecordTypeId;
        opp.Name = 'OppTest 1';
        opp.CloseDate = system.today();
        opp.StageName = '2 - Conducting Needs Analysis';
        opp.CurrencyIsoCode = 'USD';
        opp.AccountId = acc.Id;
        opp.Sectors_Sold__c = 'All Sectors';
        opp.Sales_Type__c = 'New';
        opp.Department__c = 'Corporate';
        opp.Class__c = 'Corporate';
        opp.Products__c ='API';
        Insert opp;
    }
    @isTest static void testAccountOwner() {
        Profile p2 = [SELECT Id FROM Profile WHERE Name='Standard User'];
        user userRecord1 = new user();
        userRecord1.LastName ='AccOwner' ;
        userRecord1.Username ='testUseracc@user.com' ;
        userRecord1.Email = 'vendor.sfdc15@user.com';
        userRecord1.Alias = 'tsusera';
        userRecord1.TimeZoneSidKey = 'America/Los_Angeles';
        userRecord1.LocaleSidKey = 'en_US';
        userRecord1.EmailEncodingKey = 'UTF-8';
        userRecord1.LanguageLocaleKey = 'en_US';
        userRecord1.ProfileId = p2.Id;
        insert userRecord1;
        Test.startTest();
        Account acc = [Select Id, OwnerId FROM Account WHERE Name = 'Test Account 1'];
        Opportunity opp = [Select Id, OwnerId From Opportunity Where AccountId = :acc.Id]; 
        opp.OwnerId = acc.ownerId;
        Update opp;
        
        OpportunityOwnerChangeScheduler scheUpdateOpp = new OpportunityOwnerChangeScheduler(); 
        String sch ='0 48 * * * ?'; 
        System.schedule('Schedule to update Opp Owner', sch,scheUpdateOpp);
        Test.stopTest();
        Opportunity opp1 = [Select Id, OwnerId, Account.ownerId From Opportunity Where AccountId = :acc.Id]; 
        System.assertEquals(acc.OwnerId, opp1.Account.ownerId);
    }
    @isTest static void testContactOwner() {
        Profile p2 = [SELECT Id FROM Profile WHERE Name='Standard User'];
        user userRecord1 = new user();
        userRecord1.LastName ='AccOwners' ;
        userRecord1.Username ='testUseracc1@user.com' ;
        userRecord1.Email = 'vendor.sfdc16@user.com';
        userRecord1.Alias = 'tsuseras';
        userRecord1.TimeZoneSidKey = 'America/Los_Angeles';
        userRecord1.LocaleSidKey = 'en_US';
        userRecord1.EmailEncodingKey = 'UTF-8';
        userRecord1.LanguageLocaleKey = 'en_US';
        userRecord1.ProfileId = p2.Id;
        userRecord1.Team__c = 'Enterprise';
        insert userRecord1;
        Test.startTest();
        Contact con = [Select Id, OwnerId FROM Contact LIMIT 1];
        con.OwnerId = userRecord1.Id;
        Update con;
        
        UpdateContactOwnerWithAccountOwner scheUpdateCon = new UpdateContactOwnerWithAccountOwner(); 
        String sch ='0 48 * * * ?'; 
        System.schedule('Schedule to update Opp Owner', sch,scheUpdateCon);
        Test.stopTest();
    }
    @isTest static void testOpportunityOwnerChangeBatch() {
        Database.executeBatch(new OpportunityOwnerChangeBatch(true), 1);
    }
}