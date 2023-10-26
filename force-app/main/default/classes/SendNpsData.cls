/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This apex class is used Create Data for NPS API Callout.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Saurao Londhekar
* @modifiedBy     Saurao Londhekar
* @maintainedBy   Saurao Londhekar
* @version        1.0
* @created        2023-10-22
* @modified       2023-10-22
* @systemLayer    Service
* @see            ????
* @see            ????
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes        Send Data to NPS API
* v1.0            Saurao Londhekar
* 2023-08-27      
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public with sharing class SendNpsData {

    @InvocableMethod(label='Send Order to NPS App' description='Send Order to NPS App')
    public static void sendData(List<Id> orderIds){
        //SendNPSDataWrapper.NPSCalloutOutput objNPsCalloutOutput ;
        //List<SendNPSDataWrapper.NPSCalloutOutput> outputList = new List<SendNPSDataWrapper.NPSCalloutOutput>();
        List<SendNPSDataWrapper> dataToSend = new List<SendNPSDataWrapper>();
        Map<Id, String> userEmailMap = new Map<Id, String>();
        string strOrderDataJSON;
        try{
            
            List<Order> orderList = [Select Id, orderNumber, AccountId from Order where Id IN: orderIds WITH SECURITY_ENFORCED ];
            Set<Id> accId = new Set<Id>();
            for(Order order : orderList){
                if(!accId.contains(order.AccountId)){
                    accId.add(order.AccountId);
                }
            }
            List<Contact> contactList = [Select Id, Email, AccountId from Contact where AccountId IN: accId WITH SECURITY_ENFORCED];
            for(Contact con : contactList){
                if(con.Email != null){
                //considering every account has one contact and to that email field is not Empty.
                    userEmailMap.put(con.AccountId, con.Email);
                }    
            }
            for(Order order : orderList){
                String customerEmail = userEmailMap.get(order.AccountId);
                SendNPSDataWrapper npsData = new SendNPSDataWrapper(order.Id, order.orderNumber, customerEmail);
                dataToSend.add(npsData);
            }

                strOrderDataJSON = JSON.serialize(dataToSend);
                system.debug('data to send--'+strOrderDataJSON);
                NPSCallout.callout(strOrderDataJSON, orderIds);

            //outputList.add(objNPsCalloutOutput);
            //return outputList;
        }
        catch(Exception e){
           NPSCallout.logError(e); 
        }
    }
        
       

        

        
    
}