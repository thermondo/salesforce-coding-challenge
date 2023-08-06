/**
 * @description       : To fetch Order that has status 'fullfilled' and send the order details to NPS Service
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-06-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class OrderDetails {

    @InvocableMethod(label='Send Orders' description='sends the specified order to NPS service')
    public static void fetchAndSerializeOrderDetails(List<String> orderIds){
        try {
            List<OrderDetails.CustomOrder> custOrders=new List<OrderDetails.CustomOrder>();
            OrderDetails.CustomOrder custOrd;
            List<Order> orders;
            List<String> accIds = new List<String>();
            Map<String, String> accountToContactEmailMap = new Map<String,String>();
           
                orders = [SELECT Id, orderNumber, AccountId FROM Order WHERE Id IN :orderIds];
                if(!orders.isEmpty()){
                    for(Order ord:orders){
                        System.debug('Inside B');
                        accIds.add(ord.AccountId);
                    }

                    System.debug('Outside B');
                for(Contact cnt: [SELECT Id, AccountId, Email FROM Contact WHERE AccountId =: accIds]){
                    if(cnt.Email !=null){
                        System.debug('Inside C');
                        accountToContactEmailMap.put(cnt.AccountId, cnt.Email);
                    }
                }
                System.debug('Outside C');
                for(Order ord:orders){
                    System.debug('Inside D');
                    custOrd = new OrderDetails.CustomOrder();
                    custOrd.sfId = ord.Id;
                    custOrd.orderNumber = ord.OrderNumber;
                    //considering only one contact is related to the account.
                    custOrd.customerEmail = accountToContactEmailMap.get(ord.AccountId)!=null? accountToContactEmailMap.get(ord.AccountId):'';
                        if(custOrd !=null){
                            custOrders.add(custOrd);
                            System.debug('Inside E');
                        }
                }                         
            }
            System.debug('Outside E');
            String orderToreturn = JSON.serializePretty(custOrders);
            //Call a Post service to send the serialzed data
            NpsCalloutService.makePostCallout(orderToreturn);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    } 

    public class CustomOrder{

        private String sfId{get;set;}
        private String orderNumber{get;set;}
        private String customerEmail{get;set;}
    }
}