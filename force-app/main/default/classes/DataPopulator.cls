/**
 * @description       : This is a DataPopulator Class that contains several methods to return SObjects ann to be used in Apex Test classes
 * 						- returns Admin User details that is going to insert in Apex Test Classes
 * 						- returns Account details that is going to insert in Apex Test Classes
 * 						- returns Customer Contact details that is going to insert in Apex Test Classes
 * 						- returns Contract details that is going to insert in Apex Test Classes
 * 						- returns Order details that is going to insert in Apex Test Classes
 * @created by		  : Ravikishore Tekuri	
 * @created on  	  : 14-08-2023
 * @last modified on  : 14-08-2023
**/

public class DataPopulator {
	private static final String SYSTEM_ADMIN_PROFILE_NAME = 'System Administrator';
    
    public static User createAdminUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name = :SYSTEM_ADMIN_PROFILE_NAME WITH SECURITY_ENFORCED];
        
        User user = new User();
        user.Email = 'systemadministrator_test@baesystems.com';
        user.ProfileId = p.Id;
        user.UserName = 'systemadministrator_test@baesystems.com.test';
        user.LastName = 'System Administrator';
        user.Alias = 'SyAdm';
        user.TimeZoneSidKey = 'GMT';
        user.LocaleSidKey = 'en_US';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        
        return user;
    }
    
    public static Account createAccount() {
        Account account = new Account();
        account.Name = 'First Account';
        
        return account;
    }
    
    public static Contract createContract(Id accountId) {
        Date todaysDate = Date.today();
        Contract contract = new Contract();
        contract.Name = 'First Contract';
        contract.AccountId = accountId;
        contract.StartDate = todaysDate;
        contract.ContractTerm = 24;
        contract.Status = 'Draft';
        
        return contract;
    }
    
    public static Contact createContact(Id accountId) {
        Contact contact = new Contact();
        contact.LastName = 'Customer Contact';
        contact.AccountId = accountId;
        contact.Email = 'customerbillto@test.com';
            
        return contact;
    }
    
    public static Order createOrder(Id accountId, Id contractId, Id contactId) {
        Date todaysDate = Date.today();
        Order order = new Order();
        order.AccountId = accountId;
        order.ContractId = contractId;
        order.BillToContactId = contactId;
        order.Status = 'Draft';
        order.EffectiveDate = todaysDate;
        
        return order;
    }
}