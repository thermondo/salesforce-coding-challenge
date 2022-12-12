/**
 * Connects to NPS API with Salesforce
 * @author Shakil Ahmad (shakil.mr.ahmad@gmail.com)
 */

public with sharing class orderSyncNPSAPIConnector extends thermondoAbstractConnector{



    protected override void validateInputData() {
        // TODO: if validation is needed here
    }

    public HttpResponse sendFullfilledOrder(orderSyncRequestModel oRequestModel) {
        validateInputData();
        getAccessToken();
        HttpResponse responseBody = createHttpRequestHttpResponse(oRequestModel);
        return responseBody;
    }


    private HttpResponse createHttpRequestHttpResponse(orderSyncRequestModel oRequestModel) {
        HttpRequest request = createAccountCreationRequest(oRequestModel);
        HttpResponse response = sendHttpRequestAndValidateResponse(request);        
        return response;
    }

    private HttpRequest createAccountCreationRequest(orderSyncRequestModel oRequestModel) {
        HttpRequest request = createRequestWithAuthHeader();
        request.setMethod('POST');
        request.setEndpoint('callout:ThermondoAPI/orders');
        request.setHeader('Content-Type', 'application/json');
        request.setTimeout(DEFAULT_POST_REQUEST_TIMEOUT);
        String requestBodyString = JSON.serialize(oRequestModel,SUPRESS_APEX_NULL_OBJECTS);
        requestBodyString = requestBodyString;
        request.setBody(requestBodyString);
        System.debug('DEBUG: Order Sync Request: ' + request.toString() + ', Body: ' + requestBodyString);
        return request;
    }
}
