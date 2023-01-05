
@isTest
public class NpsCalloutServiceTest {
//To do : creation of custom label for String messages
    @isTest
    public static void isNpsCalloutsuccess()
   {
    // mock callout class 
    Test.setMock(HttpCalloutMock.class, new OrderNpsHttpCalloutSuccessMock()); 

    String requestPayload = '[{"sfid":"5673246","customerEmail":"aba@test.com","orderNumber":"1234"}]';
    HttpResponse response = NpsCalloutService.sendRequest(requestPayload);
    String contentType = response.getHeader('Content-Type');
    String actualValue = response.getBody();
    String expectedValue = '[{"SUCCESS"}]';
   
    System.assertEquals(expectedValue, actualValue,'Incorrect Response');
    System.assertEquals(200, response.getStatusCode(),'Unexpected status code returned');    
   }


   @isTest
   public static void isNpsCalloutFail()
   {  
   // mock callout class 
    Test.setMock(HttpCalloutMock.class, new OrderNpsHttpCalloutFailMock()); 
    
    String requestPayload = '[{"sfid":"5673246","customerEmail":"aba@test.com","orderNumber":"1234"}]';
    HttpResponse response = NpsCalloutService.sendRequest(requestPayload);
    String contentType = response.getHeader('Content-Type');
    String actualValue = response.getBody();
    String expectedValue = '[{"SERVER_ERROR"}]';
    
    System.assertEquals(expectedValue, actualValue,'Incorrect Response');
    System.assertEquals(500, response.getStatusCode(),'Unexpected status code returned');   
   }

}