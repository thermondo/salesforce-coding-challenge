/*
 * Main invocable class for the Thermondo challenge.
 * 
 * @author Narek Petrosyan
 * @version 1.0
 * @created 30.12.2022
 *  
*/

// TODO: what is sharing model?
public without sharing class Thermondo_InvocableAction {
        
    @InvocableMethod(callout = true label = 'Callout to NPS Service' description = 'Makes a callout to an NPS Service' category = 'Order')
    // TODO: List<List<Id>> for more than one orders
    public static List<String> getIDs(List<Id> IDs) {
        if (IDs.isEmpty()) {
            // TODO: proper error handling
            // TODO: place these strings in e.g. custom labels for translations
           return new List<String>{'Please provide a valid ID'}; 
        }
        String result = '';
        
        String payload = preparePayload(IDs);
        
        // can also be done with a @testVisible static variable
        if (!Test.isRunningTest()) {
        	HTTPResponse response = Thermondo_CalloutService.doCallout(payload);
        	result = Thermondo_CalloutResponseHandler.handleResponse(response);
        }
        
        return new List<String>{result};
    } 
    
    // for resialization TODO: in a separate class
    private class NPSOrder {
        public String sfId;
        public String orderNumber;
        public String sfIcustomerEmaild;
    }
    
    // payload to send to the server TODO: in a separate class
    private static String preparePayload(List<Id> IDs) {
        List<NPSOrder> NPSOrders = new List<NPSOrder>();
        for (Order o : [SELECT Id, Account.PersonEmail, OrderNumber FROM Order WHERE Id IN :IDs]){
            NPSOrder tempOrder = new NPSOrder();
            tempOrder.sfId = o.Id;
            tempOrder.orderNumber = o.orderNumber;
            tempOrder.sfIcustomerEmaild = o.Account.PersonEmail;
            NPSOrders.add(tempOrder);
        }        
        return JSON.serialize(NPSOrders);
    }
}