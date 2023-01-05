@isTest
public  class OrderNpsHttpCalloutFailMock implements HttpCalloutMock {
    
    public HTTPResponse respond(HTTPRequest request) {
        // Fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('[{"SERVER_ERROR"}]');
        response.setStatusCode(500);
        return response; 
    }
}