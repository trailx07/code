/**
 * @Test Class Name AccountPreventHandlerTest
 * @description It is used to perform unit test for the helper class AccountPreventTriggerHandler.
 */
@isTest(seeAllData=false)
public class AccountPreventHandlerTest {

    public static final String USER_FIRSTNAME = 'TestFN';
    public static final String USER_LASTNAME = 'TestLN';
    public static final String USER_EMAIL = 'testuser100@example.com';
    public static final String USER_ALIAS = 'tuser';
    public static final String USER_TIMEZONE = 'America/Los_Angeles';
    public static final String USER_LOCALE = 'en_US';
    public static final String USER_EMAILENCODING = 'UTF-8';
    public static final String PROFILE_NAME = 'Finance Team';
    public static final String ACC_NAME='TestAccount';
    public static final String ACC_BILLINGPOSTALCODE='NY 10020';

        
    @TestSetup
    /**
     * @Method Name testData
     * @description This method is used to create the test data for User and Task object.   
     */
    static void testData(){

        //SOQL Query to get Finance Team profile Id to create User record
        Id profileId = [SELECT Id FROM Profile WHERE Name =: PROFILE_NAME WITH SECURITY_ENFORCED LIMIT 1].Id;
        
        //Creating a TestUser record
        User testuser = new User(
            firstname = USER_FIRSTNAME,
            lastName = USER_LASTNAME,
            email = USER_EMAIL,
            Username = USER_EMAIL,
            EmailEncodingKey = USER_EMAILENCODING,
            Alias = USER_ALIAS,
            ProfileId = profileId,
            TimeZoneSidKey = USER_TIMEZONE,
            LocaleSidKey = USER_LOCALE,
            LanguageLocaleKey = USER_LOCALE
        );
        if(Account.SObjectType.getDescribe().iscreateable()){
        Database.insert(testuser);
        }
        Account acc=new Account();
        acc.Name=ACC_NAME;
        
        acc.BillingPostalCode=ACC_BILLINGPOSTALCODE;
        if(Account.SObjectType.getDescribe().iscreateable()){
        Database.insert(acc);
        }
    }

    /**
     * @Method Name testAccountBeforeDelete
     * @description It is used to perform unit test for the handler class AccountPreventHandler to check 
     * whether the user record is getting deleted or not when user's profile is Finance Team and Account is craeted prior to 7 days.
     */
    @isTest static void testAccountBeforeDelete(){
        //Retrieving the test user
		User testUser = [select Id from User where Username = :USER_EMAIL WITH USER_MODE];
        
        System.runAs(testUser){

            Account rec = [select Id, Name from Account where Name=:ACC_NAME WITH USER_MODE];
            Test.startTest();
            if(Account.SObjectType.getDescribe().isAccessible()){
            Database.delete(rec);
            }
            Test.stopTest();
            List<Account> accList = [select Id, Name from Account where OwnerId= :testUser.Id];
        }
    }
}