@IsTest
public with sharing class OrderServiceTest {
    @IsTest
    static void when_serviceMethodIsExecuted_then_NpsTriggeredFlagIsSetToTrue() {
        // GIVEN: An order with NPS_service_already_triggered__c = false
        Account testAccount = new Account(
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId(),
            FirstName = 'Test',
            LastName = 'Account',
            PersonEmail = 'test@mail.com'
        );

        insert testAccount;
        Order testOrder = new Order(
            AccountId = [SELECT Id FROM Account LIMIT 1].Id,
            EffectiveDate = Date.today().addDays(1),
            Status = 'Draft'
        );
        insert testOrder;

        // WHEN: OrderService.performNpsServiceTriggeredUpdates() is executed for testOrder ID

        new OrderService().performNpsServiceTriggeredUpdates(new List<Id>{testOrder.Id});

        // THEN: The NPS_service_already_triggered__c flag is set to true

        System.assert([SELECT NPS_service_already_triggered__c FROM Order WHERE Id = :testOrder.Id].NPS_service_already_triggered__c);
    }
}