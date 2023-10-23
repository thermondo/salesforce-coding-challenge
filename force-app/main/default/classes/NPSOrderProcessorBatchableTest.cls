@isTest
public with sharing class NPSOrderProcessorBatchableTest {
    
    @TestSetup    
    static void mockData(){
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;

        Contact c = new Contact();
        c.LastName = 'Test';
        c.Email = 'test@invalid.com';
        c.AccountId = acc.Id;
        insert c;

        Order o = new Order();
        o.EffectiveDate = Date.today();
        o.Status = 'Draft';
        o.AccountId = acc.Id;
        o.BillToContactId = c.Id;
        insert o;
    }

    @isTest
    static void orderProcessorBatchableTest(){
        Set<Id> orderIds = new Map<Id, Order>(([SELECT Id FROM Order])).keySet();
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NPSServiceMock()); 

        NPSOrderProcessorBatchable orderProcessorBatchable = new NPSOrderProcessorBatchable(new List<Id>(orderIds));
        Id batchId = Database.executeBatch(orderProcessorBatchable, 30); 
        Test.stopTest();        
        
        AsyncApexJob job = [SELECT Status FROM AsyncApexJob WHERE ID = :batchId LIMIT 1];
        System.assertEquals('Completed', job.Status, 'Job status is not completed!');
        
    }

    static void orderProcessorBatchableMoreThan30RecordTest(){
        List<Order> testOrders = new List<Order>();
        Contact c = [SELECT Id, AccountId FROM Contact WHERE LastName = 'Test' LIMIT 1];     

        for(integer i=0; i<300; i++){
            Order o = new Order();
            o.EffectiveDate = Date.today();
            o.Status = 'Draft';
            o.AccountId = c.AccountId;
            o.BillToContactId = c.Id;
            testOrders.add(o);
        }
        insert testOrders;

        Set<Id> orderIds = new Map<Id, Order>(([SELECT Id FROM Order])).keySet();
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NPSServiceMock()); 
        NPSOrderProcessorBatchable orderProcessorBatchable = new NPSOrderProcessorBatchable(new List<Id>(orderIds));
        Id batchId = Database.executeBatch(orderProcessorBatchable, 30); 
        Test.stopTest();        
        
        AsyncApexJob job = [SELECT Status FROM AsyncApexJob WHERE ID = :batchId LIMIT 1];
        System.assertEquals('Completed', job.Status, 'Job status is not completed!');
        
    }
}