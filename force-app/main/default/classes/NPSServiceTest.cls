@istest
public class NPSServiceTest {
    @TestSetup
    static void testSetup(){
    Account acc = new account(Name='TestAccount');
    insert acc;
    Contract con = new contract(Status ='Draft',StartDate = date.today(),ContractTerm =1, AccountId = acc.id);
    insert con;
    con.Status ='Activated';
    update con;
    List<order> orders = new List<order>();
        order o1 = new order(ContractId=con.id,status='Draft',AccountId=acc.id,EffectiveDate=date.today());
        order o2 = new order(ContractId=con.id,status='Draft',AccountId=acc.id,EffectiveDate=date.today());
        orders.add(o1);
        orders.add(o2);
        insert orders;      
    }
    @istest
    public static void testSuccess(){
        List<id> orderIds = new List<id>();
        List<order> orders = [select id from order limit 10];
        for(order o : orders)
        {
            orderIds.add(o.id);
        }
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new npsMock('200'));
        NPSService.sendOrdersToNPS(orderIds);
        Test.stopTest();       
  }
    @istest
    public static void testException(){
        List<id> orderIds = new List<id>();
        List<order> orders = [select id from order limit 10];
        for(order o : orders)
        {
            orderIds.add(o.id);
        }
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new npsMock('400'));
        NPSService.sendOrdersToNPS(orderIds);
        Test.stopTest();       
  }
}