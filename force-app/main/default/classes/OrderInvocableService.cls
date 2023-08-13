/**
 * @description       : This is the service class that invokes whenever an Order got fulfilled
 * 						- takes OrderIds as input and sends the necessary parameters to API callout service layer
 * @created by		  : Ravikishore Tekuri	
 * @created on  	  : 14-08-2023
 * @last modified on  : 14-08-2023
**/

public class OrderInvocableService {
	
    @InvocableMethod (label='Order NPS Callout')
    public static void invokeOrderNPSCallout(List<Id> fulfilledOrders) {
		
        List<Order> ordersList = new OrderSelector().selectOrdersWithBillToContactEmails(new Set<Id>(fulfilledOrders));
        if (ordersList.size() == 0) return;
        
        for(Order order: ordersList){
            APICalloutService.customerNotification(order.Id, order.OrderNumber, order.BillToContact.Email);
        }
    }
}