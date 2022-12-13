@IsTest
public with sharing class NpsServiceActionTest {
    // "Lazy loading" a response, so that the field is not populated until necessary
    static final HttpResponse SUCCESSFUL_RESPONSE {
        get {
            if (SUCCESSFUL_RESPONSE == null) {
                HttpResponse httpResponse = new HttpResponse();
                httpResponse.setStatusCode(200);
                httpResponse.setStatus('SUCCESS');
                SUCCESSFUL_RESPONSE = httpResponse;
            }
            return SUCCESSFUL_RESPONSE;
        }
        set {}
    }

    static final HttpResponse BAD_PAYLOAD_RESPONSE {
        get {
            if (BAD_PAYLOAD_RESPONSE == null) {
                HttpResponse httpResponse = new HttpResponse();
                httpResponse.setStatusCode(400);
                httpResponse.setStatus('BAD PAYLOAD');
                BAD_PAYLOAD_RESPONSE = httpResponse;
            }
            return BAD_PAYLOAD_RESPONSE;
        }
        set {}
    }

    @TestSetup
    static void setup() {
        Account testAccount = new Account(
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId(),
            FirstName = 'Test',
            LastName = 'Account',
            PersonEmail = 'test@mail.com'
        );
        insert testAccount;

        insert new Order(
            AccountId = testAccount.Id,
            EffectiveDate = Date.today().addDays(1),
            Status = 'Draft'
        );
    }

    @IsTest
    static void when_orderIdPassedAndNpsNotYetTriggered_then_sendRequestAndUpdateOrder() {
        // GIVEN: A correct test order, mocked selector and services are given

        Order testOrder = [SELECT Id, OrderNumber, Account.PersonEmail FROM Order LIMIT 1];

        String orderWrapperJsonString = JSON.serialize(
            new List<NpsServiceAction.OrderWrapper>{
                new NpsServiceAction.OrderWrapper(testOrder)
            }
        );

        List<Id> orderIds = new List<Id>{testOrder.Id};

        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        mocks.startStubbing();

        // Mock OrderSelector
        OrderSelector orderSelectorMock = (OrderSelector) mocks.mock(OrderSelector.class);
        mocks
            .when(orderSelectorMock.selectOrderNumberAndPersonEmailForOrderIds(orderIds))
            .thenReturn(new List<Order>{testOrder});

        // Mock HttpService
        HttpService httpServiceMock = (HttpService) mocks.mock(HttpService.class);
        mocks
            .when(httpServiceMock.performHttpPostRequestToNpsService(orderWrapperJsonString))
            .thenReturn(SUCCESSFUL_RESPONSE);

        // Mock OrderService
        OrderService orderServiceMock = (OrderService) mocks.mock(OrderService.class);

        mocks.stopStubbing();

        Test.startTest();
        NpsServiceAction.httpService = httpServiceMock;
        NpsServiceAction.orderService = orderServiceMock;
        NpsServiceAction.orderSelector = orderSelectorMock;

        // WHEN: callNpsService() method is executed with an order that gives a correct payload

        NpsServiceAction.callNpsService(new List<Id>{testOrder.Id});
        Test.stopTest();

        // THEN: selector and services are invoked

        ((HttpService) mocks.verify(httpServiceMock, 1)).performHttpPostRequestToNpsService(orderWrapperJsonString);
        ((OrderService) mocks.verify(orderServiceMock, 1)).performNpsServiceTriggeredUpdates(orderIds);
        ((OrderSelector) mocks.verify(orderSelectorMock, 1)).selectOrderNumberAndPersonEmailForOrderIds(orderIds);
    }

    @IsTest
    static void when_orderFulfilledAndNpsAlreadyTriggered_then_doNothing() {
        // GIVEN: A mocked selector, that returns an empty array (just like in case an Order has the NPS_service_already_triggered__c flag set to true)

        List<Id> testOrderIds = new List<Id>{[SELECT Id FROM Order LIMIT 1].Id};

        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        mocks.startStubbing();

        // Mock OrderSelector
        OrderSelector orderSelectorMock = (OrderSelector) mocks.mock(OrderSelector.class);
        mocks
            .when(orderSelectorMock.selectOrderNumberAndPersonEmailForOrderIds(testOrderIds))
            .thenReturn(new List<Order>());

        mocks.stopStubbing();

        Test.startTest();
        NpsServiceAction.orderSelector = orderSelectorMock;

        // WHEN: callNpsService() method is executed

        String errorMessage;
        try {
            NpsServiceAction.callNpsService(testOrderIds);
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        Test.stopTest();

        // THEN: selector is invoked once and an exception is thrown

        ((OrderSelector) mocks.verify(orderSelectorMock, 1)).selectOrderNumberAndPersonEmailForOrderIds(testOrderIds);
        System.assertEquals('No orders found for provided IDs.', errorMessage);
    }

    @IsTest
    static void when_badPayloadResponse_then_throwError() {
        // GIVEN: A test order without an email, mocked selector and services are given
        // I'm simulating that, as the NPS Service mock API does not throw any error for incorrect payloads

        Order testOrder = [SELECT Id, OrderNumber, Account.PersonEmail FROM Order LIMIT 1];

        String orderWrapperJsonString = JSON.serialize(
            new List<NpsServiceAction.OrderWrapper>{
                new NpsServiceAction.OrderWrapper(testOrder)
            }
        );

        List<Id> orderIds = new List<Id>{testOrder.Id};

        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        mocks.startStubbing();

        // Mock OrderSelector
        OrderSelector orderSelectorMock = (OrderSelector) mocks.mock(OrderSelector.class);
        mocks
            .when(orderSelectorMock.selectOrderNumberAndPersonEmailForOrderIds(orderIds))
            .thenReturn(new List<Order>{testOrder});

        // Mock HttpService
        HttpService httpServiceMock = (HttpService) mocks.mock(HttpService.class);
        mocks
            .when(httpServiceMock.performHttpPostRequestToNpsService(orderWrapperJsonString))
            .thenReturn(BAD_PAYLOAD_RESPONSE);

        // Mock OrderService
        OrderService orderServiceMock = (OrderService) mocks.mock(OrderService.class);

        mocks.stopStubbing();

        String errorMessage;
        try {
            Test.startTest();
            NpsServiceAction.httpService = httpServiceMock;
            NpsServiceAction.orderService = orderServiceMock;
            NpsServiceAction.orderSelector = orderSelectorMock;

            // WHEN: callNpsService() method is executed with an order that gives a correct payload

            NpsServiceAction.callNpsService(new List<Id>{testOrder.Id});
            Test.stopTest();
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }

        // THEN: selector and HttpService are invoked, but OrderService is not; an exception is thrown

        ((HttpService) mocks.verify(httpServiceMock, 1)).performHttpPostRequestToNpsService(orderWrapperJsonString);
        ((OrderService) mocks.verify(orderServiceMock, 0)).performNpsServiceTriggeredUpdates(orderIds);
        ((OrderSelector) mocks.verify(orderSelectorMock, 1)).selectOrderNumberAndPersonEmailForOrderIds(orderIds);
        System.assertEquals('Incorrect payload.', errorMessage);
    }

    // TODO: Write a unit test for the createBatchList() method

    // TODO: Write a unit test for the getOrderIds() method
}