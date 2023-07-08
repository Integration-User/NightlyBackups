public class AmplitudeApiCallout {
    
    public static void apiCallout() {
        String generatedCSVFile ='GSA ID,Budgeted Account Owner, Account Priority, Status\n';
        List<Contact> conList = [Select Id, Account.GSA_ID__c, Account.Budgeted_Account_Owner__c, Account_Priority__c, Contact_Status__c From Contact where Account.Budgeted_Account_Owner__c != null];
        for (Contact con : conList) {
            String fileRow = con.Account.GSA_ID__c + ',' + con.Account.Budgeted_Account_Owner__c+ ',' + con.Account_Priority__c+ ',' + con.Contact_Status__c;
            generatedCSVFile +=  fileRow + '\n';
        }
        Blob csvBlob = blob.valueOf(generatedCSVFile);
        String csvName = 'Lookup Table - Amplitude.csv';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint('https://amplitude.com/api/2/lookup_table/salesforce_daily');
        request.setMethod('POST');
        request.setHeader('Authorization', 'Basic ODgyYjMyOTAxNjkyMWU1NDM2OTg1Y2FlZDJhOTY3ZWE6MzAzNzVjYmI1Y2Y2MGZlMDcxYzc4NTYwNGI5MzEwZjU=');
        // Set the body as a JSON object
        //request.setBody('{"name":"savage crocodile"}');
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
    }
}