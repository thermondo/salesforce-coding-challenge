@isTest
public class OrderNpsInvocableActionTest {

    @testSetup static void setup() {
       Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
      
       Account acc = new Account(FirstName = 'testAccountName',LastName= 'testAccountLastName' , RecordTypeId = personAccountRecordTypeId, PersonEmail='testaccountholder@abc.com');
       insert acc;    
        
       Order testOrder = new Order(AccountId=acc.Id,EffectiveDate=date.newinstance(2023, 01, 01),Status='Draft');
       insert testOrder;

    }

    @isTest
    static void orderNpsInvocableActionMethodSuccessTest(){
        Id orderId =  [SELECT Id from Order limit 1].Id;
        Test.setMock(HttpCalloutMock.class, new OrderNpsHttpCalloutSuccessMock()); 

        Test.startTest();
        List<String> actualResponse = OrderNpsInvocableAction.sendNpsRequest(new List<String>{orderId});
        String expectedResponse = '[{"Description": "SUCCESS"}]';
        Test.stopTest();

        System.assertEquals(expectedResponse, actualResponse[0],'Integration is returning incorrect response');
    }
   
    @isTest
    static void orderNpsInvocableActionMethodFailTest(){
        Id orderId =  [SELECT Id from Order limit 1].Id;
        Test.setMock(HttpCalloutMock.class, new OrderNpsHttpCalloutFailMock()); 
       
        Test.startTest();
        List<String> actualResponse = OrderNpsInvocableAction.sendNpsRequest(new List<String>{orderId});
        String expectedResponse = '[{"Description": "SERVER_ERROR"}]';
        Test.stopTest();
        
        System.assertEquals(expectedResponse, actualResponse[0],'Integration is returning incorrect response');

    }
}
