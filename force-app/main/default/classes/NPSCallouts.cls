public inherited sharing class NPSCallouts {
    //nps service named credentials 
    private static final string NPS_ENDPOINT='callout:NpsOrderThermondo';
     /**
     * @description: Posts order data to NPS in batches, updates failed records.
     * @param listOfAllOrderDataWrappersToPost List of order data wrappers to post.
     **/
    public static void postOrderDataToNps(List<OrderDataWrapper> listOfAllOrderDataWrappersToPost ){
        //get maximum allowed order data per api call
        Integer numberOfOrdersAllowedForApi=30;//get from config  
        Integer totalNumberOfOrderToSendNps=listOfAllOrderDataWrappersToPost.size();           
        List<OrderDataWrapper> listOfFailedOrdersToUpdate=new List<OrderDataWrapper>();
        String relativeEndPointString='/Orders';//this should be added in custom metadata 
        //split Order data as batches based on Api limits
        List<List<OrderDataWrapper>> orderBatchesToSendNps= new List<List<OrderDataWrapper>>();          
        List<OrderDataWrapper> orderBatchToSendApi=new List<OrderDataWrapper>();
        for(Integer orderIndex=0;orderIndex<totalNumberOfOrderToSendNps;orderIndex++){ 
            orderBatchToSendApi.add(listOfAllOrderDataWrappersToPost[orderIndex]);
            if(orderBatchToSendApi.size()==30 || orderIndex==totalNumberOfOrderToSendNps-1){          
                orderBatchesToSendNps.add(orderBatchToSendApi);
                orderBatchToSendApi.clear();
            }
        }
        for(List<OrderDataWrapper> orderBatch:orderBatchesToSendNps){
           HttpResponse httpsRes=makePostCallout(JSON.serialize(orderBatch),relativeEndPointString);
           if(httpsRes!=null && httpsRes.getStatusCode()!=200){
               listOfFailedOrdersToUpdate.addall(orderBatch);
           }
        }  
        //no failed records
        if(listOfFailedOrdersToUpdate.isEmpty()){
            return;
        }
        OrderService.updateNpsFailedRecords(listOfFailedOrdersToUpdate);
    }
  /** @description: generic POST callout  to NPS 
     * @param : requestBody request body to send nps endpoint
     * @param : relativeEndPointString relative endpoint to hit exact api
     * @param : mapOfCustomHeaders request body to send nps endpoint
     * @return : HttpResponse response from the NPS.
     **/
    public static HttpResponse makePostCallout(String requestBody,String relativeEndPointString){
        HttpRequest httpReq=new HttpRequest();
        HttpResponse httpRes;
        Http http = new Http();
		httpReq.setHeader('Content-Type', 'application/json;charset=UTF-8');
        httpReq.setBody(requestBody);
        httpReq.setMethod('POST');    
        httpReq.setEndpoint(NPS_ENDPOINT+relativeEndPointString); 
        try{
            httpRes=http.send(httpReq);
        }catch(CalloutException ex){
            //return message callout to NPS is failed Should we continue the transaction or block the transaction 
            //log the message using publish immediate event
        }
        return httpRes;
    }

}