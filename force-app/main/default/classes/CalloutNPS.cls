public class CalloutNPS{
    public static String responseMessage;
    public static Integer httpResponseCode;
    public static string returnMessage;
    
    @InvocableMethod(label='Send Order Data' description='Send E-Mail Address and Order Number to NPS API' callout = 'true')
    //The Record- and Schedule-Triggered flow support bulkification, which means we can build the flow as if it is for only one record, 
    //and it will automatically loop through all records.
    public static List<Results> getData(List<Request> requests){
       Results res = new Results();
       List<Id> orderIds = new List<Id>();
       for(Request req : requests){
            orderIds.add(req.RecordId);
       }
       Set<Id> orderIdsSet = new Set<Id>(orderIds);
       String batchSize = System.Label.BatchSizeNPS;
       Integer maxRecordSize = Integer.valueOf(batchSize);
       List<Order> orderList = [
        SELECT Id, OrderNumber, CustomerAuthorizedBy.Email
        FROM Order 
        WHERE ID in :orderIdsSet
        ];
        List<Order> lstTemp = new List<Order>();
        List<List<Order>> lstWrapper = new List<List<Order>>();
        for(Integer i = 0 ; i < (orderList.size() / maxRecordSize)+1 ; i++){
            lstTemp = new List<Order>();
            for(Integer j=(i*maxRecordSize);(j<(i*maxRecordSize)+maxRecordSize) && j<orderList.size() ; j++){
                lstTemp.add(orderList.get(j));
            }
            lstWrapper.add(lstTemp);
        }
        for(List<Order> indvList : lstWrapper){
            system.debug('indvList size'+ indvList.size());
            res.returnMessage = makeCallout(indvList);
        }
        List<Results> resList = new List<Results>();  
        resList.add(res);
        return resList;
    }

    private static String makeCallout(List<Order> ordList) {
            try{
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint('callout:NPS');
                request.setHeader('Content-Type', 'application/json');
                request.setMethod('POST');
                String jsonBody = makeJsonString(ordList);
                request.setBody(jsonBody);
                HttpResponse response = http.send(request);
                httpResponseCode = response.getStatusCode();
                responseMessage = response.getBody();   
                returnMessage = httpResponseCode + ' : ' + responseMessage ;
                System.debug('returnMessage ' + returnMessage);
            }catch (Exception e) {         
                System.debug('Error:' + e.getMessage() + ' Line no:' + e.getLineNumber() );           
            }
        return returnMessage;
     }

     private static String makeJsonString(List<Order> ordList){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        for(Order ord : ordList){
            gen.writeStartObject();
            gen.writeStringField('sfId', ord.Id);
            gen.writeStringField('orderNumber', ord.OrderNumber);
            gen.writeStringField('customerEmail', ord.CustomerAuthorizedBy.Email);
            gen.writeEndObject();
        }
        gen.writeEndArray();
        String jsonData = gen.getAsString();
        System.debug('jsonData-' + jsonData);
        return jsonData;
    }

    public class Request{
        @InvocableVariable(label='Record Id' required=true)
        public Id RecordId;
    }
    public class Results{
        @InvocableVariable(label='Output Response')
        public String returnMessage;

    }


}
