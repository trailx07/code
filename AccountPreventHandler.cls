/**
* @Classname AccountPreventHandler
* @description Trigger Handler Class for Account Object to prevent deletion if Finance Team profile users are updating or deleting the account prior to 7 days
*/
    public with sharing class AccountPreventHandler {
    public static final String FINANCEPROFILE='Finance Team';
    public static final String ERROR='Account record cannot be updated or deleted as it is created prior than 7 days';
    
    /**
* @Method Name financeteamToDeleteAccount
* @description This method is used to prevent the user to delete any account record if the user's profile is 'Finance Team' and is created prior to 7 days.
* @param accountRecordMap
*/
        public static void financeteamToDeleteAccount(List<Account> accountRecordList){
        
        //Retrieving profile Id of current user.
        Id currentProfileId = UserInfo.getProfileId();
        //Retrieving profile Id of Finance Team.
        Id financeUserProfileId = [select Id, Name from Profile where name = :FINANCEPROFILE WITH USER_MODE LIMIT 1].Id;
        Set<ID> accountIds = new Set<ID>();
        if(Account.SObjectType.getDescribe().isAccessible() ){
        Map<Id,Account> accountMap= new Map<Id,Account>([SELECT ID, CreatedDate,Name FROM Account WHERE ID IN :accountIds WITH USER_MODE]);
        }
        for(Account acc : accountRecordList){
            accountIds.add(acc.Id);
        }
        for(Account accObj:accountRecordList){
            //check if list is not empty and profile is 'Finance Team'
            if(!accountIds.isEmpty() && currentProfileId == financeUserProfileId){ 
                Date dt=Date.today();
                Date accDate = accObj.CreatedDate.date();
                //calculate the days 
                Integer noOfDays = accDate.daysBetween(dt);
                // add error if account is prior to 7 days
                if(noOfDays>7){
                    accObj.adderror(ERROR +accObj);
                }
                
            }
        }
    }  
}