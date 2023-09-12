@isTest
public class MockHttpResponseGenerator implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('[ { "sfId" : "8011y000001yKpdAAE", "orderNumber" : "00000101", "customerEmail" : "callout@test.com" } ]');
        response.setStatusCode(200);
        return response; 
    }
}