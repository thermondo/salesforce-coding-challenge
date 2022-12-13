@IsTest
public with sharing class OrderSelectorTest {
    // TODO: create a test helper class to keep reusable pieces of test-applicable code in one place
    @TestSetup
    static void setup() {
        Account testAccount = new Account(
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId(),
            FirstName = 'Test',
            LastName = 'Account',
            PersonEmail = 'test@mail.com'
        );
        insert testAccount;
    }

    @IsTest
    static void when_NpsTriggeredFlagIsFalse_then_returnOrder() {
        // GIVEN: An order with NPS_service_already_triggered__c = false

        Order testOrder = new Order(
            AccountId = [SELECT Id FROM Account LIMIT 1].Id,
            EffectiveDate = Date.today().addDays(1),
            Status = 'Draft'
        );
        insert testOrder;

        // WHEN: OrderSelector.selectOrderNumberAndPersonEmailForOrderIds() is executed for testOrder ID

        List<Order> orders = new OrderSelector().selectOrderNumberAndPersonEmailForOrderIds(new List<Id>{testOrder.Id});

        // THEN: Exactly the same Order is returned

        System.assertEquals(1, orders.size());
        System.assertEquals(testOrder.Id, orders.get(0).Id);
    }

    @IsTest
    static void when_NpsTriggeredFlagIsTrue_then_returnEmptyList() {
        // GIVEN: An order with NPS_service_already_triggered__c = true

        Order testOrder = new Order(
            AccountId = [SELECT Id FROM Account LIMIT 1].Id,
            EffectiveDate = Date.today().addDays(1),
            Status = 'Draft',
            NPS_service_already_triggered__c = true
        );
        insert testOrder;

        // WHEN: OrderSelector.selectOrderNumberAndPersonEmailForOrderIds() is executed for testOrder ID

        List<Order> orders = new OrderSelector().selectOrderNumberAndPersonEmailForOrderIds(new List<Id>{testOrder.Id});

        // THEN: An empty list is returned

        System.assertEquals(0, orders.size());
    }
}