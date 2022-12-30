/*
 * Callout service class.
 * 
 * @author Narek Petrosyan
 * @version 1.0
 * @created 30.12.2022
 *  
*/

public without sharing class Thermondo_CalloutService {
    
    public static HTTPResponse doCallout(String payload) {
                
        HttpRequest request = new HttpRequest();
        
        // TODO: better with named credentials e.g. request.setHeader('key', '{!$Credential.Password}');
        
        request.setEndpoint('https://salesforce-coding-challenge.herokuapp.com/orders');
        request.setHeader('Content-Type', 'application/json');
        // THIS IS ONLY FOR TEST PURPOSES
        request.setHeader('Username', 'test123');
        request.setHeader('Password', '12345');
        request.setBody(payload);
        request.setMethod('POST');
        Http http = new Http();
        HttpResponse response = http.send(request);        
        
		return response;      
    }
}