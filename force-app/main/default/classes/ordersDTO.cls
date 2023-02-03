public class ordersDTO {
    Public string method;
    Public string endpoint;
    public set<RequestBody> requestBody;
    
	public class Response {
    public  string status;
    public  String StatusCode;
  }
    public class RequestBody {
    public Id sfId;
    public  String orderNumber;
    public  string customerEmail;
  }
}