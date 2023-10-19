@isTest
public with sharing class NPSOrderLocatorTest {
    
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

       

        Product2 p = new Product2();
        p.Name = 'Test';
        insert p;

        Pricebook2 pb = new Pricebook2();
        pb.Name = 'Test';
        pb.IsActive = true;
        insert pb;

        PriceBookEntry pbe = new PriceBookEntry();
        pbe.Product2Id = p.Id; 
        pbe.Pricebook2Id = Test.getStandardPricebookId();        
        pbe.UnitPrice = 1;
        pbe.IsActive = true;
        insert pbe;

        Order o = new Order();
        o.EffectiveDate = Date.today();
        o.Status = 'Draft';
        o.AccountId = acc.Id;
        o.BillToContactId = c.Id;
        o.Pricebook2Id = Test.getStandardPricebookId();
        insert o;

        OrderItem oi = new OrderItem();
        oi.Product2Id = p.Id;
        oi.Quantity = 1;
        oi.UnitPrice = 1;
        oi.OrderId = o.Id;
        oi.PricebookEntryId = pbe.id;

        insert oi;

        o.Status = 'Fulfilled';
        update o;
    }

    @isTest
    static void initializeOrdersTest() {
        Set<Id> orderIds = new Map<Id, Order>(([SELECT Id FROM Order])).keySet();
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NPSServiceMock());    
        List<NPSOrderLocator.NPSServiceResult> result = NPSOrderLocator.initializeOrders(new List<Id>(orderIds));
        
        System.assertEquals(true,  result[0].success , 'NPS Service Invocable Result is not Success');        
        Test.stopTest();
    }

    @isTest
    static void initializeOrdersExceptionTest() {
        List<Order> testOrders = new List<Order>();
        Contact c = [SELECT Id, AccountId FROM Contact WHERE LastName = 'Test' LIMIT 1];     

        for(integer i=0; i<31; i++){
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
        System.assert(orderIds.size() > 30, 'Expected order size is not higher than 30');    
        String expectedError =  'More than 30 records can not send at once';      
        List<NPSOrderLocator.NPSServiceResult> result = NPSOrderLocator.initializeOrders(new List<Id>(orderIds));
        
        System.assertEquals(false,  result[0].success , 'NPS Service Invocable Result should not be Success');        
        System.assertEquals(expectedError,  result[0].message , 'NPS Service Invocable Result should not be Success');        
        Test.stopTest();
    }
}