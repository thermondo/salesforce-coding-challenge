/**
 * @description       : This is the service class for NPS API Callouts
 * 						- takes OrderId, OrderNumber and CustomerEmail as input and sends callout to NPS Service
 * @created by		  : Ravikishore Tekuri	
 * @created on  	  : 14-08-2023
 * @last modified on  : 14-08-2023
**/

global class APICalloutService {
    @future (callout=true)
    WebService static void customerNotification(Id orderId, String orderNumber, String customerEmail){ 
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        request.setEndpoint('https://salesforce-coding-challenge.herokuapp.com/orders');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        
        //possible improvement using named credentials or different method to use or hide potential authentication details
        
        String username = 'tmondo';
        String password = 'Noy84LRpYvMZuETB';
         
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
		        
        request.setHeader('Authorization', authorizationHeader);
        request.setBody('{ "sfId":"'+orderId+'","orderNumber":"'+orderNumber+'","customerEmail":"'+customerEmail+'"}');
        request.setTimeout(120000);
        
        try {
            response = http.send(request);
            //possible improving the resonpse after the customer notification
            /* 
            if(response.getStatusCode()==200){
                Map<String,Object> results = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
                System.debug('The Successful Message : '+ results);
            }
			*/
        } 
        catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(response.toString());
            response.getbody();
        }
    }
}