@isTest
public with sharing class GenericHttpCalloutMock implements HttpCalloutMock
{
    
    private Integer code;
    String status;
    private String message;
    private Map<String, String> responseHeaders;
    
    public GenericHttpCalloutMock(Integer code, String status, String reqBody, Map<String, String> headers)
    {
        this.code = code;
        this.status = status;
        this.message = reqBody;
        this.responseHeaders = headers;
    }
    
    public HTTPResponse respond(HTTPRequest request)
    {
        HttpResponse response = new HttpResponse();
        if (responseHeaders != null)
        {
            for (String key : responseHeaders.keySet())
            {
                response.setHeader(key, responseHeaders.get(key));
            }
        }
        response.setBody(message);
        response.setStatusCode(code);
        return response;
    }
    
}