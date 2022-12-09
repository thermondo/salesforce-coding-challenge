/**
 * @author anureka segar
 * @date 09.12.2022
 * @description apex service class to send order details to NPS using flow invocalble action
 */

public with sharing class OrderFulfillmentService {
  // Custom exception to handle the case when the user doesn't have CRUD permission on the Order object
  public class NoAccessException extends Exception {
  }

  // The invocable method that will be called by the flow
  @InvocableMethod(
    label='Send Order Details to NPS Service'
    description='Gets the customer E-mail Address and OrderNumber and sends the data to External System(NPS)'
    callout=true
  )
  public static List<OrderFulfillmentResponseWrapper> sendOrderFulfillmentNotification(List<Id> orderIds) {
    // Check if the orderIds list is empty and return an empty list if it is
    if (orderIds.isEmpty()) {
      return new List<OrderFulfillmentResponseWrapper>();
    }

    // Check for CRUD permissions on the Order object
    if (!hasCRUDPermissionOnOrder()) {
      throw new NoAccessException('Insufficient permissions to access the Order object');
    }

    // Query for the orders and create the request to the NPS service
    HttpRequest req = createOrderFulfillmentRequest(orderIds);

    // Make the callout to the NPS service and return the response
    return new List<OrderFulfillmentResponseWrapper>{ makeCallout(req) };
  }

  // Method to Query for the orders and create the request to the NPS service
  private static HttpRequest createOrderFulfillmentRequest(List<Id> orderIds) {
    // List of order fulfillment wrapper objects to be sent to the NPS service
    List<OrderFulfillmentWrapper> orderWrapperList = new List<OrderFulfillmentWrapper>();

    // Iterate over the orders and send a notification to the NPS service
    for (Order orderRec : [SELECT Id, OrderNumber, Account.PersonEmail FROM Order WHERE Id IN :orderIds]) {
      // TODO -  Current request body format does not have an array, if we can change that then we can for each email multiple order details
      // but current approach will send email for each order separately
      // Potentential update request format would be {customerEmail:test@test.com,orders:[{sfId:'12adf',orderNumber:'1234'},{sfId:'12adfasd',orderNumber:'5678'}]}
      orderWrapperList.add(
        new OrderFulfillmentWrapper(orderRec.Id, orderRec.OrderNumber, orderRec.Account.PersonEmail)
      );
    }

    // TODO this check is not required because this method is called from a Record Triggered Flow
    /* if (orderWrapperList.isEmpty()) {
      return null;
    } */

    // Create a request to the NPS service
    HttpRequest req = new HttpRequest();
    //TODO - Get authentication details and update the code based on authentication mechanism
    req.setEndpoint('callout:Mock_NPS_API/orders');
    req.setMethod('POST');
    req.setHeader('Content-Type', 'application/json');
    req.setBody(JSON.serialize(orderWrapperList));
    return req;
  }

  // Method to Make the callout to the NPS service and return the response
  private static OrderFulfillmentResponseWrapper makeCallout(HttpRequest req) {
    OrderFulfillmentResponseWrapper response = new OrderFulfillmentResponseWrapper();
    try {
      Http http = new Http();
      HttpResponse res = http.send(req);
      response.isSuccess = res.getStatusCode() == 200 ? true : false;
      response.statusCode = res.getStatusCode();
      response.responseBody = res.getBody();
    } catch (Exception e) {
      // TODO - include logging to record any exceptions that occur while making the callout.
      //This will make it easier to diagnose and fix any issues that arise in the future.

      // TODO - better to catch specific exceptions instead of catching Exception and handling them.
      //example, catch CalloutException to handle errors that occur during the callout,
      // and System.JSONException to handle errors that occur when serializing or deserializing JSON.
      response.isSuccess = false;
      response.errorMessage = e.getMessage();
    }
    return response;
  }

  // Check for Queryable CRUD permissions on the Order object
  private static Boolean hasCRUDPermissionOnOrder() {
    return Schema.sObjectType.Order.isQueryable();
  }

  public class OrderFulfillmentWrapper {
    public String sfId;
    public String orderNumber;
    public String customerEmail;
    public OrderFulfillmentWrapper(String sfId, String orderNumber, String customerEmail) {
      this.sfId = sfId;
      this.orderNumber = orderNumber;
      this.customerEmail = customerEmail;
    }
  }

  //response wrapper to return to flow to handle excpetion by admins
  public class OrderFulfillmentResponseWrapper {
    @InvocableVariable(label='Callout Status')
    public Boolean isSuccess;
    @InvocableVariable(label='Callout response body')
    public String responseBody;
    @InvocableVariable(label='Callout status code')
    public Integer statusCode;
    @InvocableVariable(label='Exception message')
    public String errorMessage;
  }
}
