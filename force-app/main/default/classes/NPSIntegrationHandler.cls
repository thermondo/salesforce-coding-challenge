public with sharing class NPSIntegrationHandler {
    public static List<NPSIntegration.InvocableResult> sendToNPSAPI(List<String> orderIds) {

        Boolean success;
        // Collect the Order Ids
        Set<Id> orderIdsSet = new Set<Id>();

        // Convert the List<String> to Set<Id>
        for (String orderId : orderIds) {
            orderIdsSet.add(orderId);
        }

        // Query Order and related Contact data
        Map<Id, Order> ordersMap = new Map<Id, Order>([SELECT Id, OrderNumber, BillToContactId FROM Order WHERE Id IN :orderIdsSet]);
        Set<Id> contactIds = new Set<Id>();
        for (Order order : ordersMap.values()) {
            contactIds.add(order.BillToContactId);
        }
        Map<Id, Contact> billToContactsMap = new Map<Id, Contact>([SELECT Id, Email FROM Contact WHERE Id IN :contactIds]);
        List<NPSIntegration.InvocableResult> results = new List<NPSIntegration.InvocableResult>();
        List<Id> markedAsSent = new List<ID>();

        // Loop through the provided Order Ids
        for (String orderId : orderIds) {
            // Retrieve Order and related Contact data from the maps
            Order orderRecord = ordersMap.get(orderId);
            Contact billToContact = billToContactsMap.get(orderRecord.BillToContactId);

            // Prepare data for the NPS API
            String sfId = orderRecord.Id;
            String orderNumber = orderRecord.OrderNumber;
            String email = billToContact.Email;

            // Check for duplicate emails 
            if (hasSentEmail(sfId)) {
                // Log or handle duplicate email scenario
                System.debug('Duplicate email detected for Order ' + orderNumber);
                results.add(new NPSIntegration.InvocableResult('Email already processed for Order ' + orderNumber, false));
            }   
            else{
                success = sendToNPSAPInternal(orderNumber,email);
                // Log the result
                if (success) {
                    System.debug('Data sent to NPS API for Order ' );//+ orderNumber);    
                    results.add(new NPSIntegration.InvocableResult('Data processed for Order '+orderNumber, success)); 
                    markedAsSent.add(sfId);
                } else {
                    System.debug('Failed to send data to NPS API for Order ' + orderNumber);
                    results.add(new NPSIntegration.InvocableResult('Error: '+orderNumber , false));
                }
            }
        } 
        if (markedAsSent.size()>0){
            markEmailAsSent(markedAsSent); 
        }      
        return results;
    }

    private static Boolean sendToNPSAPInternal(String orderNumber, String email) {
        // Define the NPS API endpoint from Named Credential
        String npsApiEndpoint = 'callout:NPS_API';

        // Construct request payload
        String requestBody = '{"orderNumber":"' + orderNumber + '","email":"' + email + '"}';


        // Set up the HTTP request
        HttpRequest request = new HttpRequest();
        request.setEndpoint(npsApiEndpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');

        // Set the request body
        request.setBody(requestBody);

        // Send the HTTP request
        Http http = new Http();
        HttpResponse response = http.send(request);

        // Check the response status
        if (response.getStatusCode() == 200) {
            // The request was successful
            return true;
        } else {
            // Log the error or handle it as needed
            System.debug('Error sending data to NPS API. Status Code: ' + response.getStatusCode());
            System.debug('Response Body: ' + response.getBody());
            return false;
        }
    }

    private static Boolean hasSentEmail(String orderId) {
        //Query the custom object to check if there's a record with the given orderId
        Integer count = 0;
        count = [SELECT COUNT() FROM NPS_Order_Email__c WHERE Order__c = :orderId WITH SECURITY_ENFORCED];
        
        // If count is greater than 0, it means an email has been sent
        return count > 0;
    }

    @future
    private static void markEmailAsSent(List<Id> orderId) {
        //Create a new record in the custom object to mark the email as sent
        List<NPS_Order_Email__c> emailRecords = new List<NPS_Order_Email__c>();
        for(Id orderNo : orderId){
            if (!Schema.sObjectType.NPS_Order_Email__c.fields.Order__c.isCreateable()){
                System.debug('Insufficient Permissions');
            }
            else{
                NPS_Order_Email__c emailSentRecord = new NPS_Order_Email__c(Order__c = orderNo,Name = orderNo);
                emailRecords.add(emailSentRecord);
            }
        }
        insert emailRecords;
    }
}