/*******************************************************************************************************
* @Name         LogEntries
* @Author       Aditya Vempati
* @Date         01/25/2023
* @Description  This class contains resuable methods for Error and Info Logging
*******************************************************************************************/
public without sharing class LogEntries
{
    private static LogEntries instance = null;
    private static final String INTEGRATION_LOG_TYPE = 'Integration Log	';
    
    public static LogEntries getInstance()
    {
        if (null == instance) instance = new LogEntries();
        
        return instance;
    }
    
    
    /**************************************************************************************
* @Description This method is used to log a transaction
* @Param		String className, String message, System.LoggingLevel loglevel
* @Return       void
**************************************************************************************/ 
    
    public void createLogEntry(String className, String message, System.LoggingLevel loglevel)
    {
        insert new Log_Entry__c(ClassName__c = className, Message__c = message, LogLevel__c = loglevel.name());
    }
    
    
    /**************************************************************************************
* @Description This method is used to log an exception
* @Param		Exception
* @Return       void
**************************************************************************************/ 
    public void createLogEntry(Exception e)
    {
        createLogEntry(null, getMessageFromException(e), LoggingLevel.ERROR);
    }
    
    private String getMessageFromException(Exception e)
    {
        String result = 'Exception Info: ' + e;
        if (null != e.getCause())
        {
            result += 'Exception Cause is : ' + e.getCause() + '\n';
        }
        result += ' StackTrace : ' + e.getStackTraceString();
        return result;
    }
    
    
    /**************************************************************************************
* @Description  This method is used to log Intergation info
* @Param		String serviceName, String request, String response, System.LoggingLevel loglevel, Integer statusCode
* @Return       void
**************************************************************************************/ 
    
    public void logIntegration(String serviceName, String request, String response, System.LoggingLevel loglevel, Integer statusCode)
    {
        insert new Log_Entry__c(Request__c = request, Response__c = response, LogLevel__c = loglevel.name(),
                                Transaction_Service_Name__c = serviceName,
                                Log_Type__c = INTEGRATION_LOG_TYPE, 
                                Status_Code__c = statusCode);
    }
    
}