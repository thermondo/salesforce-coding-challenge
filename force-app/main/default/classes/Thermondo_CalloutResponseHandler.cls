/*
 * Callout response handler class.
 * 
 * @author Narek Petrosyan
 * @version 1.0
 * @created 30.12.2022
 *  
*/

// TODO COVER THIS IN Thermondo_CalloutService_Test
public without sharing class Thermondo_CalloutResponseHandler {

    public static String handleResponse(HTTPResponse response) {
        
        if (response.getStatusCode() == Thermondo_Constants.SUCCESS) {
            // SUCCESS IS RETURNED
            system.debug(response.getBody());
            // deserialize JSON response
            //Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());                
            // TODO: do something with the response?
            /*
            List<Object> objects = (List<Object>) results.get('objects');                
            for(Object o: objects) {
                System.debug(o);
            }   */       
            return 'SUCCESS'; // TODO: custom label
        } else if (response.getStatusCode() == Thermondo_Constants.BAD_PAYLOAD) {
            return 'BAD_PAYLOAD'; // TODO: custom label
        } else if (response.getStatusCode() == Thermondo_Constants.SERVER_ERROR) {
            return 'SERVER_ERROR'; // TODO: custom label
        } else {
            return 'unsupported error type';
        }                   
    }
}