@isTest
public class InvocableNPSServiceCalloutTest {
    
    @testSetup
    static void prepareData(){
        
        //Create Account for Order
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        //Create Billing Contact for Order
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.Email = 'test@test.com';
        con.AccountId = acc.Id;
        
        //Create Order
        Order ord = new Order();
        ord.AccountId = acc.Id;
        ord.BillToContactId = con.Id;
        ord.Status = 'Draft';
        ord.EffectiveDate = system.TODAY();
        insert ord;
    }
    
    @isTest
    static void testSendOrderDataToServiceSuccess(){
        Order orderToTest = [SELECT id, BillToContact.Email, OrderNumber FROM Order LIMIT 1];
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('sendOrderToNPSSuccess'));
        InvocableNPSServiceCallout.sendOrderDataToService(new List<Order>{orderToTest});
        InvocableNPSServiceCallout.sendEmailToApexExceptionRecipients('errorMessage');
        Test.stopTest();
    }
    
    @isTest
    static void testSendOrderDataToServiceFailure(){
        Order orderToTest = [SELECT id, BillToContact.Email, OrderNumber FROM Order LIMIT 1];
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('sendOrderToNPSFailure'));
        InvocableNPSServiceCallout.sendOrderDataToService(new List<Order>{orderToTest});
        InvocableNPSServiceCallout.sendEmailToApexExceptionRecipients('errorMessage');
        Test.stopTest();
    }

}