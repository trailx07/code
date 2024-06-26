/* 
*ClassName ........: AccountUpdateBatch
* description.......: batch class which is updating all the Accounts in the system.
**/
global class AccountUpdateBatch implements Database.Batchable<sobject>,Database.Stateful {
    global integer count = 0;
    public static final String NAMETEXT='Updated by Batch';
    /** 
*@Method Name start()
*@description 	collect the batches of records for Account to be passed to execute
*@param acc_update_lst
*/
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('select id,name from account');
    }
    /**
*@Method Name execute()
*@description It is used to update account name
*/
    global void execute(Database.BatchableContext BC, List<Account> scope) 
    {
        for(Account a : scope)
        {
            a.Name = a.Name + NAMETEXT;
        }
        if(Account.SObjectType.getDescribe().isAccessible() && Contact.SObjectType.getDescribe().isUpdateable()){
        Database.update(scope);
        }
    }
    
    /**
*@Method Name finish()
*@description  execute any post-processing operations
*/
    global void finish(Database.BatchableContext bc) {
        //	Used to execute post-processing operations (ex, sending an email)
    }
    
}