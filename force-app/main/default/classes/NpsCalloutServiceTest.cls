/**
 * @description       : 
 * @author            : LikithKailas
 * @group             : 
 * @last modified on  : 08-08-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class NpsCalloutServiceTest {
  
    @IsTest
    public static void NpsCalloutServiceTest() {
        // Set mock callout class
        // Call method to test.
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        // from the class that implements HttpCalloutMock.
        String testJsonBody = '{"sfId": "8015E000003LfJXQAT","orderNumber": "008","customerEmail": "customerAddress@example.com"}';
        HttpResponse res = NpsCalloutService.makePostCallout(testJsonBody);
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        System.assertEquals(actualValue, testJsonBody);
        System.assertEquals(200, res.getStatusCode());
    }
}