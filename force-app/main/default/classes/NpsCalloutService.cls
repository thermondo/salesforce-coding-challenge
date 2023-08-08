/**
 * @description       : REST API service callout class
 * @author            : @LikithKailas.SFDoc
 * @group             : 
 * @last modified on  : 08-08-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class NpsCalloutService {

    static final String ERROR_TYPE_URI = 'callout:NPS_API_Callout/orders';
    /**
     * Erros can predefined and set when necessary and returned to UI
     **/
    public static final Map<Integer, ApiError> errors = new Map<Integer, NpsCalloutService.ApiError>{
            1 => new ApiError(1, 500, 'Somthing went totaly wrong', 'Our last Fallback of Error handling ...'),
            2 => new ApiError(2, 400, 'Wrong Version', 'You use an invalid API-Version ...'),
            3 => new ApiError(3, 400, 'Wrong Path', 'Provide a Valid Path...'),
            4 => new ApiError(4, 400, 'Callout failed', ' ...')
    };
    /**
     * @param jsonReqBody
     *
     * Rest request to send the order details serialized string
     * @return
     */
    public static HttpResponse makePostCallout(String jsonReqBody) {
        Http http = new Http();

        //create HTTP Request
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:NPS_API_Callout/orders');
        System.debug('Endpoint: ' + 'callout:NPS_API_Callout/orders');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');

        // Set the body as a JSON object
        request.setBody(jsonReqBody);
        System.debug('RequestBody: ' + jsonReqBody);
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        return response;
    }

    //general error handling wrapper class
    public class ApiError {
        public ApiError(Integer errorCode, Integer httpStatusCode, String title, String details) {
            this.title = title;
            this.type = ERROR_TYPE_URI + errorCode;
            this.status = httpStatusCode;
            this.detail = details;
            this.instance = System.Url.getSalesforceBaseUrl().toExternalForm();
        }

        private String type { get; set; }
        private String title { get; set; }
        private Integer status { get; set; }
        private String detail { get; set; }
        private String instance { get; set; }
        private String requestBody { get; set; }
    }

    public static void setErrorResponse(ApiError error) {
        RestContext.response.statusCode = error.status;
        error.requestBody = EncodingUtil.base64Encode(RestContext.request.requestBody);
        RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(error));
    }
}