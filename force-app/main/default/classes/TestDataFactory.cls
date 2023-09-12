@isTest
public class TestDataFactory {

    public static List<Order> setupDataForCallout(Integer orderCount) {
        List<Account> acctList = CreateAccount(1);
        Id acctId = acctList[0].Id;
        List<Contract> cntrctList = CreateContract(1, acctId);
        Id cntractId = cntrctList[0].Id;
        List<Contact> cntctList = CreateContact(1, acctId);
        Id cntctId = cntctList[0].Id;
        Id pbId = Test.getStandardPricebookId();
        List<Order> orderList = CreateOrder(orderCount, acctId, cntractId, cntctId, pbId);
        Id ordId = orderList[0].Id;
        List<OrderItem> oiList = CreateOrderItem(1,ordId);
        return orderList;
    }

    public static List<Account> CreateAccount(Integer count){
        List<Account> acctList = new List<Account>();
        for(Integer i=0; i<count; i++){
            Account acct = new Account();
            acct.Name = 'Test' + i ;
            acctList.add(acct);
        }
        insert acctList;
        return acctList;
    }

    public static List<Contract> CreateContract(Integer count, Id acctId){
        List<Contract> cntrctList = new List<Contract>();
        List<Contract> cntrctListUpdateStatus = new List<Contract>();
        for(Integer i=0; i<count;i++){
            Contract cntrct = new Contract();
            cntrct.AccountId = acctId ;
            cntrct.Status = 'Draft';
            cntrct.StartDate = date.today();
            cntrct.ContractTerm = 6 + i;
            cntrctList.add(cntrct);
        }
        insert cntrctList;
        Set<Id> cntrctId = new Set<Id>();
        for(Contract c : cntrctList){
            cntrctId.add(c.Id);
        }
        cntrctListUpdateStatus = [Select Id, Status from Contract where Id in :cntrctId];
        for(Contract c : cntrctListUpdateStatus){
            c.Status = 'Activated';
        }
        update cntrctListUpdateStatus;
        return cntrctListUpdateStatus;
    }

    public static List<Contact> CreateContact(Integer count, Id acctId){
        List<Contact> cntctList = new List<Contact>();
        for(Integer i=0; i<count; i++){
            Contact cntct = new Contact();
            cntct.LastName = 'Test' + i ;
            cntct.AccountId = acctId;
            cntct.Email = 'test' + i + '@gmail.com';
            cntctList.add(cntct);
        }
        insert cntctList;
        return cntctList;
    }

    public static List<Order> CreateOrder(Integer count, Id acctId, Id cntractId, Id cntctId, Id pbId) {
        List<Order> orderList = new List<Order>();
        for(Integer i=0; i<count; i++){
            Order ord = new Order();
            ord.Status = 'Draft';
            ord.AccountId = acctId;
            ord.EffectiveDate = Date.today();
            ord.ContractId = cntractId;
            ord.CustomerAuthorizedById = cntctId;
            ord.Pricebook2Id = pbId;
            orderList.add(ord);
        }
        insert orderList;
        System.debug('orderList: ' + orderList);
        return orderList;
    }

    public static List<OrderItem> CreateOrderItem(Integer count, Id orderId){
        List<Product2> prd2List = CreateProduct(1);
        Id prd2Id = prd2List[0].Id;
        List<PricebookEntry> pbeList = CreatePriceBookEntry(1, prd2Id);
        Id pbeId = pbeList[0].Id;
        List<OrderItem> oiList = new List<OrderItem>();
        for(Integer i=0; i<count; i++){
            OrderItem oi = new OrderItem();
            oi.OrderId = orderId;
            oi.Product2Id = prd2Id;
            oi.UnitPrice = 1000;
            oi.PricebookEntryId = pbeId;
            oi.Quantity = i + 1;
            oiList.add(oi);
        }
        insert oiList;
        return oiList;
    }


    public static List<Product2> CreateProduct(Integer count){
        List<Product2> prdList = new List<Product2>();
        for(Integer i=0; i<count; i++){
            Product2 prd = new Product2();
            prd.Name = 'Test' + i ;
            prdList.add(prd);
        }
        insert prdList;
        return prdList;
    }

    public static List<PricebookEntry> CreatePriceBookEntry(Integer count, Id prd2Id){
        Id standardPB = Test.getStandardPricebookId();
        List<PricebookEntry> pbeList = new List<PricebookEntry>(); 
        for(Integer i=0; i<count; i++){
            PricebookEntry pbe = new PricebookEntry();
            pbe.Pricebook2Id = standardPB;
            pbe.Product2Id = prd2Id;
            pbe.UnitPrice = 1000;
            pbe.IsActive = true;
            pbeList.add(pbe);
        }
        insert pbeList;
        return pbeList;
    }
}