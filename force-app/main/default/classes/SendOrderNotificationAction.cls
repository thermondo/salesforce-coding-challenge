public with sharing class SendOrderNotificationAction {
    
    @InvocableMethod
    public static List <Results> execute (List<Requests> requestList) {

        Set<Id> syncIds = new Set<Id>();
        Set<Id> asyncIds = new Set<Id>();
        
        for(Requests req : requestList){
            if(req.isAsyncExecution)
            {
                for(String id : req.orderIds){
                    asyncIds.add(Id);
                }
                
            }
            else
            {
                for(String id : req.orderIds){
                    syncIds.add(id);
                }
                
            }
        }

        if(!asyncIds.isEmpty()){
            System.enqueueJob(new SendOrderNotificationQueable(asyncIds));
        }

        Results results = new Results();

        if(!syncIds.isEmpty()){
            ISendOrderNotificationApi sendOrderNotificationApi = new SendOrderNotificationApiFactory().getSendOrderNotificationApi();
            SendOrderNotificationService SendOrderNotificationService = new SendOrderNotificationService(syncIds, sendOrderNotificationApi);
            SendOrderNotificationService.Results resultsService = SendOrderNotificationService.sendOrderNotification();
            results.sucessOrdersId = new List<Id>(resultsService.sucessOrdersId);
            results.errorOrdersId = new List<Id>(resultsService.errorOrdersId);
        }

        List<Results> resultsList = new List<Results>();

        for(Requests requests : requestList){
            resultsList.add(results);
        }

        return resultsList;    
    }

    public class Requests {
        @InvocableVariable(label='Records for Input' description='Order Ids')
        public List<String> orderIds;
        @InvocableVariable(label='IsAsyncExecution' description='¿Has to execute in async process?')
        public Boolean isAsyncExecution;
    }

    public class Results {
        @InvocableVariable(label='Sucess Order Ids Notification')
        public List<String> sucessOrdersId;
        @InvocableVariable(label='Error Order Ids Notification')
        public List<String> errorOrdersId;
    }
}