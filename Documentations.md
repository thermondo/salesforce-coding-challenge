
------------------------------------------------------------------------------
### Implementation Details:
------------------------------------------------------------------------------
*  Database changes: 
    >>> Sobject: Account - New field is added of type email
        Field name: Person Email
        Api name: PersonEmail__c
        Field type : Email
    >>> Sobject: Order - New picklist value ‘Fulfilled’ is added for status field
        Field name: Status
        Picklist value: Fulfilled

* Configuration changes: 
    >>> Named credentials: New named credentials is added to store API details
        Name of credential: tmondo
        Authentication Protocol: Password Authentication


    >>> Flow : placeOrderOnFulfilment 
        This flow will be triggered when order status is updated as fulfilled
        * When to trigger: Trigger this flow when order is updated
        * Type of flow: Record Trigger flow on order object after record is updated
        * Flow Entry condition:
            * Order status is changed
            * Order status = fulfilled	
        * Action: Call apex action sendOrders to make an API callout

    >>> Apex class: 
        * NPSService: This class holds an invocable method which will be called from placeOrderOnFulfilment flow, a future method is called from this method to make API callout.
        * calloutService: This class is used to make external calls to NPS systems and pass order ids to the service.
        * ordersDTO: Wrapper class to hold API details and request object

    >>> Apex tests:
        * NPSServiceTest: Primary test class to add coverage for NPSService and calloutService
        * npsMock: Http mock class for API testing.
------------------------------------------------------------------------------
### Identified Limitations
------------------------------------------------------------------------------
*   This code places all the orders which are fullfilled, to send specified number of records we can introduce 
    Bath job apex to achieve the requirement. Whole list of records will be divided into chunks of Data
    and sent to API
*   //TODO Having scheduled job is more recommended which can trigger batch job at scheduled interval in a day. Which can reduce number of API hits
*   //TODO To get the status of API we can use queuable class to know the status of asynchronous job using Jobid provieded by queuable job
*   For the order details those have been sent to NPS service, if email address is not available, order will be placed without notifying the customer

 

