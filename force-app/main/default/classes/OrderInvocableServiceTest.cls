@isTest
public class OrderInvocableServiceTest {
	private final static String USER_NAME_ADMIN = 'systemadministrator_test@baesystems.com';
    
    @TestSetup
    public static void setup() {
        User adminUser = DataPopulator.createAdminUser();
        adminUser.UserName = USER_NAME_ADMIN;
        insert adminUser;
    }
    
    @isTest static void testInvokeOrderNPSCallout() {
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
            
            contact = DataPopulator.createContact(account.Id);
            insert contact;
            
            order = DataPopulator.createOrder(account.Id, contract.Id, contact.Id);
            insert order;
            orderIds.add(order.Id);
            
            Test.startTest();
            OrderInvocableService.invokeOrderNPSCallout(orderIds);
            Test.stopTest();
        }
    }
}