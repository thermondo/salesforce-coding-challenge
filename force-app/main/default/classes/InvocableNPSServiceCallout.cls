/**
* @description       : This class makes the callout to the NPS service when the order is set to Fulfilled.
* @author            : sengarlavanya@gmail.com
* @created on        : 08.10.2023
**/
global class InvocableNPSServiceCallout {
    
/******************************************************************************************
* Invocable method which is triggered by Order | Trigger | After Create/Update | Scheduled Path
* to send the order informaton to the NPS endpoint
* @param List<Order> orderId
* @return none
******************************************************************************************/
    @InvocableMethod(label='Create Request Body for NPSService and do Callout' description='Creates Request body and makes a callout to the endpoint.')
    public static List<String> sendOrderDataToService(List<Order> orderId){
        
        List<String> statusCodeValue = new List<String>();
        
        /*POINT: The invocable method will always have one order record as this will be called from the record triggered flow.
		For mass records a scheduled job can be run. In that case the maximum records at once should be less than 100
		to handle the maximum callout limit. */
        List<Order> ordersToSend = [SELECT id, BillToContact.Email, OrderNumber FROM Order WHERE id=:orderId[0].Id];
		system.debug(ordersToSend);
        system.debug(ordersToSend[0].BillToContact.Email);
        
        List<Map<String, String>> ordersList = new List<Map<String, String>>();
        
        for(Order o : ordersToSend) {
            ordersList.add(new Map<String, String>{
                'sfId' => o.Id,
                'orderNumber' => o.OrderNumber,
                'customerEmail' => o.BillToContact.Email
            });
        }
        /*POINT: The endpoint, credentials and headers in the http request can be replaced with Named Credentials.*/
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://salesforce-coding-challenge.herokuapp.com/orders');
        req.setMethod('POST');
        req.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf('tmondo:Noy84LRpYvMZuETB')));
        req.setHeader('Content-Type','application/json');
		req.setBody(JSON.serialize(ordersList));
        
        /*POINT: The Callout can also be written in another class and called from the invocable method.*/
        Http http = new Http();
        HttpResponse res;
        
        /*POINT: The below error handling will send an email to the admins who are in ApexEmailNotification.
		We can also implement a way where the email is sent to the Slack channel by re routing the email*/
        try {
            res = http.send(req);
            if (res.getStatusCode() != 200) {
                String mainBody = 'Response Status Code: ' + res.getStatusCode() + ' Bad Request Error. The order information for the order record id: ' + ordersToSend[0].Id + ' was not sent successfully. Please check the status code and reach out to the dev team.';
                statusCodeValue.add('Unsuccessful');
                sendEmailToApexExceptionRecipients(mainBody);
            }
            else if(res.getStatusCode() == 200){
                statusCodeValue.add('Success');
            }
        } catch (System.CalloutException e) {
            statusCodeValue.add('Exception');
            system.debug(e.getMessage());
            sendEmailToApexExceptionRecipients(e.getMessage());
        }
        return statusCodeValue;
    }
    
/******************************************************************************************
* Method to send the email for exceptions and unsuccessful callouts to all Apex Exception Recipients
* @param String mainBody (formatted body with details)
* @return none
******************************************************************************************/
    public static void sendEmailToApexExceptionRecipients(String mainBody){
        List<ApexEmailNotification> listRecipients = [SELECT UserId, User.Email, Email FROM ApexEmailNotification];
        List<String> recipientList = new List<String>();
        for (ApexEmailNotification apexExceptionRec : listRecipients){
            if(apexExceptionRec.Email != null)
            {
                recipientList.add(apexExceptionRec.Email);
            }else if (apexExceptionRec.UserId != null) {
                recipientList.add(apexExceptionRec.User.Email);
            }
        }
        
        String subject = 'Order Data was not Sent Successfully. Please check the Error in the Email Body';
        String emailBody = 'Hi, <br/><br/> Please find the order recordId which encountered issues while sending the order info. <br/><br/>' + mainBody + '<br/><br/>Kind regards, <br/> Thermondo Salesforce team.';
        if(recipientList.size() > 0){
            Id oweaId = [SELECT Id from OrgWideEmailAddress WHERE Address = 'sengarlavanya@gmail.com' limit 1].Id;
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            if ( oweaId != null ) {
                email.setOrgWideEmailAddressId(oweaId);
            }
            email.setToAddresses(recipientList);
            email.setSubject(subject);
            email.setHtmlBody(emailBody);
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        }
    }

}