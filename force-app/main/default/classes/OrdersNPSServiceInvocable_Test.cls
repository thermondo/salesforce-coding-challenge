/*******************************************************************************************************
* @Name         OrdersNPSServiceInvocable_Test
* @Author       Aditya Vempati
* @Date         01/25/2023
* @Description  This class is used to unit test Order Fullfilment and NPS Service
*******************************************************************************************/
@isTest(seeAllData = false)
private class OrdersNPSServiceInvocable_Test 
{
    
    private static final String DRAFT = 'Draft';
    private static final String FULFILLED_STATUS = 'Fulfilled';
    
    @testSetup
    private static void createAccountAndOrder()
    {
        Id personAccountRecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        
        Product2 sampleProduct = new Product2(name='SAMPLE PRODUCT' , IsActive=true);
        insert sampleProduct;
        
        // insert  PriceBookEntry
        PriceBookEntry priceBookEntry = new PriceBookEntry();
        priceBookEntry.Product2Id=sampleProduct.Id;
        priceBookEntry.Pricebook2Id=Test.getStandardPricebookId();
        priceBookEntry.UnitPrice=5500;
        priceBookEntry.IsActive=true;
        insert priceBookEntry;
        
        List<Account> accounts = new List<Account>();
        for(Integer j = 0 ; j <10 ; j++)
        {
            Account personAccountInstance = new Account();
            personAccountInstance.FirstName = 'Test';
            personAccountInstance.LastName = 'AccountLastName';
            personAccountInstance.RecordTypeId = personAccountRecordTypeId;
            personAccountInstance.PersonEmail = 'test@test.com';
            accounts.add(personAccountInstance);
        }
        insert accounts;
        
        List<Order> orders = new List<Order>();
        List<OrderItem> orderItems = new List<OrderItem>();
        
        for(Integer i = 0; i <10 ;i++)
        {
            Order orderInstance = new Order();
            orderInstance.AccountId = accounts[i].Id;
            orderInstance.EffectiveDate=Date.today();
            orderInstance.Status=DRAFT;
            orderInstance.Pricebook2Id=Test.getStandardPricebookId();
            orders.add(orderInstance);
        }
        
        insert orders;
        
        for(Order orderRecordInstance : orders)
        {
            orderItems.add(new OrderItem (UnitPrice = 5, OrderId  = orderRecordInstance.Id,
                                          PriceBookEntryId = priceBookEntry.Id, 
                                          Quantity = 1, Product2Id = sampleProduct.Id));
        }
        
        insert orderItems;
    }
    
    @isTest
    private static void given_ValidOrders_WhenOrdersAreFullfilled_ThenNPSServiceShouldBeInvoked()
    {
        
        Test.setMock(HttpCalloutMock.class, new GenericHttpCalloutMock(IntegrationConstants.SERVICE_SUCCESS_CODE, 'Success', 'Email Sent', null));
        List<Order> orders = [SELECt Id,Status FROM Order WHERE Status != :FULFILLED_STATUS];
        
        //Given Valid Orders 
        System.Assert(!orders.isEmpty());
        for(Order orderInstance : orders)
        {
            //When Order Status is FulFilled
            orderInstance.Status = FULFILLED_STATUS;
        }
        update orders; 
        
        Test.startTest();
        
        OrdersNPSServiceInvocable.invokeNPSAPI(new List<Id>(new Map<Id, Order>(orders).keySet()));
        
        Test.stopTest();
        
        //THEN Order Integration NPS Status should be set to Success
        System.Assert(IntegrationConstants.SUCCESS == [SELECT NPS_Integration_Status__c FROM Order WHERE Id IN :orders LIMIT 1]?.NPS_Integration_Status__c);
    }
    
    @isTest
    private static void given_ValidOrders_WhenOrdersAreFullfilled_ThenNPSServiceShouldBeInvokedAndFailed()
    {
        
        
        Test.setMock(HttpCalloutMock.class, new GenericHttpCalloutMock(400, 'Failure', 'Bad Request', null));
        List<Order> orders = [SELECt Id,Status FROM Order WHERE Status != :FULFILLED_STATUS];
        
        //Given Valid Orders 
        //
        System.Assert(!orders.isEmpty());
        for(Order orderInstance : orders)
        {
            //When Order Status is FulFilled
            orderInstance.Status = FULFILLED_STATUS;
        }
        update orders; 
        Test.startTest();
        OrdersNPSServiceInvocable.invokeNPSAPI(new List<Id>(new Map<Id, Order>(orders).keySet()));
        
        Test.stopTest();
        
        //THEN Order Integration NPS Status should be set to Success
        
        System.Assert(IntegrationConstants.FAILURE == [SELECT NPS_Integration_Status__c FROM Order WHERE Id IN :orders LIMIT 1]?.NPS_Integration_Status__c);
        System.Assert([SELECT ID FROM Log_Entry__c].size() >= 1);
    }
    
    
    @isTest
    private static void given_ValidOrders_WhenOrdersAreFullfilled_ThenNPSServiceShouldBeInvokedAndServerError()
    {
        
        
        Test.setMock(HttpCalloutMock.class, new GenericHttpCalloutMock(500, 'Failure', 'Bad Request', null));
        List<Order> orders = [SELECt Id,Status FROM Order WHERE Status != :FULFILLED_STATUS];
        
        //Given Valid Orders 
        
        System.Assert(!orders.isEmpty());
        for(Order orderInstance : orders)
        {
            //When Order Status is FulFilled
            orderInstance.Status = FULFILLED_STATUS;
        }
        update orders; 
        Test.startTest();
        OrdersNPSServiceInvocable.invokeNPSAPI(new List<Id>(new Map<Id, Order>(orders).keySet()));
        
        Test.stopTest();
        
        //THEN Order Integration NPS Status should be set to Success
        
        System.Assert(IntegrationConstants.FAILURE == [SELECT NPS_Integration_Status__c FROM Order WHERE Id IN :orders LIMIT 1]?.NPS_Integration_Status__c);
        System.Assert([SELECT ID FROM Log_Entry__c].size() >= 1);
    }
    
    @isTest
    private static void given_ValidOrders_WhenOrdersAreFullfilled_ThenNPSServiceShouldBeInvokedAndInternalServerError()
    {
        
        
        List<Order> orders = [SELECt Id,Status FROM Order WHERE Status != :FULFILLED_STATUS];
        
        //Given Valid Orders 
        
        System.Assert(!orders.isEmpty());
        for(Order orderInstance : orders)
        {
            //When Order Status is FulFilled
            orderInstance.Status = FULFILLED_STATUS;
        }
        update orders; 
        Test.startTest();
        OrdersNPSServiceInvocable.invokeNPSAPI(new List<Id>(new Map<Id, Order>(orders).keySet()));
        
        Test.stopTest();
        
        //THEN Order Integration NPS Status should be set to Success
        
        System.Assert(IntegrationConstants.FAILURE == [SELECT NPS_Integration_Status__c FROM Order WHERE Id IN :orders LIMIT 1]?.NPS_Integration_Status__c);
        System.Assert([SELECT ID FROM Log_Entry__c].size() >= 1);
    }
    
}