@isTest
private class InterviewTest {
    @isTest
    static void testCallout() {
      List<Order> Orders = new List<Order>{ new Order(AccountId='0017Q00000gghWuQAI', EffectiveDate=Date.newInstance(2023, 02, 18), ContractId='8007Q000000DiqeQAC',  Status='Draft')};
      insert Orders;
      List<Id> OrderIds = new List<Id>();
         for(Order o : orders){
             OrderIds.add(o.id);
         }
        
      Test.setMock(HttpCalloutMock.class, new MockGenerator());
         
      Test.startTest();    
      Interview.sendNPSScore(OrderIds);  
      Test.stopTest();   
       
    }
}
