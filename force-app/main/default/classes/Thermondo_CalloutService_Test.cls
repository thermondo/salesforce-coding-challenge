/*
 * Test class for Thermondo_CalloutService.
 * 
 * @author Narek Petrosyan
 * @version 1.0
 * @created 30.12.2022
 *  
*/

@isTest
public class Thermondo_CalloutService_Test {
    
    @isTest
    public static void testPositive() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        String payload = '[{"sfId":"8017Q000004jpWAQAY","sfIcustomerEmaild":"a_test_email_adderss@testhost.com","orderNumber":"00000100"}]';
        HttpResponse result = Thermondo_CalloutService.doCallout(payload);
        System.assertEquals(200, result.getStatusCode());     
    }
    
    @isTest
    public static void testNegative() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStatusCode(500);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        String payload = '[{"sfId":"8017Q000004jpWAQAY","sfIcustomerEmaild":"a_test_email_adderss@testhost.com","orderNumber":"00000100"}]';
        HttpResponse result = Thermondo_CalloutService.doCallout(payload);
        System.assertEquals(500, result.getStatusCode());    
    }  
}