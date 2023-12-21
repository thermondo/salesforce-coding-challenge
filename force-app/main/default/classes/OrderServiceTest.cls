@isTest
public class OrderServiceTest {
    @testSetup
      private static void setupTestData(){
        Contact contactRecord=new Contact();
        contactRecord.LastName='TestLastName';
        contactRecord.Email='test@email.com';
        insert contactRecord;
        Account accountRecord=new Account(name='OrderTestAccount',phone='1769393638');
        insert accountRecord;
        Contract contractRecord=new Contract(AccountId=accountRecord.Id,Status='Draft',StartDate=System.today(),ContractTerm=7);
        insert contractRecord;
        Order orderRecord=new Order();
        orderRecord.BillToContactId=contactRecord.Id;
        orderRecord.AccountId=accountRecord.id;
        orderRecord.ContractId=contractRecord.Id;
        orderRecord.Status='Draft';
        orderRecord.EffectiveDate=System.today();
        insert orderRecord;
      }
    @IsTest
    public static void buildOrderDataWrapperFromOrderTest(){
        List<Order> listOfOrdersToProcess=[SELECT Id,BillToContact.Email,OrderNumber FROM ORDER];
        List<OrderDataWrapper> listOfordersToUpdateWrap=OrderService.buildOrderDataWrapperFromOrders(listOfOrdersToProcess);
        Assert.areEqual(listOfOrdersToProcess[0].Id,listOfordersToUpdateWrap[0].sfId);
        Assert.areEqual(listOfOrdersToProcess[0].BillToContact.Email,listOfordersToUpdateWrap[0].customerEmail);
        Assert.areEqual(listOfOrdersToProcess[0].OrderNumber,listOfordersToUpdateWrap[0].orderNumber);
    }
    @IsTest
    public static void updateNpsFailedRecordsPositiveTest(){
        List<Order> listOfOrdersToProcess=[SELECT Id,BillToContact.Email,OrderNumber FROM ORDER];
        List<OrderDataWrapper> listOfordersToUpdateWrap=OrderService.buildOrderDataWrapperFromOrders(listOfOrdersToProcess);
        Test.startTest();
        OrderService.updateNpsFailedRecords(listOfordersToUpdateWrap);
        Test.stopTest();
        Order orderRecWithFailedFlag=[SELECT Id,isOrderSendToNpsFailed__c FROM Order WHERE Id=:listOfordersToUpdateWrap[0].sfId];
        Assert.isTrue(orderRecWithFailedFlag.isOrderSendToNpsFailed__c);
    }


}