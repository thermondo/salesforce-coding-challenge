@isTest
public with sharing class NPSServiceTest {
    
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
    static void insertOrdersTest() {                   
        List<Order> orderList = [SELECT Id, Status, OrderNumber, BillToContact.Email FROM Order LIMIT 1];                        
        
        Test.startTest();                
        Test.setMock(HttpCalloutMock.class, new NPSServiceMock());    
        NPSService ns = new NPSService();
        HttpResponse res = ns.insertOrders(orderList);                
        
        String contentType = res.getHeader('Content-Type');
        String expectedBody = '{"sfId": "8015E000003LfJXQA0","orderNumber": "007","customerEmail": "customerAddress@example.com"}';
        
        System.assertEquals(contentType, 'application/json' , 'Content Type header is wrong.');        
        System.assertEquals(expectedBody, res.getBody(), 'Request body and response body are not equal');
        System.assertEquals(200, res.getStatusCode(), 'Status Code not 200');    
        Test.stopTest();    
    }

    @isTest
    static void insertOrdersTestMoreThan30Records() {    
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
        List<Order> orderList = [SELECT Id, OrderNumber, BillToContact.Email FROM Order];   

        Test.startTest();                    
        System.assert(orderList.size() > 30, 'Expected order size is not higher than 30');    
        String expectedError =  'More than 30 records can not send at once';    
        NPSService ns = new NPSService();
        try {
            HttpResponse res = ns.insertOrders(orderList);                    
        } catch (Exception ex) {
            System.assertEquals(expectedError, ex.getMessage() , 'Different exception throwed.');            
        }        
        Test.stopTest();    
    }
}