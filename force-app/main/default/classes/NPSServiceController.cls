/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This apex class is used Create in Flow to Send Data to the NPS Service.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Nitish Bhardwaj
* @version        1.0
* @created        2023-12-21
* @modified       2023-12-21
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public without sharing class NPSServiceController {
   
    @InvocableMethod(label='Send Order to NPS')
    public static void sendOrderDataToNps(List<Id> orderIdList)
    {
        Map<Id,order> orderMap  = new Map<Id,Order>([SELECT ID, BillToContactId, BillToContact.Email, OrderNumber 
                                FROM ORDER WHERE ID IN : orderIdList AND NPS_Response_Status__c = null AND BillToContactId != null
                                ]);
        if(orderMap.isEmpty()){
            return;
        }
        List<NPSResponseWrapper> OrderNPSApiWrapperList = new List<NPSResponseWrapper>();
        try{
            for(id eachId : orderIdList){

                String id = eachId;
                String orderNumber = orderMap.get(eachId)?.OrderNumber;
                String contactEmail = orderMap.get(eachId)?.BillToContact?.Email;
                NPSResponseWrapper npsWrapper = new NPSResponseWrapper(id,orderNumber,contactEmail);
                OrderNPSApiWrapperList.add(npsWrapper);
            }

            if(!OrderNPSApiWrapperList.isEmpty())
            {
                NPSCallOutService.callOutToNps(JSON.serialize(OrderNPSApiWrapperList));
                // Call Future method to Avoid uncommented Work pending exception
            }
        }
        catch(exception ex){
            ErrorLogging log = new ErrorLogging(ex,'NPSServiceController','sendOrderDataToNps');
            log.insertErroLog();
        }
    }
}