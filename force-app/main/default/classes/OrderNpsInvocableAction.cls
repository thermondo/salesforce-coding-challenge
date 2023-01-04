
/*******************************************************************************************************
* @Name         NpsCalloutService
* @Author       Anshul Sharma 
* @Date         03/01/2023
* @Description  This class contains Invocable Methods to create and send request to NPS system
*******************************************************************************************/

public  with sharing class  OrderNpsInvocableAction {

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
            //To do : Implement handling for response, we can send status code to flow so that admin can implement additional 
            //        exception handling
            //To do : IMplementation of error handling alerts/messages
            npsResponses.add(response.getbody());
           }
        }
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
                if(npsRequestsWrapper.size()>=30)
                {
                    npsReqeusts.add(JSON.serialize(npsRequestsWrapper));
                    npsRequestsWrapper.clear();
                }

        }
       
        npsReqeusts.add(JSON.serialize(npsRequestsWrapper));
        return npsReqeusts;
    }

}