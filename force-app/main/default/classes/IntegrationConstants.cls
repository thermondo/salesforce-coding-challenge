/*******************************************************************************************************
* @Name         IntegrationConstants
* @Author       Aditya Vempati
* @Date         01/25/2023
* @Description  This class is used to store constants related to integration
*******************************************************************************************/
public inherited sharing class IntegrationConstants
{
    public static final String POST_METHOD 
    {
        get
        {
            return 'POST';
        }
    }
    
    public static final String SUCCESS 
    {
        get
        {
            return 'SUCCESS';
        }
    }
    
    public static final String FAILURE 
    {
        get
        {
            return 'FAILURE';
        }
    }
    
    public static final Integer SERVICE_SUCCESS_CODE 
    {
        get
        {
            return  200;
        }
    }
    
    public static final Integer SERVICE_FAILURE_CODE 
    {
        get
        {
            return  400;
        }
    }
    
    public static final Integer INTERNAL_SERVER_ERROR 
    {
        get
        {
            return  500;
        }
    }
    
    public static final String APPLICATION_SLASH_JSON 
    {
        get
        {
            return 'application/json';
        }
    }
    
    public static final String CONTENT_TYPE  
    {
        get
        {
            return 'Content-Type';
        }
    }
    
}