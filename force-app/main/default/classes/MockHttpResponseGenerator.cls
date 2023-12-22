/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This apex class is used to genrate a mock response
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Nitish Bhardwaj
* @version        1.0
* @created        2023-12-21
* @modified       2023-12-21
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
@isTest 
public class MockHttpResponseGenerator implements HttpCalloutMock {
    protected Integer code;
    protected String bodyAsString;
    
    public MockHttpResponseGenerator(Integer code, String bodyAsString) 
    {
        this.code = code;
        this.bodyAsString = bodyAsString;
        
    }
    
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse resp = new HttpResponse();
        resp.setStatusCode(code);
        resp.setBody(bodyAsString);
        return resp;
    }
}