/*******************************************************************************************************
* @Name         OrdersNPSServiceInvocable
* @Author       Aditya Vempati
* @Date         01/25/2023
* @Description  This class contains Invocable method which will be called from
Flow when Order status is fulfilled or if Operations Agent changes NPS Integration Status to RETRY
*******************************************************************************************/
public inherited sharing class OrdersNPSServiceInvocable 
{
    
    /**************************************************************************************
* @Description  This method accepts List of orderIds and triggers integration
* @Param		List<Id>
* @Return       void
**************************************************************************************/ 
    @InvocableMethod(label = 'Invoke NPS Service' Description = 'This action invokes NPS Service and sends customer email info')
    public static void invokeNPSAPI(List<Id> orderIds)
    {
        try
        {
            NPSCalloutService.instance.invokeNPSAPI(orderIds);
        }
        catch(exception excp)
        {
            LogEntries.getInstance().createLogEntry(excp);
            NPSCalloutServiceHelper.instance.updateOrderWithServiceResponse([SELECT Id,NPS_Integration_Status__c,NPS_Integration_Response_Info__c FROM Order WHERE ID IN :orderIds], IntegrationConstants.FAILURE, excp.getMessage());
        }
    }
}