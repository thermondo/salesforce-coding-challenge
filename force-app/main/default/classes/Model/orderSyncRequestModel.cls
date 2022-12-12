/**
 * Creates a Request model for HttpCallout
 * @author Shakil Ahmad (shakil.mr.ahmad@gmail.com)
 * Todo: will be extended on demand
 */

public with sharing class orderSyncRequestModel {

    public orderSyncModel order;

    public orderSyncRequestModel(orderSyncModel model) {
        this.order = model;
    }
}
