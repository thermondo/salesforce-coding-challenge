/*******************************************************************************************************
* @Name         LogEntries_Test
* @Author       Aditya Vempati
* @Date         01/25/2023
*******************************************************************************************/
@isTest(seeAllData = false)
private class LogEntries_Test 
{
    
    @isTest
    private static void testLogEntryCreation()
    {
        try
        {
            Double quotient = 100/0;
        }
        catch(Exception excp)
        {
            LogEntries.getInstance().createLogEntry(excp);
            System.assert(![SELECT Id FROM Log_Entry__c]?.isEmpty());
        }
    }
}