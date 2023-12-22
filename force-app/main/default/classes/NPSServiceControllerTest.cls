/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This apex class is used to test the apex classes NPSServiceController ErrorLogging NPSCallOutService
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Nitish Bhardwaj
* @version        1.0
* @created        2023-12-21
* @modified       2023-12-21
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
@IsTest
public class NPSServiceControllerTest{

    @testSetup
    public static void testDataSetup(){
        
        Profile profile =[Select Id from Profile where Name='System Administrator'];
        User usr = new user(Alias ='Tu1', EmailEncodingKey='UTF-8', LastName='Bhar',
                            LanguageLocaleKey='en_US', LocaleSidKey = 'en_US', ProfileId = profile.Id,
                            TimeZoneSidKey='America/Los_Angeles', Email='HelloTest@test.com',
                            userName='HelloTest@test.com');
        insert usr;
        
         // Insert Account
        Account acc = new Account();
        acc.Name = 'Test Challange Account';
        insert acc;

        //Insert Contact
        Contact con = new Contact();
        con.AccountId= acc.Id;
        con.LastName = 'Bhardwaj';
        con.Email = 'test@Example.com';
        insert con;

        // Insert Product
        Product2 product = new Product2();
        product.Name = ' Test';
        product.Description='Test Prod';
        product.productCode = 'Test';
        product.isActive = true;
        insert product;



        // Insert PricebookEntry
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = Test.getStandardPricebookId();
        standardPrice.Product2Id = product.Id;
        standardPrice.UnitPrice = 1;
        standardPrice.IsActive = true;
        standardPrice.UnitPrice = 5000;
        standardPrice.UseStandardPrice = false;
        insert standardPrice ;

        // Insert Order
        Order order = new Order();
        order.Name = 'UnitTest Order';
        order.Status = 'Draft';
        order.BillToContactId = con.Id;
        order.EffectiveDate = system.today();
        order.EndDate = system.today() + 4;
        order.AccountId = acc.id;
        order.Pricebook2Id =  Test.getStandardPricebookId() ;
        insert order;

        //Insert Order Item
        orderItem ordItem = new orderItem();
        ordItem.OrderId = order.Id;
        ordItem.Product2Id = product.Id;
        ordItem.ListPrice = 5000;
        ordItem.UnitPrice = 5000;
        ordItem.Quantity = 2;
        ordItem.PricebookEntryId =  standardPrice.Id;
        insert ordItem;
    }
    @IsTest
    public static void positiveTest() {
        user u = [select id from user where username='HelloTest@test.com' limit 1];
        order o = [select id,NPS_Response_Status__c,Status from order where name='UnitTest Order' Limit 1];
        o.Status= 'Fulfilled';
        update o;
        system.debug([select id from orderhistory]);
        Test.StartTest();
        system.runAs(u){
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200,'Success'));
            NPSServiceController.sendOrderDataToNps(new List<Id>{o.Id});
            
        }
         Assert.areEqual('Fulfilled', o.Status);
        Test.stopTest();
       
    }
    
     @IsTest
    public static void negitiveTest() {
        user u = [select id from user where username='HelloTest@test.com' limit 1];
        order o = [select id,Status,NPS_Response_Status__c from order where name='UnitTest Order' Limit 1];
        Test.StartTest();
        system.runAs(u){
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(400,'BAD_PAYLOAD'));
            NPSServiceController.sendOrderDataToNps(new List<Id>{o.Id});
            
        }
        Assert.areEqual('Draft', o.Status);
        Test.stopTest();
        
    }
}