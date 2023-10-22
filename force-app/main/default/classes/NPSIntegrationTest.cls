@isTest
private class NPSIntegrationTest {

    
    // Create test data 
    @testSetup
    static void testData(){
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'Shruti',
            LastName = 'Gundewar',
            Email = 'shruti.ggundewar@gmail.com',
            AccountId = testAccount.Id
        );
        insert testContact;

        Date startDate = Date.newInstance(2023, 10, 21);

        Contract testServiceContract = new Contract(
            StartDate = startDate,
            ContractTerm = 12,
            AccountId = testAccount.Id
        );
        insert testServiceContract;

        Order testOrder = new Order(
            ContractId = testServiceContract.Id,
            BillToContactId = testContact.Id,
            Status = 'Draft',
            AccountId = testAccount.Id,
            EffectiveDate = startDate
        );
        insert testOrder;
    }

    // Mock response class
    private class MockNPSApiResponse implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody('{"message":"Mock response","success":true}');
            return response;
        }
    }

    @isTest
    static void testSendOrderData() {
        List<Order> orders = [SELECT Id FROM Order];
        List<Order> ordersToUpdate = new List<Order>();
        List<String> testOrderIds = new List<String>();
        for(Order orderInfo : orders){
            testOrderIds.add(orderInfo.Id);
            orderInfo.Status = 'Fulfilled';
            ordersToUpdate.add(orderInfo);
        }

        update ordersToUpdate;
        
        // Set up mock response
        Test.setMock(HttpCalloutMock.class, new MockNPSApiResponse());

        // Call the invocable method with the test data
        Test.startTest();
        NPSIntegrationTest.sendOrderDataAsync(testOrderIds);
        Test.stopTest();
    }
    
    // Separate method with @future annotation
    @future(callout=true)
    public static void sendOrderDataAsync(List<String> orderIds) {
          List<NPSIntegration.InvocableResult> results =  NPSIntegrationController.sendOrderData(orderIds);
        // Assert the results based on Mock response
        System.assertEquals(1, results.size(),'Size is 1 for the orders');
        System.assertEquals(true, results[0].success,'NPS data processing is success');
    }
}