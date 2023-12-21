@isTest
public class NpsMockResponseGeneratorTest implements HttpCalloutMock {
    Public HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('callout:NpsOrderThermondo'+'/Orders', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"sfId": "8015E000003LfJXQA0","orderNumber": "007","customerEmail":"customerAddress@example.com"}');
        res.setStatusCode(200);
        return res;
    }

}