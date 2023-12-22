/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This apex class is used to make the Wrapper To Post Data to The NPS
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Nitish Bhardwaj
* @version        1.0
* @created        2023-12-21
* @modified       2023-12-21
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public without sharing class NPSResponseWrapper {
    public String sfId {get; set;}
    public String  orderNumber {get; set;}
	public String customerEmail {get; set;}
    public NPSResponseWrapper(String id, String orderNumber, String customerEmail) {
        this.sfId = id;
        this.orderNumber = orderNumber;
        this.customerEmail = customerEmail;
    }
}