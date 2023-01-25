/*******************************************************************************************************
* @Name         NPSCalloutServiceHelper
* @Author       Aditya Vempati
* @Date         01/25/2023
* @Description  This class contains logic related to NPS service callout and response handler
*******************************************************************************************/
public inherited sharing class NPSCalloutServiceHelper {
    
    private static final String NPSEndpointInfo = 'callout:NPSCredential/orders';
    private static final String NPS_SERVICE = 'NPSService';    
    private static final String UN_KNOWN_ERROR = 'An Unknown Error occured. ';
    
    public static NPSCalloutServiceHelper instance
    {
        get
        {
            if(NULL == instance)
            {
                instance = new NPSCalloutServiceHelper();
            }
            return instance;
        }
        private set;
    }
    
    public void invokeService(List<NPSServiceInput> inputs, List<Order> orders)
    {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(NPSEndpointInfo);
        request.setMethod(IntegrationConstants.POST_METHOD);
        request.setBody(JSON.serialize(inputs));
        request.setHeader(IntegrationConstants.CONTENT_TYPE, IntegrationConstants.APPLICATION_SLASH_JSON);
        HttpResponse response = new Http().send(request);
        handleServiceResponse(request, response, orders);
    }
    
    
    private void handleServiceResponse(HttpRequest request, HttpResponse response, List<Order> orders)
    {
        if(IntegrationConstants.SERVICE_SUCCESS_CODE == response.getStatusCode())
        {
            updateOrderWithServiceResponse(orders, IntegrationConstants.SUCCESS, response.getBody());
        }
        else if(IntegrationConstants.SERVICE_FAILURE_CODE == response.getStatusCode() || IntegrationConstants.INTERNAL_SERVER_ERROR == response.getStatusCode())
        {
            LogEntries.getInstance().logIntegration(NPS_SERVICE,  request.getBody(), response.getBody(), LoggingLevel.ERROR, response.getStatusCode());
            updateOrderWithServiceResponse(orders, IntegrationConstants.FAILURE, response.getBody());
        }
        else
        {
            LogEntries.getInstance().logIntegration(NPS_SERVICE,  request.getBody(), UN_KNOWN_ERROR + response.getBody(), LoggingLevel.ERROR, response.getStatusCode());
            updateOrderWithServiceResponse(orders, IntegrationConstants.FAILURE, response.getBody());
        }
    }
    
    public void updateOrderWithServiceResponse(List<Order> orders, String status, String npsServiceResponse)
    {
        for(Order orderInstance : orders)
        {
            orderInstance.NPS_Integration_Status__c = status;
            orderInstance.NPS_Integration_Response_Info__c = npsServiceResponse;
        }
        update orders;
    }
    
}