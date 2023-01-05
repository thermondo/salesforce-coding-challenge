@isTest
public class OrderNpsInvocableActionTest {

    @testSetup static void setup() {

       //To do : Data setup with all the releted records . Below created data may not represt teh real schema , intention is to cover the implemented code in the assignment
       Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
      
       Account testPersonAccount = new Account(FirstName = 'testAccountName',LastName= 'testAccountLastName' , RecordTypeId = personAccountRecordTypeId, PersonEmail='testaccountholder@abc.com');
       insert testPersonAccount;  
       
       Contract testContract = new Contract(AccountId=testPersonAccount.Id,ContractTerm=10,Status='Draft',StartDate=date.newinstance(2023, 01, 01));
       insert testContract;


       Product2 testProduct = new Product2(name='sample product' , IsActive=true);
       insert testProduct;

       Order testOrder = new Order(AccountId=testPersonAccount.Id,EffectiveDate=date.newinstance(2023, 01, 01),Status='Draft',ContractId=testContract.Id,Pricebook2Id=Test.getStandardPricebookId());
       insert testOrder;

        // insert  PriceBookEntry
        PriceBookEntry testPriceBookEntry = new PriceBookEntry();
        testPriceBookEntry.Product2Id=testProduct.Id;
        testPriceBookEntry.Pricebook2Id=Test.getStandardPricebookId();
        testPriceBookEntry.UnitPrice=2000;
        testPriceBookEntry.IsActive=true;
        insert testPriceBookEntry;

        //Activate the contract
        testContract.Status='Activated';
        update testContract;
    }

//To Do : Statndard integration tests for multiple status codes .Creation of test factory
    @isTest
    static void orderNpsInvocableActionMethodSuccessTest(){
        Id orderId =  [SELECT Id from Order limit 1].Id;
        Test.setMock(HttpCalloutMock.class, new OrderNpsHttpCalloutSuccessMock()); 

        Test.startTest();
        List<String> actualResponse = OrderNpsInvocableAction.sendNpsRequest(new List<String>{orderId});
        String expectedResponse = '[{"SUCCESS"}]';
        Test.stopTest();

        System.assertEquals(expectedResponse, actualResponse[0],'Incorrect Success response');
    }
   
    @isTest
    static void orderNpsInvocableActionMethodFailTest(){
        Id orderId =  [SELECT Id from Order limit 1].Id;
        Test.setMock(HttpCalloutMock.class, new OrderNpsHttpCalloutFailMock()); 
       
        Test.startTest();
        List<String> actualResponse = OrderNpsInvocableAction.sendNpsRequest(new List<String>{orderId});
        String expectedResponse = '[{"SERVER_ERROR"}]';
        Test.stopTest();
        
        System.assertEquals(expectedResponse, actualResponse[0],'Incorrect failed response');

    }
}
