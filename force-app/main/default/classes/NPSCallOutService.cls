/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This apex class is used to Post the Data To the NPS System
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Nitish Bhardwaj
* @version        1.0
* @created        2023-12-21
* @modified       2023-12-21
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public with sharing class NPSCallOutService {
    @future(callout=true)
    public static void callOutToNps(String npsResponseWrapperString){
                
        try{
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:salesforce_coding_challenge_Api');
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('POST');
            req.setBody(npsResponseWrapperString);
            Http http = new Http();
            List<NPSResponseWrapper> npsResponseWrapperList = new List<NPSResponseWrapper>();
            npsResponseWrapperList = (List<NPSResponseWrapper>)JSON.deserialize(npsResponseWrapperString,List<NPSResponseWrapper>.class);
            HttpResponse response = http.send(req);
            Integer responseCode =  response.getStatusCode();
            
            if(responseCode==200)
            {
                updateOrderResponse(npsResponseWrapperList,'Success');
            }else {
                ErrorLogging log = new ErrorLogging(response,'NPSServiceController','callOutToNps',JSON.serialize(npsResponseWrapperList),'Fail');
                log.insertErroLog();
                updateOrderResponse(npsResponseWrapperList,'Error');
            }
            
            
        }
        catch(Exception ex){
            ErrorLogging log = new ErrorLogging(ex,'NPSCallOutService','callOutToNps');
            log.insertErroLog();
        }
        
    }
    public static void updateOrderResponse(List<NPSResponseWrapper> npsResponseWrapperList,String Status){
        List<Order> orderList = new List<Order>();
        Map<Id,String> orderIdStatusMap = new Map<Id,String>();
        Set<Id> orderIdSet = new Set<Id>();
        for(NPSResponseWrapper eachWrapper : npsResponseWrapperList){
            
            orderIdSet.add(eachWrapper?.sfId);
            order eachOrder = new Order();
            eachOrder.Id = eachWrapper?.sfId;
            eachOrder.NPS_Response_Status__c = Status;
            if(Status=='Error')
            {
                eachOrder.Status='Draft';
            }
            orderList.add(eachOrder);
        }
        try{
            if(Schema.sObjectType.Order.isUpdateable() && !orderList.isEmpty())
            {
                update orderList;
            }
        }catch(Exception e){
            ErrorLogging log = new ErrorLogging(e,'NPSCallOutService','updateOrderResponse');
            log.insertErroLog();
        }
        
    }
}