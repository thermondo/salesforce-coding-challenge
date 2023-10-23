public with sharing class NPSOrderLocator {
   
    @InvocableMethod(label='Place Orders to NPS' description='Sends Order Ids to NPS Order Processor Batchable to initalize and send to NPS service' callout = 'true')
    public static List<NPSServiceResult> initializeOrders(List<Id> orderIds){
        
        List<NPSServiceResult> output = new List<NPSServiceResult>();
        NPSServiceResult result = new NPSServiceResult();

        //Option1: Call Service directly from Invocable Method (sync solution)        
        try {
            List<Order> orderList = [SELECT Id, Status, OrderNumber, BillToContact.Email FROM Order WHERE Id IN :orderIds WITH USER_MODE];                
            NPSService npsService = new NPSService();
            HttpResponse response = npsService.insertOrders(orderList);      
            if(response.getStatusCode() == 200){
                result.success = true;
            }            
            result.message = response.getBody();
        } catch (Exception ex) {            
            result.success = false;
            result.message = ex.getMessage();            
        }
        
        output.add(result);
        return output;
        
        
        

        //Option2: Call batchable apex with batchsize of 30 (async solution)
        //To activate option2, the invocable method return object needs to be updated. and email service needs to be added to inform admin
        //NPSOrderProcessorBatchable orderProcessorBatchable = new NPSOrderProcessorBatchable(orderIds);
        //Database.executeBatch(orderProcessorBatchable, 30);
        
    }
    public class NPSServiceResult{    
        @InvocableVariable    
        public Boolean success;      
        @InvocableVariable  
        public String message;
    }
}