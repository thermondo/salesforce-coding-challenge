/**
 * @description       : This is a Mocck HttpResponse Generator for Test Classes
 * @author            : sengarlavanya@gmail.com
 * @created on        : 08-10-2023
**/
@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    //The Mock Http Response Generator can return different response
    private static String typeOfCall;
    //To pass the supplier invoice id for the rossum mock callout
    private static String supplierInvoiceId;

    global MockHttpResponseGenerator(String type) {
        typeOfCall = type;
    }
    

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        String body;
        Integer statusCode;
        String status;
        
        if(typeOfCall == 'sendOrderToNPSSuccess'){
            body = '"[{\"sfId\":\"8015E000003LfJXQA0\",\"orderNumber\":\"007\",\"customerEmail\":\"customerAddress@example.com\"}]"';
            statusCode = 200;
        }
        
        if(typeOfCall == 'sendOrderToNPSFailure'){
            body = '"[{\"sfId\":\"8015E000003LfJXQA0\",\"orderNumber\":\"007\",\"customerEmail\":\"customerAddress@example.com\"}]"';
            statusCode = 400;
        }
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(body);
        res.setStatusCode(statusCode);
        if(status != null) {
            res.setStatus(status);
        }
        return res;
    }   
}