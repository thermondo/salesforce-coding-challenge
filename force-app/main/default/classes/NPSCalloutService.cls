/*******************************************************************************************************
* @Name         NPSCalloutService
* @Author       Aditya Vempati
* @Date         01/25/2023
* @Description  This class invokes NPS Service and passes Order Info and customer info and updates NPS Integration Status field of Order Object
*******************************************************************************************/
public inherited sharing class NPSCalloutService
{    
    public static NPSCalloutService instance
    {
        get
        {
            if(NULL == instance)
            {
                instance = new NPSCalloutService();
            }
            return instance;
        }
        private set;
    }
    
    
    /**************************************************************************************
* @Description  This method accepts List of orderIds and triggers integration
* @Param		List<Id>
* @Return       void
**************************************************************************************/ 
    
    
    public void invokeNPSAPI(List<Id> orderIds)
    {
        invokeNPSAPI(new Set<Id>(orderIds));
    }
    
    /**************************************************************************************
* @Description  This method accepts List of orderIds and triggers integration
* @Param		Set<Id>
* @Return       void
**************************************************************************************/     
    public void invokeNPSAPI(Set<Id> orderIds)
    {        
        if(NULL == orderIds || orderIds.isEmpty())
        {
            throw new NPSServiceException(System.Label.NPS_Integration_Orders_Ids_Not_Found_Error);
        }
        
        List<Order> orders  = [SELECT Id, Account.PersonEmail, OrderNumber, NPS_Integration_Status__c FROM Order WHERE Id IN :orderIds AND NPS_Integration_Status__c != :IntegrationConstants.SUCCESS];
        
        if(orders.isEmpty())
        {
            throw new NPSServiceException(System.Label.NPS_Integration_Orders_Not_Found_Error);
        }
        
        List<NPSServiceInput> serviceInputs = new List<NPSServiceInput>();
        for(Order orderInstance : orders)
        {
            serviceInputs.add(new NPSServiceInput(orderInstance.Id, orderInstance.OrderNumber, orderInstance.Account?.PersonEmail));
        }
        
        NPSCalloutServiceHelper.instance.invokeService(serviceInputs, orders);
    }
    
    public inherited sharing class NPSServiceException extends Exception {}
}