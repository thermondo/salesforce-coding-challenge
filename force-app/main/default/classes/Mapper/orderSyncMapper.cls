/**
 * Maps Standard Order Object to NPS API Callout Service for integration.
 * @author Shakil Ahmad (shakil.mr.ahmad@gmail.com)
 * Todo: will be extended on demand
 */

public with sharing class orderSyncMapper {

    /**
     * Todo: to Validate if applicable to Person Accounts
     * PERSONACCOUNTRECORDTYPE sets the person account record type Id
     */    
    static final RecordType PERSONACCOUNTRECORDTYPE = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'];



    public static orderSyncRequestModel mapOrderToOrderSyncModel(Order order){

        orderSyncModel model = new orderSyncModel();

        model.sfId = order.Id;
        model.orderNumber = order.OrderNumber;
        model.customerEmail = order.Account.PersonEmail;

        return new orderSyncRequestModel(model);

    }    
}
