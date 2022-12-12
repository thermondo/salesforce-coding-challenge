/**
 * Unit Test to Test "syncOrdersToNSPService" Invocable Annotations
 * mocks HttpCalloutMock for a Mock Test
 * @author Shakil Ahmad (shakil.mr.ahmad@gmail.com)
 */


@isTest
private class orderSyncNPSAPIConnectorTest {

    static final RecordType PERSONACCOUNTRECORDTYPE = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'];

    @isTest
    private static void testOrderSyncNPSAPIConnector(){

        TestUtils.insertAuthorizationToken();
        Test.setMock(HttpCalloutMock.class, new ThermondoNPSAPIOrderSyncCalloutMock());
        List<syncOrdersToNSPService.orderSyncRequest> orderSyncRequests = new List<syncOrdersToNSPService.orderSyncRequest>();
        syncOrdersToNSPService.orderSyncRequest oOrderSyncRequest = prepareOrderSyncRequest();
        orderSyncRequests.add(oOrderSyncRequest);

        Test.startTest();
        List<syncOrdersToNSPService.orderSyncResult> oOrderSyncResponse = syncOrdersToNSPService.syncOrders(orderSyncRequests);
        Test.stopTest();

        System.assert(oOrderSyncResponse[0].isSuccess, 'The success status should be true');

        System.debug('Test Result: '+ oOrderSyncResponse);

    }


    private class ThermondoNPSAPIOrderSyncCalloutMock implements HttpCalloutMock{
        public HTTPResponse respond(HTTPRequest request){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            response.setBody('{'
                                 +'"sfId": 8015E000003LfJXQA0,'
                                 +'"orderNumber": 007,'
                                 +'"customerEmail": "customerAddress@example.com"'
                                 +'}'
                            +'}');              
            response.setStatusCode(200);
            return response;
        }
    }

    private static syncOrdersToNSPService.orderSyncRequest prepareOrderSyncRequest(){
        

        Account account = new Account(RecordTypeId = PERSONACCOUNTRECORDTYPE.Id,
        FirstName = 'Ther', LastName='mondo', PersonEmail='codingchallenge@thermondo.com'      
        );
        insert account;

        Contract contact = new Contract(
            AccountId = account.Id,
            Status = 'Draft',
            StartDate = Date.today(),
            ContractTerm = 30
        );
        insert contact;

        Order newOrder = new Order();
        newOrder.EffectiveDate = Date.today();
        newOrder.Status = 'Draft';
        newOrder.AccountId = account.Id;
        newOrder.ContractId = contact.Id;
        insert newOrder;

        syncOrdersToNSPService.orderSyncRequest oOrderSyncRequest = new syncOrdersToNSPService.orderSyncRequest();
        oOrderSyncRequest.order = newOrder;
        return oOrderSyncRequest;
    }

}
