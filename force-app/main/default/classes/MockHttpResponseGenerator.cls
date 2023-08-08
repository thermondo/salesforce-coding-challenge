/**
 * Test class Mock generator for NPS REST API service
 */
@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('callout:NPS_API_Callout/orders', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"sfId": "8015E000003LfJXQAT","orderNumber": "008","customerEmail": "customerAddress@example.com"}');
        res.setStatusCode(200);
        return res;
    }
}