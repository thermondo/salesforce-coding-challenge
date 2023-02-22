public with sharing class SendOrderNotificationService {

    private Set<Id> orderIdsToSendNotification;
    private ISendOrderNotificationApi sendOrderNotificationApi;

    public SendOrderNotificationService(Set<Id> orderIdsToSendNotification, ISendOrderNotificationApi sendOrderNotificationApi) {
        this.orderIdsToSendNotification = orderIdsToSendNotification;
        this.sendOrderNotificationApi = sendOrderNotificationApi;
    }

    public Results sendOrderNotification(){

        Results results = new Results();

        List<OrderNotificationData> orderNotificationDataList;

        new OrderSelector().getOrderByIds(this.orderIdsToSendNotification);

        if(this.sendOrderNotificationApi.sendOrderNotification(orderNotificationDataList)){
            
            results.sucessOrdersId = this.orderIdsToSendNotification;
        }
        else
        {
            results.errorOrdersId = this.orderIdsToSendNotification;
        }

        return results;
    }

    public class Results {
        public Set<Id> sucessOrdersId = new Set<Id>();
        public Set<Id> errorOrdersId = new Set<Id>();
    }
}