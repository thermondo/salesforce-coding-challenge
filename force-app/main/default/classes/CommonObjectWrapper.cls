public with sharing class CommonObjectWrapper {
    //NPS Service Order Object Wrapper
    public class NPSOrder {                
        public String sfId { get; set;}
        public String orderNumber { get; set;}
        public String customerEmail { get; set;}
            
        public NPSOrder(Order order){
            this.sfId = order.Id;
            this.orderNumber = order.OrderNumber;
            this.customerEmail = order.BillToContact.Email;
        }
    }
}