@isTest
public class PostNPSsDataOnOrderUpdateTest {
    
    @testSetup static void setup() {
        Product2 p = new Product2();
        p.Name = 'Test Product';
        p.Description='Test Product';
        p.productCode = 'ABC';
        p.isActive = true;
        insert p;
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = Test.getStandardPricebookId();
        standardPrice.Product2Id = p.Id;
        standardPrice.UnitPrice = 100;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice ;
        
        Account acc = new Account(
            Name = 'Test Account'
        );
        insert acc;
        
        List<Order> testOrders = new List<Order>();
        for(Integer i=0;i<67;i++) {
            testOrders.add(new Order(EffectiveDate = System.today(),Status = 'Draft',	
                                     AccountId = acc.Id,
                                     PriceBook2Id = Test.getStandardPricebookId()));
        }
        insert testOrders;
        
        List<OrderItem> lineItemList = new List<OrderItem>();
        for(order o : testOrders){
            OrderItem lineItem = new OrderItem();
            lineItem.OrderId = o.id;
            lineItem.Quantity = 24;
            lineItem.UnitPrice = 240;
            lineItem.Product2id = p.id;
            lineItem.PricebookEntryId=standardPrice.id;
            lineItemList.add(lineItem);
        }
        insert lineItemList;
    }
    
    @isTest static void updateTest() {
        List<Order> orderList = [SELECT Id,status FROM Order];
        List<Id> orderToUpdate = new List<Id>();
        for(order ord : orderList){
            ord.status = 'Fulfilled';
            orderToUpdate.add(ord.Id);
        }
        //update orderToUpdate;
        PostNPSsDataOnOrderUpdate.MakeCallout(orderToUpdate);
        
    }
 

}