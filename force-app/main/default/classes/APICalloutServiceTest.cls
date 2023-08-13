/**
 * @description       : This is a test class for unit testing of Callout Service from the Invocable Service
 * @created by		  : Ravikishore Tekuri	
 * @created on  	  : 14-08-2023
 * @last modified on  : 14-08-2023
**/

@isTest
public class APICalloutServiceTest {
    private final static String USER_NAME_ADMIN = 'systemadministrator_test@baesystems.com';
    
    class HttpCallout implements HttpCalloutMock {
        HttpResponse response;
        HttpCallout(HttpResponse response) {
            response = response;
        }
        public HttpResponse respond(HttpRequest request) {
            return response;
        }
    }
    
	@TestSetup
    public static void setup() {
        User adminUser = DataPopulator.createAdminUser();
        adminUser.UserName = USER_NAME_ADMIN;
        insert adminUser;
    }
    
    @isTest static void testCustomerNotification() {
        User adminUser = [SELECT Id FROM User WHERE UserName =: USER_NAME_ADMIN];
        Account account = new Account();
        Contract contract = new Contract();
        Contact contact = new Contact();
        Order order = new Order();
        List<Id> orderIds = new List<Id>();
        
        System.runAs(adminUser) {
            account = DataPopulator.createAccount();
            insert account;
            
            contract = DataPopulator.createContract(account.Id);
            insert contract;
            contract.Status = 'Activated';
            update contract;
            
            contact = DataPopulator.createContact(account.Id);
            insert contact;
            
            order = DataPopulator.createOrder(account.Id, contract.Id, contact.Id);
            insert order;
            orderIds.add(order.Id);
            
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
        	response.setStatusCode(200);
            
            Test.setMock(HttpCalloutMock.class, new HttpCallout(response));
            
            Test.startTest();
            OrderInvocableService.invokeOrderNPSCallout(orderIds);
            Test.stopTest();
        }
    }
}