/**
 * Abstract Connector allows to implement standard method and connects to NPS API with Salesforce
 * @author Shakil Ahmad (shakil.mr.ahmad@gmail.com)
 */

public without sharing abstract class thermondoAbstractConnector {


    @TestVisible protected String accessToken;
    // name of the Custom Setting where the NPS API access token is stored
    private static final String TOKEN_SETTING_NAME = 'NPS API Token';
    private static final String EXCEPTION_MESSAGE = 'Missing NPS API Authorization Token.';    
    // default timeout of POST requests to FUJI REST API (in milliseconds)
    protected final Integer DEFAULT_POST_REQUEST_TIMEOUT = 60000;  
    // default Suppress Apex Null Objects and Fields in for JSON Serialization
    protected final Boolean SUPRESS_APEX_NULL_OBJECTS = true;

    
    // Todo: Validate input data. Prevents the callout if input is invalid.     
    @TestVisible protected abstract void validateInputData();


    public class ThermondoConnectorException extends Exception {}

    /**
     * Currently using Named Credentials Authorization
     * Todo: getAccessToken (Not used for now)     * 
     */
    protected void getAccessToken() {
        Thermondo_Token__c thermondoAccessToken = Thermondo_Token__c.getInstance(TOKEN_SETTING_NAME);
        if(thermondoAccessToken == null) {
            throw new ThermondoConnectorException(EXCEPTION_MESSAGE);
        }
        this.accessToken = thermondoAccessToken.Token__c;
    }
    

    /**
     * Create a HttpRequest object that includes the NPS REST API authorization header.
     */
    @TestVisible
    protected HttpRequest createRequestWithAuthHeader() {
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setHeader('Authorization', 'Bearer ' + this.accessToken);
        return httpRequest;
    }


    /**
     * Send a HTTP request and validate the response and authorization based on the returned status code.
     */
    protected HttpResponse sendHttpRequestAndValidateResponse(HttpRequest request) {
        HttpResponse response = sendHttpRequest(request);
        validateResponseAndAuthorization(response, request);
        return response;
    }

    /**
     * Send a HTTP request.
     */
    protected HttpResponse sendHttpRequest(HttpRequest request) {
        Http http = new Http();
        System.debug('DEBUG: Send request to: ' + request.toString());
        HttpResponse response = http.send(request);
        System.debug('DEBUG: Response: ' + response.getStatusCode() + ' (' + response.getStatus() + ')');
        return response;
    }

    /**
     * Validate the response and authorization based on the returned status code.
     */
    protected void validateResponseAndAuthorization(HttpResponse response, HttpRequest request) {
        if (!isSuccessfulHttpResponse(response)) {
            throw new CalloutException('Invalid response from: ' + request.toString() + ', Response Status: ' + response.getStatusCode()
                + ' (' + response.getStatus() + '), Response Body: ' + response.getBody() + ', Request Body: ' + request.getBody());
        }
    }


    /**
    * Check if the status code of a HTTP respone indicate a success.
    */
    public static Boolean isSuccessfulHttpResponse(HttpResponse response) {
        Integer statusCode = response.getStatusCode();
        return statusCode != null && statusCode == 200;
    }


    // Todo: Constructor (Not used for now)
    public thermondoAbstractConnector() {}
}
