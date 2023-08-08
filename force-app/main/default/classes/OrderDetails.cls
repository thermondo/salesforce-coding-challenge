/**
 * @description       : To fetch Order that has status 'fullfilled' and send the order details to NPS Service
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-08-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class OrderDetails {

    /**
     * @param orderIds get orders that are 'Fulfilled'
     * @description Invocable method called from OrderTrigger Flow
     */
    @InvocableMethod(label='Send Orders' description='sends the specified order to NPS service')
    public static void fetchAndSerializeOrderDetails(List<String> orderIds) {
        try {
            List<OrderDetails.CustomOrder> custOrders = new List<OrderDetails.CustomOrder>();
            OrderDetails.CustomOrder custOrd;
            List<Order> orders;
            List<String> accIds = new List<String>();
            Map<String, String> accountToContactEmailMap = new Map<String, String>();

            //fetch all the orders that are passed from the flow and store its accounts in a list
            orders = [SELECT Id, orderNumber, AccountId FROM Order WHERE Id IN :orderIds];
            if (!orders.isEmpty()) {
                for (Order ord : orders) {
                    accIds.add(ord.AccountId);
                }

                //fetch contact email and map it to account Id
                for (Contact cnt : [SELECT Id, AccountId, Email FROM Contact WHERE AccountId = :accIds]) {
                    if (cnt.Email != null) {
                        System.debug('Inside C');
                        accountToContactEmailMap.put(cnt.AccountId, cnt.Email);
                    }
                }
                for (Order ord : orders) {
                    custOrd = new OrderDetails.CustomOrder();
                    custOrd.sfId = ord.Id;
                    custOrd.orderNumber = ord.OrderNumber;
                    //Improvement point: considering only one contact is related to the account.
                    custOrd.customerEmail = accountToContactEmailMap.get(ord.AccountId) != null ? accountToContactEmailMap.get(ord.AccountId) : '';
                    if (custOrd != null) {
                        custOrders.add(custOrd);
                    }
                }
            }
            if (Test.isRunningTest()) {
                System.assertEquals(1, custOrders.size(), 'Its fails because there are more than 1 orders inserted in test class');
            } else {
                //Call a Post service to send the serialzed data
                makeCallout(JSON.serializePretty(custOrders));
            }
        } catch (Exception e) {
            NpsCalloutService.setErrorResponse(NpsCalloutService.errors.get(4));
            //Improvement point: I prefer to throw the exception or log the exception to notify the admin/user
            System.debug('Exception error thrown: ' + e.getMessage());
        }
    }

    /**
    * @param orderToreturn Call the Rest service to POST the data to the external service
    */
    @future(callout=true)
    public static void makeCallout(String orderToreturn) {
        NpsCalloutService.makePostCallout(orderToreturn);
    }
    /**
     * Wrapper class to serialize the order details in JSON format
     */
    public class CustomOrder {

        private String sfId { get; set; }
        private String orderNumber { get; set; }
        private String customerEmail { get; set; }
    }
}