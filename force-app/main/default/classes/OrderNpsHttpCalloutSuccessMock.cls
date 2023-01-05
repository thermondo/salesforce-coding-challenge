@isTest
public  class OrderNpsHttpCalloutSuccessMock implements HttpCalloutMock {
    
    public HTTPResponse respond(HTTPRequest request) {
        // Fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('[{"SUCCESS"}]');
        response.setStatusCode(200);
        return response; 
    }

    
}