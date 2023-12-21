@isTest
private class NPSCalloutsTest {
     
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
    private static void postOrderDataToNpsPositiveTestCase() {
        Order orderRecordToBuildWrapper=[SELECT Id FROM Order LIMIT 1];
        List<Order>  listOfOrderRecordToBuildWrapper=new OrderSelector().selectByIds(new List<Id>{orderRecordToBuildWrapper.Id});
     	orderRecordToBuildWrapper=listOfOrderRecordToBuildWrapper[0];
        // Set up a test list of OrderDataWrapper objects
        List<OrderDataWrapper> testOrderData = new List<OrderDataWrapper>();
        OrderDataWrapper orderDataWrapperInstance=new OrderDataWrapper(orderRecordToBuildWrapper.Id,
                                                                           orderRecordToBuildWrapper.BillToContact.Email,
                                                                           orderRecordToBuildWrapper.OrderNumber
                                                                          );
        testOrderData.add(orderDataWrapperInstance);
        Test.StartTest();
        // Start the test by creating a mock HTTP response
        Test.setMock(HttpCalloutMock.class, new NpsMockResponseGeneratorTest());
        HttpResponse httpRes=NPSCallouts.makePostCallout('testBody','/Orders');
        NPSCallouts.postOrderDataToNps(testOrderData);
		Test.StopTest();
        Assert.areEqual(200, httpRes.getStatusCode());

    }
}