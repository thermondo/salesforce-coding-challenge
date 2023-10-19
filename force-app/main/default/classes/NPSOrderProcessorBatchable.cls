//Considering that the insert Orders method in the NPS Service accepts 30 records at once and the async call principle of callouts, 
//I think it would be more correct to call the NPS Service from the Batchable Apex.
//This Batchable class is ready to use.

public with sharing class NPSOrderProcessorBatchable implements Database.Batchable<sObject>, Database.AllowsCallouts {
    private string query;
    private List<Id> idList;
    public HttpResponse response;
    
    public NPSOrderProcessorBatchable(List<Id> ids){
        this.idList = ids;
        this.query = 'SELECT Id, OrderNumber, BillToContact.Email FROM Order WHERE Id IN :idList';
    }

    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }
  
    public void execute(Database.BatchableContext bc, List<Order> orderList){
        NPSService npsService = new NPSService();
        response = npsService.insertOrders(orderList);  
    }
  
    public void finish(Database.BatchableContext bc){

        //TODO:
        //Send the batchapex result by email to Admin 
        //Use HttpResponse in email
    }
}