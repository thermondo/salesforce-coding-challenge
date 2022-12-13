public with sharing class NpsServiceAction {
    static final Integer BATCH_SIZE = 30;
    // TODO: conduct performance tests to asses how many of the 100 callouts (limit) can be performed within one transaction to not exceed 120 s in total
    static final Integer CALLOUTS_PER_TRANSACTION = 100;

    @TestVisible static OrderSelector orderSelector = new OrderSelector();

    @TestVisible static HttpService httpService = new HttpService();
    @TestVisible static OrderService orderService = new OrderService();

    @InvocableMethod(Label='Call NPS service async' Category='Async callouts' Description='')
    public static void callNpsService(List<Id> orderIds) {
        List<Order> orders = new List<Order>();
        // TODO: handle SOQL limit of 50'000 rows by splitting orderIds and executing subsequent queries in separate transactions (async jobs)
        if (orderIds.size() < Limits.getLimitQueryRows()) {
            orders = orderSelector.selectOrderNumberAndPersonEmailForOrderIds(orderIds);
        } else {
            // TODO: replace hardcoded strings with custom labels
            throw new NpsServiceException('Currently the service is not able to process more than 50\'000 records at once.');
            // TODO: add asynchronous error logging to a record (e.g. Log__c) with the use of platform events (e.g. Log_event__e)
        }
        if (!orders.isEmpty()) {
            List<List<List<OrderWrapper>>> batchList = createBatchList(orders);
            for (List<List<OrderWrapper>> orderWrapperBatch : batchList) {
                if (Limits.getQueueableJobs() < Limits.getLimitQueueableJobs()) {
                    System.enqueueJob(new NpsServiceActionQueueable(orderWrapperBatch));
                } else {
                    // TODO: add handling for remaining records
                    break;
                }
            }
        } else {
            // TODO: replace hardcoded strings with custom labels
            throw new NpsServiceException('No orders found for provided IDs.');
            // TODO: add asynchronous error logging to a record (e.g. Log__c) with the use of platform events (e.g. Log_event__e)
        }
    }

    /**
     * @param orders Flat list of Orders
     *
     * @return Structured list of batches of OrderWrappers for easier processing:
     * each batch (level 1) contains list of 100 "callouts" (level 2) and each of them contains 30 OrderWrappers
     */
    @TestVisible private static List<List<List<OrderWrapper>>> createBatchList(List<Order> orders) {
        Integer batchCounter = 0;
        Integer calloutCounter = 0;
        Integer recordCounter = 0;
        List<List<List<OrderWrapper>>> batchList = new List<List<List<OrderWrapper>>>{new List<List<OrderWrapper>>{new List<OrderWrapper>()}};
        for (Order o : orders) {
            batchList.get(batchCounter).get(calloutCounter).add(new OrderWrapper(o));
            recordCounter++;
            if (recordCounter == BATCH_SIZE) {
                calloutCounter++;
                recordCounter = 0;
                if (calloutCounter == CALLOUTS_PER_TRANSACTION) {
                    batchCounter++;
                    calloutCounter = 0;
                }
            }
        }
        return batchList;
    }

    public class NpsServiceActionQueueable implements Queueable, Database.AllowsCallouts {
        private List<List<OrderWrapper>> orderWrappersBatch;

        public NpsServiceActionQueueable(List<List<OrderWrapper>> orderWrappersBatch) {
            this.orderWrappersBatch = orderWrappersBatch;
        }

        public void execute(QueueableContext qc) {
            try {
                for (List<OrderWrapper> orderWrappers : orderWrappersBatch) {
                    HttpResponse httpResponse = httpService.performHttpPostRequestToNpsService(JSON.serialize(orderWrappers));
                    Integer statusCode = httpResponse.getStatusCode();
                    if (statusCode == 200) {
                        // Update flag, so that the email is not triggered twice for the same order
                        orderService.performNpsServiceTriggeredUpdates(getOrderIds(orderWrappers));
                    } else if (statusCode == 400) {
                        // TODO: replace hardcoded strings with custom labels
                        throw new NpsServiceException('Incorrect payload.');
                    } else if (statusCode == 401) {
                        // TODO: replace hardcoded strings with custom labels
                        throw new NpsServiceException('Authorization unsuccessful.');
                    } else if (statusCode == 500) {
                        // TODO: replace hardcoded strings with custom labels
                        throw new NpsServiceException('NPS service server error.');
                    } else {
                        // TODO: replace hardcoded strings with custom labels
                        throw new NpsServiceException('Unexpected outcome. HTTP status code: ' + statusCode);
                    }
                }
            } catch (Exception e) {
                // TODO: add asynchronous error logging to a record (e.g. Log__c) with the use of platform events (e.g. Log_event__e)
                throw new NpsServiceException(e.getMessage());
            }
        }

        @TestVisible private List<Id> getOrderIds(List<OrderWrapper> orderWrappers) {
            List<Id> orderIds = new List<Id>();
            for (OrderWrapper ow : orderWrappers) {
                orderIds.add(ow.id);
            }
            return orderIds;
        }
    }

    public class OrderWrapper {
        String id;
        String orderNumber;
        String customerEmail;

        public OrderWrapper(Order order) {
            this.id = order.Id;
            this.orderNumber = order.OrderNumber;
            this.customerEmail = order.Account.PersonEmail;
        }
    }

    public class NpsServiceException extends Exception {}
}