/**
  *@description: Serbice class to support order object
  *@author: N. Chittemma
  **/
public class OrderService {
   /** @description: flag orders failed to sync with NPS Order records based Order Ids
     * @param : failedOrdersWrappersToUpdate list of Order data wrappers  to update
     **/
	public static void updateNpsFailedRecords(List<OrderDataWrapper> failedOrdersWrappersToUpdate){
        List<Order> listOfOrdersToUpdateAsFailed=new List<Order>();
        for(OrderDataWrapper OrderDataWrapperRecord:failedOrdersWrappersToUpdate){
            Order orderRecord=new Order(Id=OrderDataWrapperRecord.sfId,isOrderSendToNpsFailed__c=True);// Will hepls to identify the Failed NPS orders for later use                                     
            listOfOrdersToUpdateAsFailed.add(orderRecord);
        }
        if(listOfOrdersToUpdateAsFailed.isEmpty()){
           // throw new OrderServiceException('OrderData is missing to flag NPS failure') ;//log if needed
        }
        try{
        	update listOfOrdersToUpdateAsFailed;
        }
        catch(exception ex){
            string errorMessage='Failed to update order data'+ex.getMessage();
            //add logging with trace or rethrow OrderServiceException based on requirement
            throw new OrderServiceException(errorMessage);
        }
    }
   /** @description: flag ordrs filed to sync with NPS Order records based Order Ids
     * @param : listOfOrdersToPrepare  list of Order to convert as order data wrappers 
     * @return :listOfOrderDataWrapper list of build order data wrappers
     **/
	public static List<OrderDataWrapper> buildOrderDataWrapperFromOrders(List<Order> listOfOrdersToPrepare){
        List<OrderDataWrapper> listOfOrderDataWrapper=new List<OrderDataWrapper>();
        for (Order orderRecordToBuildWrapper:listOfOrdersToPrepare){
            OrderDataWrapper orderDataWrapperInstance=new OrderDataWrapper(orderRecordToBuildWrapper.Id,
                                                                           orderRecordToBuildWrapper.BillToContact.Email,
                                                                           orderRecordToBuildWrapper.OrderNumber
                                                                          );
            listOfOrderDataWrapper.add(orderDataWrapperInstance);
        }
        return listOfOrderDataWrapper;
    }
    public class OrderServiceException extends exception{}
}