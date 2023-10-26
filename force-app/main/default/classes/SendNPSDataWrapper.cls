public with sharing class SendNPSDataWrapper {
    public String sfId {get; set;}
    public String  orderNumber {get; set;}
	public String customerEmail {get; set;}
    public SendNPSDataWrapper(String sfId, String orderNumber, String customerEmail) {
        this.sfId = sfId;
        this.orderNumber = orderNumber;
        this.customerEmail = customerEmail;
    }

    /*public class NPSCalloutOutput{
        @InvocableVariable public Integer httpResponseCode;
        @InvocableVariable public String httpResponseMessage;
        @InvocableVariable public string httpResponseSuccess;
        public NPSCalloutOutput(Integer httpResponseCode,
                                String httpResponseMessage,
                                string httpResponseSuccess){
            this.httpResponseCode = httpResponseCode;
            this.httpResponseMessage = httpResponseMessage;
            this.httpResponseSuccess = httpResponseSuccess;
                                }

    }*/
}