/**
 * @description       : 
 * @author            : @LikithKailas.SFDoc
 * @group             : 
 * @last modified on  : 08-06-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class NpsCalloutService {

    public static HttpResponse makePostCallout(String jsonReqBody){
        Http http = new Http();

        //create HTTP Request
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:NPS_API_Callout/orders');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');

        // Set the body as a JSON object
        request.setBody(jsonReqBody);
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
        }else {
        System.debug(response.getBody());
        }
    return response;
 }
}