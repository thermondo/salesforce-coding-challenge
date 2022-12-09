@isTest
private class OrderFulfillmentServiceTest {
  @testSetup
  static void makeData() {
    //TODO - Use existing test data factory classes to create test data

    // Get the record type ID for person accounts
    Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
      .get('Person Account')
      .getRecordTypeId();

    //create a new person account
    Account personAccount = new Account(
      RecordTypeId = personAccountRecordTypeId,
      FirstName = 'Test',
      LastName = 'Person',
      PersonEmail = 'test@abc.com'
    );
    insert personAccount;

    // Insert Product
    Product2 testProduct = new Product2(
      Name = ' Test Product ',
      Description = 'Test Product Entry',
      ProductCode = 'ABC',
      IsActive = true
    );
    insert testProduct;

    Id pricebookId = Test.getStandardPricebookId();

    // Insert PricebookEntry

    PricebookEntry standardPrice = new PricebookEntry(
      Pricebook2Id = pricebookId,
      Product2Id = testProduct.Id,
      UnitPrice = 1,
      IsActive = true,
      UseStandardPrice = false
    );
    insert standardPrice;

    Order testOrder = new Order(
      AccountId = personAccount.Id,
      Status = 'Draft',
      EffectiveDate = Date.today(),
      Pricebook2Id = pricebookId
    );
    insert testOrder;

    OrderItem oli = new OrderItem(
      OrderId = testOrder.Id,
      Quantity = 2,
      UnitPrice = 240,
      Product2Id = testProduct.Id,
      PricebookEntryId = standardPrice.Id
    );
    insert oli;
  }

  @isTest
  static void testNoAccessException() {
    Order testOrder = [SELECT Id, Status FROM Order LIMIT 1];
    // Set up test user without CRUD permissions on the Order object
    // Create a unique UserName
    String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
    // assuming standard user do not have access to order object
    Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
    User testUser = new User(
      Alias = 'standt',
      Email = 'standarduser@testorg.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Testing',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      ProfileId = p.Id,
      TimeZoneSidKey = 'America/Los_Angeles',
      UserName = uniqueUserName
    );

    // Test the sendOrderFulfillmentNotification method with insufficient permissions
    Test.startTest();
    System.runAs(testUser) {
      try {
        OrderFulfillmentService.sendOrderFulfillmentNotification(new List<Id>{ testOrder.Id });
        System.assert(false, 'Expected NoAccessException was not thrown');
      } catch (OrderFulfillmentService.NoAccessException e) {
        System.assertEquals(e.getMessage(), 'Insufficient permissions to access the Order object');
      }
    }
    Test.stopTest();
  }
  @isTest
  static void testSendOrderFulfillmentNotification() {
    // TODO - update this test to use a proper test user with the correct permissions
    Order testOrder = [SELECT Id, Status FROM Order LIMIT 1];

    // Set mock callout class
    Test.setMock(HttpCalloutMock.class, new MockOrderFulfillmentResponse());

    Test.startTest();
    // TODO need to check why record triggered flow is not giving coverage so calling the actual method from test method
    //testOrder.Status = 'Fulfilled';
    //update testOrder;
    List<OrderFulfillmentService.OrderFulfillmentResponseWrapper> responses = OrderFulfillmentService.sendOrderFulfillmentNotification(
      new List<Id>{ testOrder.Id }
    );
    // Check that the method returns a single response
    System.assertEquals(1, responses.size(), 'Expected 1 response');
    OrderFulfillmentService.OrderFulfillmentResponseWrapper response = responses[0];
    // Check that the response indicates success
    System.assert(response.isSuccess, 'The response should indicate success');
    // Check that the response has the expected status code
    System.assertEquals(200, response.statusCode, 'The response should have status code 200');

    Test.stopTest();
  }

  // Test to verify that the `sendOrderFulfillmentNotification` method returns an empty list
  // when the `orderIds` list is empty
  @isTest
  static void testSendOrderFulfillmentNotificationEmptyOrderIdsList() {
    // TODO - update this test to use a proper test user with the correct permissions

    // Call the `sendOrderFulfillmentNotification` method
    Test.startTest();
    List<OrderFulfillmentService.OrderFulfillmentResponseWrapper> response = OrderFulfillmentService.sendOrderFulfillmentNotification(
      new List<Id>{}
    );
    // Assert that the response is an empty list
    System.assertEquals(0, response.size());
    Test.stopTest();
  }

  @isTest
  static void testFailedResponse() {
    // TODO - update this test to use a proper test user with the correct permissions
    Order testOrder = [SELECT Id, Status FROM Order LIMIT 1];

    // Set up the mock HTTP callout class
    Test.setMock(HttpCalloutMock.class, new MockOrderFulfillmentFailedResponse());

    // Call the method that makes the callout and verify the response
    Test.startTest();
    List<OrderFulfillmentService.OrderFulfillmentResponseWrapper> responses = OrderFulfillmentService.sendOrderFulfillmentNotification(
      new List<Id>{ testOrder.Id }
    );
    Test.stopTest();
    OrderFulfillmentService.OrderFulfillmentResponseWrapper response = responses[0];
    System.assertEquals(false, response.isSuccess, 'Expected a failed response');
    System.assertEquals(500, response.statusCode, 'Expected a status code of 500');
    System.assertEquals(
      'Internal server error',
      response.responseBody,
      'Expected an error message of "Internal server error"'
    );
  }
  //TODO write unit test for the large number of records
}
