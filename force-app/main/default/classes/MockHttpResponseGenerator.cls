/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This apex class is used  to generate mock HTTP Callout.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Saurao Londhekar
* @modifiedBy     Saurao Londhekar
* @maintainedBy   Saurao Londhekar
* @version        1.0
* @created        2023-10-23
* @modified       2023-10-23
* @systemLayer    HTTP MOCK
* @see            ????
* @see            ????
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.0            Saurao Londhekar
* 2023-08-07      This is a mock test class used to generate mock HTTP Callout.
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
@isTest
public class MockHttpResponseGenerator implements HttpCalloutMock {
    
    
    /**
    * @description : Implement this interface method
    * @author Rohit | 08-07-2023 
    * @param req 
    * @return HTTPResponse 
    **/
    public Integer statusCode;
    public MockHttpResponseGenerator(Integer strStatusCode){
        this.statusCode = strStatusCode;
}
    public HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
    
        Assert.areEqual('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        //res.setHeader('Content-Type', 'application/json');
        if(statusCode == 200){
        	res.setBody('{"SUCCESS"}');
        	res.setStatusCode(statusCode);
			system.debug('res code--'+res.getStatusCode());         
        }
        else{
            res.setStatusCode(statusCode);
            res.setBody('{"BAD PAYLOAD"}}');
        }
        return res;
    }
}