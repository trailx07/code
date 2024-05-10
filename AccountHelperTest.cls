/**
* @Classname.....AccountHelperTest
* @description....Test class for Trigger Handler Class for Account Object
*/
@isTest
private class AccountHelperTest {
    @testSetup
    public static void setup() {
        //Create user
        UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'CEO' With USER_MODE Limit 1];
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' With USER_MODE Limit 1].Id;
        user u = New User();
        u.LastName = 'Test';
        u.UserRoleId = userRole.Id;
        u.ProfileId = ProfileId;
        u.Email = 'Test67@test1.com';
        u.Username = 'Test1231@test.com' + System.currentTimeMillis();
        u.CompanyName = 'TEST';
        u.Title = 'title';
        u.Alias = 'Test';            
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        insert u;
        
        
        // update account to Partner Account
        System.runAs(u) {
            //Create Account
            String businessRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
            Account acc = New Account();
            acc.Name = 'Test';
            acc.RecordTypeId = businessRecTypeId;
            insert acc;
            Account acc1 = New Account();
            acc1.Name = 'Test1';
            acc1.RecordTypeId = businessRecTypeId;
            insert acc1;
            //Create Contact and related with Account
            Contact c = New contact();
            c.LastName = 'Test';
            c.Email = 'Test33@test.com';
            c.AccountId = acc.Id;
            insert c;
            
            //acc.IsPartner = true;
            //update acc;
            //System.assertEquals(acc.IsPartner, true ,'Test Postive Partner Account');
        }
    }
    /**
* @Methodname.....createPartnerUser_Postive
* @description....Method to Test Partner user is Created
*/
    static testMethod void createPartnerUser_Postive() {
        user u = [Select Id from User where email = 'Test67@test1.com' With USER_MODE];
        // update account to Partner Account
        System.runAs(u) {
            Account acc = [Select Id,IsPartner from Account where Name = 'Test'With USER_MODE Limit 1];
            acc.IsPartner = true;
            update acc;
            System.assertEquals(acc.IsPartner, true ,'Test Postive Partner Account');
        }
    }
    /**
* @Methodname.....createPartnerUser_Negative
* @description....Method to Test for Non Partner user is Created
*/
    static testMethod void createPartnerUser_Negative() {
        user u = [Select Id from User where email = 'Test67@test1.com' With USER_MODE];
        Account acc = [Select Id,IsPartner from Account where Name = 'Test1' With USER_MODE Limit 1];
        // update account to Parner Account
        System.runAs(u) {
            update acc;
        }
        System.assertEquals(acc.IsPartner, false ,'Test Negative Partner Account');
    }
}