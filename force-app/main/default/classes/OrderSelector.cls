/**
 * @description       : This class for Order records selection
 * 						- retrieves orders with contact Bill To E-Mail Address by taking order ids as input
 * @created by		  : Ravikishore Tekuri	
 * @created on  	  : 14-08-2023
 * @last modified on  : 14-08-2023
**/

public class OrderSelector {
	public List<Order> selectOrdersWithBillToContactEmails(Set<Id> orderIdSet) {
        List<Order> orderList = [SELECT Id, Status, BillToContactId, BillToContact.Email, OrderNumber FROM Order WHERE Id IN :orderIdSet];
        return orderList;
    }
}