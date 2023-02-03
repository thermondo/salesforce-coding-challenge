public class Interview {
    @InvocableMethod(callout=true)
    public static void sendNPSScore(List<Id> orderIds) {
    
        List<Order> orders = [SELECT Id, orderNumber, Account.PersonEmail FROM Order WHERE Id=:orderIds];
        for (Order o : orders) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://salesforce-coding-challenge.herokuapp.com');
            String username = 'tmondo';
            String password = 'Noy84LRpYvMZuETB';
            Blob headerValue =Blob.valueOf(username+':'+password);
            String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
            request.setHeader('Authorization', authorizationHeader);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setBody('{"email": "' + o.Account.PersonEmail + '", "orderNumber": "' + o.OrderNumber + '"}');
            HttpResponse response = http.send(request);
            System.assert(response.getStatusCode()==201);
        }
    }
}