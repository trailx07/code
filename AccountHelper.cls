/**
 * @Classname AccountHelper
 * @description Trigger Handler Class for Account Object
 */
public with sharing class AccountHelper {
    public static String strSeprator = '-'; // variable storing the seprator of strings while concatenation
        /**
         * @Methodname updateContactUsername
         * @description This method update the usenameAccess custom field of contact object with account website , firstname and lastname.
         * @param newMapAcc
         * @param oldMapAcc
         **/
        public static void updateContactUsername(Map<ID, Account> newMapAcc , Map<ID, Account> oldMapAcc){
            // variable to store the account Ids
            Set<Id> setAcc = new Set<Id>(); 
            //iterating through new account Map
            for(Account newAcc : newMapAcc.values()){
                //comparing the new website field with its old value
                if(!(String.isempty(newAcc.website)) && !(newAcc.website.equalsIgnorecase(oldMapAcc.get(newAcc.Id).website))){
                    //adding the account id in set if the website field is changed.
                    setAcc.add(newAcc.id);
                }
            }
            //variable to store the list of contacts to be updated.
            List<Contact> lstCon = new List<Contact>();
            if(Contact.SObjectType.getDescribe().isAccessible()){
                //iterating through associated contact to update the usernameAccess Field
                for(Contact conObj : [SELECT Firstname,Lastname, usernameAccess__c , Account.Website FROM Contact WHERE AccountId IN: setAcc WITH USER_MODE]){
                    // Assigning the username access field with Account Website ,firtsname, lastname
                    conObj.usernameAccess__c = conObj.Account.website + strSeprator + conObj.firstname + conObj.Lastname;
                    //adding the contact to the contactList
                    lstCon.add(conObj);
                }
                //Updating the Contact record and checking if the record has been successfully updated.
                Database.SaveResult[] conResults = Database.update(lstCon, false);
                for (Database.SaveResult sr : conResults) {
                    if (!sr.isSuccess()) {
                        for (Database.Error err : sr.getErrors()) {
                            //Perform Error Handling here
                        }
                    }
                }
                
            }
        }
    }