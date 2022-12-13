@IsTest
public with sharing class HttpServiceTest {
    // TODO: create a test helper class to keep reusable pieces of test-applicable code in one place
    public static final String SAMPLE_REQUEST_BODY = '[{"sfId": "8015E000003LfJXQA0","orderNumber": "007","customerEmail": "customerAddress@example.com"}]';

    @IsTest
    static void when_requestSent_then_returnSuccessfulResponse() {Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        // GIVEN: HttpService

        HttpService httpService = new HttpService();

        // WHEN: performHttpPostRequestToNpsService() method is executed

        Test.startTest();
        HttpResponse httpResponse = httpService.performHttpPostRequestToNpsService(SAMPLE_REQUEST_BODY);
        Test.stopTest();

        // THEN: A successful response is obtained

        System.assertEquals(200, httpResponse.getStatusCode());
        System.assertEquals('SUCCESS', httpResponse.getStatus());
    }

    public class HttpResponseMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest httpRequest) {
            HttpResponse httpResponse = new HttpResponse();
            if (httpRequest.getMethod() == 'POST'
                && httpRequest.getEndpoint() == 'callout:Thermondo_NPS_mock/orders'
                && httpRequest.getBody() == SAMPLE_REQUEST_BODY
            ) {
                httpResponse.setStatus('SUCCESS');
                httpResponse.setStatusCode(200);
                httpResponse.setBody('SUCCESS');
            }
            return httpResponse;
        }
    }
}