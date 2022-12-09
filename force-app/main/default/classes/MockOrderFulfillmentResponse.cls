@isTest
public class MockOrderFulfillmentResponse implements HttpCalloutMock {
  // Implement this interface method
  public HTTPResponse respond(HTTPRequest req) {
    // Create a fake response
    HttpResponse res = new HttpResponse();
    res.setHeader('Content-Type', 'application/json');
    res.setBody('SUCCESS');
    res.setStatusCode(200);
    return res;
  }
}
