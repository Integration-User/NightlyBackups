public class AmplitudeApiCallout {
    
    public static void apiCallout() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String generatedCSVFile ='GSA ID,Budgeted Account Owner, Account Priority, Status\n';
        List<Contact> conList = [Select Id, Account.GSA_ID__c, Account.Budgeted_Account_Owner__c, Account_Priority__c, Contact_Status__c From Contact where Account.Budgeted_Account_Owner__c != null];
        for (Contact con : conList) {
            String fileRow = con.Account.GSA_ID__c + ',' + con.Account.Budgeted_Account_Owner__c+ ',' + con.Account_Priority__c+ ',' + con.Contact_Status__c;
            generatedCSVFile +=  fileRow + '\n';
        }
       // Attachmnet files = [SELECT Id, ParentId, Name, BodyLength, Body, contentType FROM Attachment where id = '00PDM000006Zf532AC'];
        Blob csvBlob = blob.valueOf(generatedCSVFile);
        String csvName = 'lookuptable.csv';
        String separationString = '----WebKitFormBoundary32523523D';
        String header = separationString + '\nContent-Disposition: form-data; name="salesforce_daily1"; filename="' + csvName + '"\nContent-Type: text/csv\n\n';
        String body = EncodingUtil.base64Encode(Blob.valueOf(generatedCSVFile));
        String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header));
        String footer = '\n' + separationString;
        /*while(headerEncoded.endsWith('='))
        {
            header+=' ';
            headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'nn'));
        }*/
        //base64 encoded footer
        String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
        
        Blob bodyBlob = null;
        //last encoded body bytes
        String last4Bytes = body.substring(body.length()-4,body.length());
        //if the last 4 bytes encoded base64 ends with the padding character (= or ==) then re-encode those bytes with the footer
        //to ensure the padding is added only at the end of the body
        if(last4Bytes.endsWith('='))
        {
            Blob decoded4Bytes = EncodingUtil.base64Decode(last4Bytes);
            HttpRequest tmp = new HttpRequest();
            tmp.setBodyAsBlob(decoded4Bytes);
            String last4BytesFooter = tmp.getBody()+footer;   
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+body.substring(0,body.length()-4)+EncodingUtil.base64Encode(Blob.valueOf(last4BytesFooter)));
        }
        else
        {
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+body+footerEncoded);
        }
        request.setBodyAsBlob(bodyBlob);
        String bodyPayload = header + body + footer;
        system.debug('generatedCSVFile-->'+generatedCSVFile);
        
        request.setHeader('Content-Type', 'multipart/form-data; boundary=' + separationString);
        request.setHeader('Content-Length',String.valueof(request.getBodyAsBlob().size()));
        //request.setHeader('Content-Length', String.valueof(bodyPayload));
        request.setEndpoint('https://amplitude.com/api/2/lookup_table/salesforce_daily1');
        request.setMethod('POST');
        //request.setBody(String.valueof(bodyPayload));
        request.setHeader('Authorization', 'Basic ODgyYjMyOTAxNjkyMWU1NDM2OTg1Y2FlZDJhOTY3ZWE6MzAzNzVjYmI1Y2Y2MGZlMDcxYzc4NTYwNGI5MzEwZjU=');
        system.debug('request-->'+request);
        system.debug('bodyPayload-->'+String.valueof(bodyPayload));
        request.setTimeout(60000);
        HttpResponse response = http.send(request);
        system.debug('response-->'+response);
        // Parse the JSON response
        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
            
            Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
            csvAttachment.setFileName('OpportunityLineItemLeapYearRecords.csv');
            csvAttachment.setBody(blob.valueOf(generatedCSVFile));
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[]{'mgupta@greenstreet.com'};
                String subject = 'OpportunityLineItemLeapYearRecords CSV';
            email.setSubject(subject);
            email.setToAddresses(toAddresses);
            email.setPlainTextBody('OpportunityLineItemLeapYearRecords CSV');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment});
            Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
        } else {
            System.debug(response.getBody());
        }
    }
}