/**
 * Mocks the Access Token for Authorization * 
 * @author Shakil Ahmad (shakil.mr.ahmad@gmail.com)
 * Todo: will be extended on demand
 */

@istest
public class TestUtils {

    private static final String TOKEN_SETTING_NAME = 'Thermondo Token';
    private static final String TOKEN_SETTING_VALUE = 'de1qo5n2kkctfjdy4339hdfly9uum1lyb';

    // insert an Authorization Token
    @TestVisible
    public static void insertAuthorizationToken() {
        Thermondo_Token__c thermondoAccessToken = new Thermondo_Token__c();
        thermondoAccessToken.Token__c = TOKEN_SETTING_VALUE;
        thermondoAccessToken.Name = TOKEN_SETTING_NAME;
        insert thermondoAccessToken;
    }
}
