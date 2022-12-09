@isTest
public class MockOrderFulfillmentFailedResponse implements HttpCalloutMock {
  // Implement this interface method
  public HTTPResponse respond(HTTPRequest req) {
    // Create a fake response
    HttpResponse res = new HttpResponse();
    res.setHeader('Content-Type', 'application/json');
    res.setStatusCode(500);
    res.setBody('Internal server error');
    return res;
  }
}
