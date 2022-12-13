## General approach

1. Requests will be processed asynchronously (heavy lifting delegated to queueable jobs) to avoid bad user experience - after all, the user setting the order to _Fulfilled_ should not care about callouts to external systems.
2. Such an approach should provide a way to track possible errors that will fail silently otherwise. It can be done, e.g. by implementing error logging through platform events (they carry information about errors, that can be later used to create records of a custom object in a trigger fired by aforementioned events).

## Limitations and possible problems

1. API is limited regarding the number of orders that may be processed at once to 30 per request.
2. It's hard to tell how many synchronous requests can be processed within one transaction (SFDC limit is 100 with a total run time of 120 s) without conducting real tests. After all - we are using only mock API here.
3. Emails may be sent to users each time the order status is set to _Fulfilled_. It should be prevented to avoid confusion. It can be done through either blocking the possibility of further status changes once _Fulfilled_ or by indicating that the NPS service has already been triggered.
