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
                
        //request.setEndpoint('https://salesforce-coding-challenge.herokuapp.com/orders');
        
        // don'hard code usernames or passwords and push to a repository
        // this was just for testing
        //request.setHeader('Username', 'tmondo');
        //request.setHeader('Password', '12345');
        
        // named credentials to the rescue
        request.setEndpoint('callout:ThermondoNC/orders');
        request.setHeader('Content-Type', 'application/json');

        request.setBody(payload);
        request.setMethod('POST');
        Http http = new Http();
        HttpResponse response = http.send(request);        
        
		return response;      
    }
}