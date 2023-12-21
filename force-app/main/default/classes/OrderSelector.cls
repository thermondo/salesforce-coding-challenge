public  inherited sharing class  OrderSelector  {
   /** @description: fetch Order records based Order Ids
     * @param : listOfOrderIds list of Order Ids to fetch
     * @return : List<Order> list Of Order records
     **/
    public List<Order> selectByIds(List<Id> listOfOrderIds){  
        return [SELECT Id,BillToContact.Email, OrderNumber,BillToContactId FROM ORDER WHERE Id IN :listOfOrderIds ]; 
    }
}