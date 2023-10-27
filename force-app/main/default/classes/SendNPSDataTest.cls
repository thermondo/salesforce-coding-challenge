/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This apex class is used Create Data for NPS API Callout.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Saurao Londhekar
* @modifiedBy     Saurao Londhekar
* @maintainedBy   Saurao Londhekar
* @version        1.0
* @created        2023-10-22
* @modified       2023-10-22
* @systemLayer    Service
* @see            ????
* @see            ????
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes        Test Class to cover NPSCallout and SendNPSData
* v1.0            Saurao Londhekar
* 2023-08-27      
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
@IsTest(seeAllData = false)
public with sharing class SendNPSDataTest {

    @TestSetup
    public static void testSetup(){
        // Insert Account
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        //Insert Contact
        Contact con = new Contact();
        con.AccountId= a.Id;
        con.LastName = 'Test User';
        con.Email = 'CustomerExample@Example.com';
        insert con;

        // Insert Product
        Product2 product = new Product2();
        product.Name = ' Test Product ';
        product.Description='Test 1';
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
        order.Name = 'Test Order ';
        order.Status = 'Draft';
        order.EffectiveDate = system.today();
        order.EndDate = system.today() + 4;
        order.AccountId = a.id;
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
        Profile profile =[Select Id from Profile where Name='System Administrator'];
        User usr = new user(Alias ='Test1', EmailEncodingKey='UTF-8', LastName='Testing',
                            LanguageLocaleKey='en_US', LocaleSidKey = 'en_US', ProfileId = profile.Id,
                            TimeZoneSidKey='America/Los_Angeles', Email='Testinguser@test.com',
                            userName='TestUser894721@testuser123.com');
                    insert usr;
        Account acc = [Select Id From Account where Name = 'Test Account'];
        Order ord = [select Id, Name, Status, AccountId from Order where AccountId =: acc.Id];
        List<Id> orderId = new List<Id>();
        orderId.add(ord.Id);
        Assert.areEqual(1, ord == null ? 0 : 1,'One Order');
        Test.startTest();
        system.runAs(usr){
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200));
            SendNpsData.sendData(orderId);
        }
}
@IsTest
public static void negativeTest() {
    Profile profile =[Select Id from Profile where Name='System Administrator'];
    User usr = new user(Alias ='Test1', EmailEncodingKey='UTF-8', LastName='Testing',
                        LanguageLocaleKey='en_US', LocaleSidKey = 'en_US', ProfileId = profile.Id,
                        TimeZoneSidKey='America/Los_Angeles', Email='Testinguser@test.com',
                        userName='TestUser894721@testuser123.com');
                insert usr;
    Account acc = [Select Id From Account where Name = 'Test Account'];
    Order ord = [select Id, Name, Status, AccountId from Order where AccountId =: acc.Id];
    Assert.areEqual(1, ord == null ? 0 : 1,'One Order');
    List<Id> orderId = new List<Id>();
    orderId.add(ord.Id);
    Test.startTest();
    system.runAs(usr){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(400));
        SendNpsData.sendData(orderId);
    }
}
@isTest
public static void exceptionTest() {
    Profile profile =[Select Id from Profile where Name='System Administrator'];
    User usr = new user(Alias ='Test1', EmailEncodingKey='UTF-8', LastName='Testing',
                        LanguageLocaleKey='en_US', LocaleSidKey = 'en_US', ProfileId = profile.Id,
                        TimeZoneSidKey='America/Los_Angeles', Email='Testinguser@test.com',
                        userName='TestUser894721@testuser123.com');
                insert usr;
   
    Test.startTest();
    system.runAs(usr){
        try{
             Account a = new Account();
            insert a;
        }
        catch(Exception e){
            NPSCallout.logError(e);
        }
    }
}
}