
/*******************************************************************************************************
* @Name         NpsCalloutService
* @Author       Anshul Sharma 
* @Date         03/01/2023
* @Description  This class contains Invocable Methods to create and send request to NPS system
*******************************************************************************************/

public  with sharing class  OrderNpsInvocableAction {
    private Static final Integer NPS_REQUEST_LIMIT = 30 ;

    @InvocableMethod(
        label = 'Send Request to NPS Service'
        description = 'This method makes a callout to NPS service'
    )
    public static List<String> sendNpsRequest( List<Id> orderIds ) {
      
        List<String> npsResponses = new List<String>();
    
        if(orderIds.isEmpty())
        {
            return new List<String>{'Missing Order Id'};
        }
        else{
            
           list<String> npsRequests = createNpsRequest(orderIds);
           for(String npsRequest : npsRequests){
           
            HttpResponse response = NpsCalloutService.sendRequest(npsRequest);
             /*

             * To do : Implement handling for response, we are send status to flow so that admin can implement additional 
                       handling
			 * To do : Implementation of error handling alerts/messages 
                       Admin can maitain a custom metadatatype to store the mapping of status code and error/alert message 
                       and can be added on flow level.

            */
             npsResponses.add(response.getBody());
           }
        }


        /* TO DO
        Managing the return value and status of NPS callout
         -Returning message body , can be stored on the record in a field 'NPSCalloutStatus__c' to mark if NPS call was succuess or not
         -This 'NPSCalloutStatus__c' field can be used to ensure no duplicat callout to the NPS System
         -In case of any issues , Salesforce Admin can retry NPS callout manually based on the value of 'NPSCalloutStatus__c'
        */
        return npsResponses;
    }



    private static List<String> createNPSRequest(List<Id> orderIds){

        List<String> npsReqeusts = new List<String>();
        List<NpsServiceRequestWrapper> npsRequestsWrapper = new List<NpsServiceRequestWrapper>();
    
    
        for(Order orderRecord :[SELECT Id, Account.PersonEmail, OrderNumber From Order Where Id IN :orderIds ]){
                NpsServiceRequestWrapper npsRequest = new NpsServiceRequestWrapper();
                npsRequest.sfId = orderRecord.Id;
                npsRequest.orderNumber = orderRecord.OrderNumber;
                npsRequest.customerEmail = orderRecord.Account.PersonEmail;
                npsRequestsWrapper.add(npsRequest);
                if(npsRequestsWrapper.size()>= NPS_REQUEST_LIMIT)
                {
                    npsReqeusts.add(JSON.serialize(npsRequestsWrapper));
                    npsRequestsWrapper.clear();
                }

        }
       
        npsReqeusts.add(JSON.serialize(npsRequestsWrapper));
        return npsReqeusts;
    }

}