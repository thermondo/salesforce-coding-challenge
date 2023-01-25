/*******************************************************************************************************
* @Name         NPSServiceInput
* @Author       Aditya Vempati
* @Date         01/25/2023
* @Description  This class contains structure of NPS Service Request Input
*******************************************************************************************/
public inherited sharing class NPSServiceInput 
{
    public Id sfId {get;set;}
    public String orderNumber {get;set;}
    public String customerEmail {get;set;}
    
    public NPSServiceInput(Id sfId, String orderNumber,String customerEmail)
    {
        this.sfId  = sfId;
        this.orderNumber = orderNumber;
        this.customerEmail = customerEmail;
    }
}