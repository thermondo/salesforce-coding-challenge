@isTest
private class OrderDataToNPSHandlerTest {
    @testSetup
    private static void setupTestData(){
  		Contact contactRecord=new Contact();
        contactRecord.LastName='TestLastName';
        contactRecord.Email='test@email.com';
        insert contactRecord;
        Account accountRecord=new Account(name='OrderTestAccount',phone='1769393638');
        insert accountRecord;
        Contract contractRecord=new Contract(AccountId=accountRecord.Id,Status='Draft',StartDate=System.today(),ContractTerm=7);
        insert contractRecord;
        Order orderRecord=new Order();
        orderRecord.BillToContactId=contactRecord.Id;
        orderRecord.AccountId=accountRecord.id;
        orderRecord.ContractId=contractRecord.Id;
        orderRecord.Status='Draft';
        orderRecord.EffectiveDate=System.today();
        insert orderRecord;
        
        
    }
    @isTest
    private static void testSendOrderDataPositiveScenario() {
        Order testOrder=[SELECT Id FROM Order LIMIT 1];
        // Set up the test data for the InvocableMethod
        List<Id> orderIds = new List<Id>{testOrder.Id};
        // Start the test by creating a mock HTTP response
        Test.setMock(HttpCalloutMock.class, new NpsMockResponseGeneratorTest());

        // Call the InvocableMethod
        OrderDataToNPSHandler.sendOrderData(orderIds);
        // Perform assertions based on the expected behavior of the handler
        //System.assertEquals(1, result.size(), 'One order should be returned');

    }
        @isTest
   private static void testSendOrderDataNegativeScenario() {
        Order testOrder=[SELECT Id FROM Order LIMIT 1];
        // Set up the test data for the InvocableMethod
        List<Id> orderIds = new List<Id>{testOrder.Id};
        // Start the test by creating a mock HTTP response
        Test.setMock(HttpCalloutMock.class, new NpsMockResponseGeneratorTest());

        // Call the InvocableMethod
        OrderDataToNPSHandler.sendOrderData(orderIds);
        // Perform assertions based on the expected behavior of the handler
        //System.assertEquals(1, result.size(), 'One order should be returned');
    }

    // You can add more test methods for other scenarios, error handling, etc.
}