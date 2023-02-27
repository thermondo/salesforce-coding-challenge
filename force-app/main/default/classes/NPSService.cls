//** This class does API callout to NPS services to send order details
public class NPSService { 
    @InvocableMethod(label='Send orders' description='Send order to external system')
    public static void sendOrdersToNPS(List<id> orderids){
        try {
            ordersDTO ordersToSend = new ordersDTO();
            if(orderids.size() >0 && orderids!= null)
            {
                List<Order> orders = [select id, orderNumber, Account.PersonEmail__c from Order where id =:orderids ];
                if (orders.size() >0  && orders!=null) {
                    ordersToSend.method = 'POST';
                    ordersToSend.endpoint ='callout:tmondo/orders';
                    ordersTosend.requestBody = preparePayload(orders);
                    calloutService.sendOrders(json.serialize(ordersToSend));
                   }
            }  
        } catch (Exception e) {
            // Capture exception details
            System.debug('Exception in line number :: '+e.getLineNumber());
            System.debug('Error :: '+e.getMessage());
            System.debug('StackTracing :: '+e.getStackTraceString());
        }
    }  
    public static set<ordersDTO.RequestBody> preparePayload(List<Order> orders){
        set<ordersDTO.RequestBody> dtoset = new set<ordersDTO.RequestBody>();
        for(order o : orders){
            ordersDTO.RequestBody reqbody = new ordersDTO.RequestBody();
            reqbody.sfId = o.id;
            reqbody.orderNumber = o.orderNumber;
            reqbody.customerEmail = o.Account.PersonEmail__c;
            dtoset.add(reqbody);
        }
        return dtoset;
    }
}