/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This apex class is used Send Data to NPS.
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
public with sharing class NPSCallout {
   //public static SendNPSDataWrapper.NPSCalloutOutput objNPsCalloutOutput ;
   @future(callout=true)
   public static void callout(List<Id> orderIds, String strOrderDataJSON ) { 
         
        try{
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:NPS_API');
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('POST');
            req.setBody(strOrderDataJSON);
            Http http = new Http();
            HttpResponse response = http.send(req);
            system.debug('response--' + response);
            Integer responseStatusCode = response.getStatusCode();
            system.debug('status code is--'+ responseStatusCode);
            System.debug('Response Body--'+ response.getBody());
            List<Order> orderToUpdate = new List<Order>();
            switch on responseStatusCode{
               when 200{
                  // updating the offer which we are sending to NPS if the offer are successfully sent to NPS App then updating fields to make sure no duplicte orders are sent
                  // thus thecustomer won't get duplicate email.
               // objNPsCalloutOutput = getNpsCalloutOutput(response.getStatusCode(), response.getBody(), 'Success');
                  List<Order> orderList = [Select Id, orderNumber, AccountId, NPS_Integration_Status__c, Email_Sent__c from Order where Id IN: orderIds WITH SECURITY_ENFORCED];
                     for(Order order : orderList){
                        order.NPS_Integration_Status__c = 'Completed';
                        order.Email_Sent__c = true;
                        orderToUpdate.add(order);
                     }
                     system.debug('getting 200');
                     //system.debug('Output of NPS App is--'+objNPsCalloutOutput);

                     
                     
               }
               
            when else{
               // Mapping the error twrapper class to show in flow
                  //objNPsCalloutOutput = getNpsCalloutOutput(response.getStatusCode(), response.getBody(), 'Failure');
               // Creating a record in Error Log Object in case of callout failure.
               Error_Log__c err = new Error_Log__c();
               err.Class_Name__c = 'NPSCallout';
               err.Method_Name__c = 'callout';
               err.Request_Body__c	= strOrderDataJSON;
               err.Response_Body__c =response.getBody();
               err.Status__c = 'Failed in Callout';
               err.Status_Code__c = String.valueof(response.getStatusCode());
               err.Exception_Message__c = response.getBody();
               if(Schema.sObjectType.Error_Log__c.isCreateable()){
                  insert err;
               }
               //updating the record in order object in case of callout failure to let user know of failure of sending data to NPS APP. So admin can look for error in error log object
               // to track the issue of failure.
               List<Order> orderList = [Select Id, orderNumber, AccountId, NPS_Integration_Status__c, Email_Sent__c, Status from Order where Id IN: orderIds WITH SECURITY_ENFORCED];
                     for(Order order : orderList){
                        order.NPS_Integration_Status__c = 'Failed';
                        //Changing the Status back to Draft so the record-Triggered flow will not run in loop.
                        order.Status = 'Draft';
                        orderToUpdate.add(order);
                     }
                  
                  
                  //system.debug('Output of NPS App is--'+objNPsCalloutOutput);
                  
               
            }
            
            }
            
            if( Schema.sObjectType.Order.isUpdateable() && !orderToUpdate.isEmpty() ){
                  update orderToUpdate;
            }
            //return objNPsCalloutOutput;
         }
         catch(Exception e){
           logError(e);
        }
       


       
}
     public Static void logError(Exception e){
            Error_Log__c objErrorLog  = new Error_Log__c();
            string stackTrace = e.getStackTraceString().substringBefore('\n');
            string className = stackTrace.substringAfter('.').substringBefore('.'); 
            string methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            String queryLimit = 'QUERY LIMIT' + Limits.getQueries() + '/' + Limits.getLimitQueries();
            String dmLimit = 'DML LIMIT' + Limits.getDmlStatements() + '/' + Limits.getLimitDmlRows();
            String dmlStat = 'DML STAT' + Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements();
            String cpuT = 'CPU TIME' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime();
            objErrorLog.Exception_Message__c = e.getMessage();
            objErrorLog.Exception_Type__c = e.getTypeName();
            objErrorLog.Line_Number__c = e.getLineNumber();
            objErrorLog.Stack_Trace__c = e.getStackTraceString();
            objErrorLog.Method_Name__c=methodName;
            objErrorLog.Class_Name__c=className;
            objErrorLog.Govt_Limit_in_Exceuting_Code__c = String.format('{0}\n{1}\n{2}\n{3}',new List<string>{queryLimit, dmLimit,dmlStat,cpuT});
            if(Schema.sObjectType.Error_Log__c.isCreateable()){
                insert objErrorLog;
              }
        }
  /*Public Static SendNPSDataWrapper.NPSCalloutOutput getNpsCalloutOutput(Integer httpResponseCode,String httpResponseMessage,string httpResponseSuccess){
            objNPsCalloutOutput = new SendNPSDataWrapper.NPSCalloutOutput(httpResponseCode,
                                                                     httpResponseMessage,
                                                                     httpResponseSuccess);
            return objNPsCalloutOutput;
         }*/
      
}