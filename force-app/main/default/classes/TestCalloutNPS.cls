@isTest
private class TestCalloutNPS {

    static testMethod void testCallout(){
        List<Order> ordrList = TestDataFactory.setupDataForCallout(1);
        Id ordId = ordrList[0].Id;
        ordrList[0].Status = 'Fulfilled';
        update ordrList;
        System.debug('ordrList'+ ordrList);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator()); 
        Test.startTest();
        CalloutNPS.Request input = new CalloutNPS.Request();
        input.RecordId = ordId;
        List<CalloutNPS.Results> result = CalloutNPS.getData(new List<CalloutNPS.Request>{input});
        String retMsg = result[0].returnMessage;
        System.debug('Results'+ result);
        Boolean res = retMsg.contains('200');
        System.assertEquals(true, res);
        Test.stopTest();
    }
}