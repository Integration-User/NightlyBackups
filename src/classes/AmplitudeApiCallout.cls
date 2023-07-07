public class AmplitudeApiCallout {
    
    public static void apiCallout() {
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