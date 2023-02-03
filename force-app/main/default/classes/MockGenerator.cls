 @isTest
 global class MockGenerator implements HttpCalloutMock {
    
        global HTTPResponse respond(HTTPRequest req) {
            System.assertEquals('https://salesforce-coding-challenge.herokuapp.com', req.getEndpoint());
            System.assertEquals('POST', req.getMethod());
            
     
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"email": "response@gmail.com", "orderNumber": "34546565"}');
            res.setStatusCode(201);
            return res;
        }
    }