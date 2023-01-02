/*
 * Test class for Thermondo_InvocableAction.
 * 
 * @author Narek Petrosyan
 * @version 1.0
 * @created 30.12.2022
 *  
*/

@isTest
public class Thermondo_InvocableAction_Test {
	@testSetup
    public static void setup() {
        
        // TODO: create a test data factory class for all these objetcs
 		Account testAccount = new Account(FirstName = 'Test Name', LastName = 'Test Last Name', PersonEmail = 'a_test_email_adderss@testhost.com');
		testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        insert testAccount;
        
        Contract testContract = new Contract(AccountId = testAccount.id, Status = 'Draft', ContractTerm = 999, StartDate = Date.newInstance(2010, 01, 01));
        insert testContract;      
        // must be done this way
        testContract.Status = 'Activated';
        update testContract;    
        
        Product2 testProduct = new Product2(Name = 'Test Product', IsActive = true);
        insert testProduct;
        
        Order testOrder = new Order(Status = 'Draft', AccountId = testAccount.Id, ContractId = testContract.Id, EffectiveDate = Date.newInstance(2030, 01, 01));
        testOrder.Pricebook2Id = Test.getStandardPricebookId();
        insert testOrder; 
        
        PriceBookEntry testBookEntry = new PriceBookEntry(Product2Id = testProduct.Id, IsActive = true, UnitPrice = 100, Pricebook2Id = Test.getStandardPricebookId());
        insert testBookEntry;        
        
        OrderItem testOrderItem = new OrderItem(Product2Id = testProduct.Id, OrderId = testOrder.Id, PricebookEntryId = testBookEntry.Id, UnitPrice = 100, Quantity = 1);
		insert testOrderItem;      
        
        testOrder.Status = 'Activated';
        update testOrder;        
    }
    
    @isTest
    public static void testPositive() {
        Test.startTest();
        Order oneOrder = [SELECT Id FROM Order LIMIT 1].get(0);
        system.debug('here');
        system.debug(oneOrder);
        system.debug(new List<Id>{oneOrder.Id});
        Thermondo_InvocableAction.getIDs(new List<Id>{oneOrder.Id});        
        Test.stopTest();
    } 
    
    @isTest
    public static void testPositiveMissingIDs() {
        Test.startTest();
        List<String> result = Thermondo_InvocableAction.getIDs(new List<Id>());
        System.AssertEquals(result.get(0), 'Please provide a valid ID');
        Test.stopTest();
    }     
}