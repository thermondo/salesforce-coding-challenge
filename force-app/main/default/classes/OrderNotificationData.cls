public with sharing class OrderNotificationData {

    private Id orderId; 
    private String orderNumber; 
    private String customerEmail;

    public OrderNotificationData(Id orderId, String orderNumber, String customerEmail) {
        this.orderId = orderId;
        this.orderNumber = orderNumber;
        this.customerEmail = customerEmail;
    }

    public Id getOrderId(){
        return this.orderId;
    }

    public String getOrderNumber(){
        return this.orderNumber;
    }

    public String getCustomerEmail(){
        return this.customerEmail;
    }
}