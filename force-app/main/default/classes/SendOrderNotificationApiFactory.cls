public with sharing class SendOrderNotificationApiFactory {
    public ISendOrderNotificationApi getSendOrderNotificationApi(){
        return new NPSApi();
    }
}