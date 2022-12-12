/**
 * Invocable Method & Annotations for sending Order's Data from Salesforce to Thermondo NPS API
 * @author Shakil Ahmad (shakil.mr.ahmad@gmail.com)  
 */


public with sharing class syncOrdersToNSPService {

    @InvocableMethod(label='synchronize Order Data to Thermondo NPS API' description='Returns the list of orderSyncResult after the REST API Call to NPS Service')
    public static List<orderSyncResult> syncOrders(List<orderSyncRequest> orderSyncRequests) {

        System.debug(orderSyncRequests);


        List<orderSyncResult> orderSyncResults = new List<orderSyncResult>();
        for(orderSyncRequest orderRequest : orderSyncRequests){
            orderSyncResult result = prepareRequestGETHttpResponse(orderRequest);
            orderSyncResults.add(result);
        }

        return orderSyncResults;
    }



     /**
     * Prepare Request Body
     */
    private static orderSyncResult prepareRequestGETHttpResponse(orderSyncRequest orderRequest) {
        orderSyncResult result;
        try {
            Order order = orderRequest.order;            
            orderSyncRequestModel oRequestModel = orderSyncMapper.mapOrderToOrderSyncModel(order);

            orderSyncNPSAPIConnector oOrderSyncNPSAPIConnector = new orderSyncNPSAPIConnector();
            HttpResponse httpResponse = oOrderSyncNPSAPIConnector.sendFullfilledOrder(oRequestModel);
            String responseBody = httpResponse.getBody();

            System.debug(responseBody);


            /**
             * Thermondo NPS API returns only System Codes (200,400,500)
             * Todo: orderSyncModel.parse(responseBody) to accomodate meanigful response. e.g. Message to log in Salesforce Record or Chatter.             * 
             */
            orderSyncModel oSyncModel = orderSyncModel.parse(responseBody); 
            result = new orderSyncResult();
            result.isSuccess        = true;
            result.errorMessage     = '';
            result.sfId  = String.valueOf(oSyncModel.sfId);

        } catch (Exception exc) {
            result = new orderSyncResult();
            result.isSuccess        = false;
            result.errorMessage     = exc.getMessage();
            result.sfId  = null;            
            System.debug(exc.getStackTraceString());
        }

        return result;
    }



    /**
     * 
     */
    public class orderSyncResult {
        @InvocableVariable(label='Success / Failuer Status' description='Determines whether the response from API Call was success or failer' required=true)
        public Boolean isSuccess;

        @InvocableVariable(label='Error Message' description='Records error message received from API Call' required=true)
        public String errorMessage;

        @InvocableVariable(label='sfId' description='The sfId' required=true)
        public String sfId;
    }

    /**
     * 
     */
    public class orderSyncRequest {
        @InvocableVariable(label='Records for Input' description='Order Record for Serilization and POST to NPS Service' required=false)
        public Order order;
    }
}
