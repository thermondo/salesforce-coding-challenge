public class calloutService { 
    @future(callout = true)
    public static void sendOrders(string requestString)
    {
    ordersDTO request = (ordersDTO)json.deserialize(requestString, ordersDTO.class);
	HttpRequest req = new HttpRequest();
    req.setEndpoint(request.endpoint);
    req.setMethod(request.Method);
   	if (
      String.isNotBlank(request.method) &&
      (request.Method != 'GET' ||
      request.Method != 'DELETE')
    ) {
      req.setBody(json.serialize( request.requestBody));
    }       
    HttpResponse response =  (new Http()).send(req);
    if (response.getStatusCode() == 200) {
    	system.debug('Response status ::'+ response.getStatus());
    	system.debug('Order placed ::'+ response.getBody());
    	// Execute further business logic
    }
    else if(response.getStatusCode() == 400){
    	system.debug('Response status ::'+ response.getStatus());
    	system.debug('Please check order details ::'+ response.getBody());
    	// Actions to notify user to recheck payload
   }
    else system.debug('Something went wrong ::'+ response.getStatus() +' : '+ response.getBody());
  }
}