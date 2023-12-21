@isTest
private class OrderSelectorTest {
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
    @isTest
    private static void testSelectByIds(){
        Order orderRecord=[SELECT Id FROM Order LIMIT 1];
        List<Order> listOfOrders=new OrderSelector().selectByIds(new List<Id>{orderRecord.Id});
        Assert.areEqual(1,listOfOrders.size());
        Assert.areEqual('test@email.com',listOfOrders[0].BillToContact.Email);
    }
}