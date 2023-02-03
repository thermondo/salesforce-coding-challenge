@isTest
    public class npsMock implements HttpCalloutMock{
  	private string value;
    public npsMock(String value) {
    this.value = value;
  	}
      public HttpResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
           if (value.equalsIgnoreCase('200')) {
       		 	res.setStatus('OK');
        		res.setStatusCode(200);
        		res.setBody('SUCESS');
        		return res;
           }
          else if(value.equalsIgnoreCase('400')){
                res.setStatus('Bad Request');
        		res.setStatusCode(400);
        		res.setBody('BAD_PAYLOAD');
        		return res;
          }
          else{
              res.setStatus('Bad Request');
        		res.setStatusCode(500);
        		res.setBody('INTERNAL_SERVER_ERROR');
        		return res;
          }
      }
    }