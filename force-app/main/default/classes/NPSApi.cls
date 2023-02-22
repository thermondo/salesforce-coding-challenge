public with sharing class NPSApi implements ISendOrderNotificationApi{
    
    public Boolean sendOrderNotification(List<OrderNotificationData> orderNotificationDataList){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:NPS/orders');
        req.setMethod('POST');

        List<OrderNotification> orderNotificationList = new List<OrderNotification>();

        //TODO Iterate over maximun 30 petition and call again

        for(OrderNotificationData orderNotificationData : orderNotificationDataList){
            OrderNotification orderNotification = new OrderNotification(orderNotificationData);
            orderNotificationList.add(orderNotification);
        }

        req.setBody(JSON.serialize(orderNotificationList));

        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        if(res.getStatusCode() == 200){
            return true;
        }
        else{
            return false;
        }
    }

    public class OrderNotification{
        public Id sfId;
        public String orderNumber;
        public String customerEmail;

        public OrderNotification(OrderNotificationData orderNotificationData){
            this.sfId = orderNotificationData.getOrderId();
            this.orderNumber = orderNotificationData.getOrderNumber();
            this.customerEmail = orderNotificationData.getCustomerEmail();
        }
    }

}