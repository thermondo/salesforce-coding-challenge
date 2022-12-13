public with sharing class OrderService {
    public void performNpsServiceTriggeredUpdates(List<Id> orderIds) {
        fflib_ISObjectUnitOfWork uow = (fflib_SObjectUnitOfWork) new fflib_Application.UnitOfWorkFactory().newInstance(new List<SObjectType>{Order.SObjectType});
        for (Id orderId : orderIds) {
            uow.registerDirty(
                new Order(
                    Id = orderId,
                    NPS_service_already_triggered__c = true
                )
            );
        }
        try {
            uow.commitWork();
        } catch (Exception e) {
            // TODO: add asynchronous error logging to a record (e.g. Log__c) with the use of platform events (e.g. Log_event__e)
        }
    }
}