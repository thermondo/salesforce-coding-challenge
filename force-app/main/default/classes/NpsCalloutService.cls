/*******************************************************************************************************
* @Name         NpsCalloutService
* @Author       Anshul Sharma 
* @Date         03/01/2023
* @Description  This class contains all service method facilitate nps callouts
*******************************************************************************************/

public class NpsCalloutService {


/**************************************************************************************
* @Description  This method accets request payload and send it to NPS system based on the NPS_System_Credentials named credentials
* @Param		String - request string
* @Return       HttpResponse - Value retrieved from org cache. 
**************************************************************************************/ 

     public static HttpResponse sendRequest(String requestPayload)
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:NPS_System_Credentials/Orders');
        request.setMethod('POST');
        request.setBody(requestPayload);
        HTTPResponse response = http.send(request);
        return response;    
       
    }
    
}