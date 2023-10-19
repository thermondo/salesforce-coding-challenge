//NPS Service Layer
public with sharing class NPSService {
    public class NPSServiceException extends Exception{}
    private final String npsServiceEndpointNamedCredential = 'NPS_Service';

    //NPS InsertOrder Callout Method
    public HttpResponse insertOrders(List<Order> orders){   
             
        if(orders.size() < 30){
            throw new NPSServiceException('More than 30 records can not send at once');
        }

        List<CommonObjectWrapper.NPSOrder> npsOrderList = new List<CommonObjectWrapper.NPSOrder>();
        for (Order o : orders) {
            npsOrderList.add(new CommonObjectWrapper.NPSOrder(o));
        }

        String endpoint = 'callout:' + this.npsServiceEndpointNamedCredential + '/orders';        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');    
        req.setBody(JSON.serialize(npsOrderList));

        HttpResponse response = h.send(req);                
        return response;
    }

    
}