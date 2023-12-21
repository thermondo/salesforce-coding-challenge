public with sharing class OrderDataToNPSHandler {
   
    @InvocableMethod(Callout='true' Label='Send Order Data to NPS' Description='Sends orders bill data to NPS')
    Public static void sendOrderData(List<Id> orderIds){
        try{   
       	    List<Order> listOfOrdersToSend=new OrderSelector().selectByIds(orderIds);
            If(listOfOrdersToSend.isEmpty()){
                //log errors depends on requirement
            }
            List<OrderDataWrapper> listOfOrderDataWrapperToSend=OrderService.buildOrderDataWrapperFromOrders(listOfOrdersToSend);
            NPSCallouts.postOrderDataToNps(listOfOrderDataWrapperToSend);
        }catch(Exception ex){
            //log excpetions
        }
    }
}