/**
 * @description       : Test class for OrderDetails class
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 08-06-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public with sharing class OrderDetailsCalloutTest {

    @TestSetup
    public static void testSetuo(){
        // Insert Account
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        // Insert Product
        Product2 p = new Product2();
        p.Name = ' Test Product ';
        p.Description='Test Product Entry 1';
        p.productCode = 'ABC';
        p.isActive = true;
        insert p;

        Id pricebookId = Test.getStandardPricebookId();

        // Insert PricebookEntry
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = p.Id;
        standardPrice.UnitPrice = 1;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice ;

        // Insert Order
        Order o = new Order();
        o.Name = 'Test Order ';
        o.Status = 'Draft';
        o.EffectiveDate = system.today();
        o.EndDate = system.today() + 4;
        o.AccountId = a.id;
        o.Pricebook2Id =  pricebookId ;
        insert o;
    }

    @IsTest
    public static void fetchAndSerializeOrderDetailsTest() {
        List<String> orderIds = new List<String>();
        List<Order> orders = [SELECT Id FROM Order];
        for(Order ord:orders){
            orderIds.add(ord.Id);
        }
        Test.startTest();
        OrderDetails.fetchAndSerializeOrderDetails(orderIds);
        Test.stopTest();
    }

    @IsTest
    public static void NpsCalloutServiceTest() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
        String jsonBody = '{"sfId": "8015E000003LfJXQAT","orderNumber": "008","customerEmail": "customerAddress@example.com"}';
        HttpResponse res = NpsCalloutService.makePostCallout(jsonBody);
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        System.assertEquals(actualValue, jsonBody);
        System.assertEquals(200, res.getStatusCode());
    }
}