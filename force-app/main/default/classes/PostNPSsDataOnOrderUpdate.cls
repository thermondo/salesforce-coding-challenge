public with sharing class PostNPSsDataOnOrderUpdate {

    @InvocableMethod
    public static List<String> MakeCallout(List<ID> ids){
        
        List<String> outcomeMsg = new List<String>();
        
        List<OrderWrapper> wrapList = new List<OrderWrapper>();
        Integer counter = 0;
        List<Order> ordList = [SELECT Id,OrderNumber,BillToContact.Email FROM Order WHERE Id IN :ids];
        List<Order> batchList = new List<Order>();
        for(Order ord : ordList){
            counter++;
            batchList.add(ord);
            wrapList.add(new OrderWrapper(ord));
            if(counter == 30 || counter == ordList.size())
            { 
             outcomeMsg.add(SendRequest(wrapList));
             counter = 0;
             batchList.clear();
             wrapList.clear();
            }
        }
        
        return outcomeMsg;
    }
    
    public static String SendRequest (List<OrderWrapper> wrapperList){
        String opMessage = '';
        try {  
            string endpoint = 'callout:ThermondoCredentials';
            string method = 'POST';
            
            // check to ensure a callout can be performed using the Limits class.This is 100 callouts per execution
            if (Limits.getCallouts() >= Limits.getLimitCallouts()) {
                opMessage = 'Maximum number of callouts has been reached.';   
            } else {   
                HttpRequest req = new HttpRequest();
                HttpResponse res = new HttpResponse();
                Http h = new Http();
                
                req.setEndpoint(endpoint);
                req.setMethod(method);
                req.setTimeout(120000);
                
                req.setHeader('Accept', '*/*');
                req.setHeader('Content-Type', 'application/json');
                String JsonString = JSON.serialize(wrapperList);
                req.setBody(JsonString);
                if(!Test.isRunningTest()){
                    res = h.send(req);
                } else{
                    MockHttpResponseGenerator mc = new MockHttpResponseGenerator();
                    res = mc.respond(req);
                }
                if ((res.getStatusCode() == 200) && res.getBody() != null) {
                    opMessage = 'Success!';
                } else if (res.getStatusCode() == 400){
                    opMessage = res.getStatusCode() + ' ' +'BAD_PAYLOAD';
                } else if (res.getStatusCode() == 500){
                    opMessage = res.getStatusCode() + ' ' +'SERVER_ERROR';
                }
            }
        } catch (exception e) {
            opMessage = 'Error: An exception has been encountered while calling out to Integration:  ' + e.getMessage();
        }
        return opMessage;
    }

    public class OrderWrapper {
        String sfId;
        String orderNumber;
        String customerEmail;
        
        public OrderWrapper(Order order) {
            this.sfId = order.Id;
            this.orderNumber = order.OrderNumber;
            this.customerEmail = order.BillToContact.Email;
        }
    }

}