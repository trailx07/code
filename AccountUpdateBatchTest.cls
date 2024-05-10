/* ClassName ........: AccountUpdateBatch
* Description.......: test class for a batch class which updating all the Accounts in the system.
**/
@isTest
private class AccountUpdateBatchTest {
    public static final String USER_EMAIL = 'recoveracct' + String.valueOf(Datetime.now()).substring(0, 7) + '@example.com';
    public static final String USER_FIRSTNAME = 'TestFN';
    public static final String USER_LASTNAME = 'TestLN';
    public static final String USER_ALIAS = String.valueOf(Datetime.now()).substring(0, 7);
    public static final String USER_TIMEZONE = 'America/Los_Angeles';
    public static final String USER_LOCALE = 'en_US';
    public static final String USER_EMAILENCODING = 'UTF-8';
    public static final String PROFILE_NAME = 'System Administrator';
    public static final String ACCT_NAME = 'Test Account' + String.valueOf(Datetime.now());
    public static final String NAMETEXT='Updated';

    /**
* @methodName      ：createSampleUser
* @description     ：A testSetup where we create our test user
* */
    
    @TestSetup
    static void createSampleUser(){
        Account[] accList = new List<Account>();
        for (Integer i=0;i<100;i++) {
            Account ac = new Account(Name = 'Account ' + i);
            accList.add(ac);
        }
        Database.insert(accList);
        //List of Users to be created. A list is required so that we can use Database.SaveResult[]
        List<User> sampleUserList = new List<User>();
        //Query profileId to be used on User record
        Id profileId = [SELECT Id FROM Profile WHERE Name =: PROFILE_NAME WITH SECURITY_ENFORCED LIMIT 1].Id;
        //Fill out all required fields for the User creation
        User sampleUser = new User (
            Username = USER_EMAIL,
            Email = USER_EMAIL,
            FirstName = USER_FIRSTNAME,
            Lastname = USER_LASTNAME,
            Alias = USER_ALIAS,
            ProfileId = profileId,
            TimeZoneSidKey = USER_TIMEZONE,
            LocaleSidKey = USER_LOCALE,
            EmailEncodingKey = USER_EMAILENCODING,
            LanguageLocaleKey = USER_LOCALE
        );
        //Adding the single to the list
        sampleUserList.add(sampleUser);
        
        //Inserting the User record and checking if the record has been successfully inserted.
        Database.SaveResult[] userResults = Database.insert(sampleUserList, false);
        
    }
    
    
    /**
* MethodName        ：testAccountBatch()
* Purpose	        ：update accounts by the batch job
* Return	        ：None | No return since this is a void method
*/
    @isTest
    public static void testAccountBatch() {
                
        //Querying the User that we created on the Test Setup
         User runningUser = [SELECT Id FROM User WHERE Username =: USER_EMAIL WITH SECURITY_ENFORCED LIMIT 1];
        
        System.runAs(runningUser) {
        Test.startTest();
        AccountUpdateBatch c = new AccountUpdateBatch();
        Database.executeBatch(c,100);
        Test.stopTest();
        // Verify accounts updated
        Account[] accUpdatedList = [SELECT Id,Name FROM Account];
        System.assert(accUpdatedList[0].Name.Contains(NAMETEXT));
        }
        
    }
}