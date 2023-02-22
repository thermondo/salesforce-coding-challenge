public with sharing class SendOrderNotificationQueable implements Queueable {

    Set<Id> orderIds;

    public SendOrderNotificationQueable(Set<Id> orderIds){
        this.orderIds = orderIds;
    }

    public void execute(QueueableContext context) {
        if(!this.orderIds.isEmpty()){
            ISendOrderNotificationApi sendOrderNotificationApi = new SendOrderNotificationApiFactory().getSendOrderNotificationApi();
            SendOrderNotificationService SendOrderNotificationService = new SendOrderNotificationService(this.orderIds, sendOrderNotificationApi);
            SendOrderNotificationService.sendOrderNotification();
            //TODO make an update on order to try later or log pettition
            //TODO call again to queable if has orders notifications left
        }
    }
}