/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This apex class is used to Create Error Logs
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Nitish Bhardwaj
* @version        1.0
* @created        2023-12-21
* @modified       2023-12-21
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public without sharing class ErrorLogging {
   public Error_Log__c errorLogObj;
    public List<Error_Log__c> errorLogLst;
    public ErrorLogging(exception ex, String className, String methodName) {
        errorLogObj  = new Error_Log__c();
        errorLogLst = new List<Error_Log__c>();
        errorLogObj.Exception_Message__c = ex.getMessage();
        errorLogObj.Exception_Type__c = ex.getTypeName();
        errorLogObj.Line_Number__c = ex.getLineNumber();
        errorLogObj.Method_Name__c=methodName;
        errorLogObj.Class_Name__c=className;
        errorLogLst.add(errorLogObj);

    }
    public ErrorLogging(HttpResponse response, String className, String methodName, String requestData,String Status ) {
        errorLogObj  = new Error_Log__c();
        errorLogLst = new List<Error_Log__c>();
        errorLogObj.Class_Name__c = className;
        errorLogObj.Method_Name__c = methodName;
        errorLogObj.Request_Body__c	= requestData;
        errorLogObj.Response_Body__c =response.getBody();
        errorLogObj.Status__c = Status;
        errorLogObj.Status_Code__c = String.valueof(response.getStatusCode());
        errorLogObj.Exception_Message__c = response.getBody();
        errorLogLst.add(errorLogObj);
    }

    public void insertErroLog(){

        if(Schema.sObjectType.Error_Log__c.isCreateable()){
            insert this.errorLogLst;
          } 
    }


}