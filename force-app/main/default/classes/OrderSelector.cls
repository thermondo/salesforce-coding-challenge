public with sharing class OrderSelector extends fflib_SObjectSelector {
    public SObjectType getSObjectType() {
        return Order.SObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Order.Id,
            Order.OrderNumber
        };
    }

    public List<Order> selectOrderNumberAndPersonEmailForOrderIds(List<Id> orderIds) {
        return (List<Order>) Database.query(
            newQueryFactory()
                .selectFields(new List<String>{'Id', 'Account.PersonEmail', 'OrderNumber'})
                .setCondition('NPS_service_already_triggered__c = FALSE AND Id IN :orderIds')
                .toSOQL()
        );
    }
}