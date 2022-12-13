public with sharing class HttpService {
    private static final Http HTTP = new Http();

    public HttpResponse performHttpPostRequestToNpsService(String body) {
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint('callout:Thermondo_NPS_mock/orders');
        httpRequest.setMethod('POST');
        httpRequest.setBody(body);
        return HTTP.send(httpRequest);
    }
}