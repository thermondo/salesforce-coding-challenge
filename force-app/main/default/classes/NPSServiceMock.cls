@isTest
public with sharing class NPSServiceMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"sfId": "8015E000003LfJXQA0","orderNumber": "007","customerEmail": "customerAddress@example.com"}');
        res.setStatusCode(200);
        return res;
    }    
}