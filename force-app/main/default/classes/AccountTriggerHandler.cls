/*---------------------------------------------------------------
Description :            Trigger Handler for Account
Test Class :             AccountTriggerTest
-----------------------------------------------------------------*/
public class AccountTriggerHandler extends TriggerHandler {
    private Map<Id, Account> newAccountMap;
    private Map<Id, Account> oldAccountMap;

    private List<Account> newAccountList;
    private List<Account> oldAccountList;

    public AccountTriggerHandler() {
        this.newAccountList = (List<Account>) Trigger.new;
        this.oldAccountList = (List<Account>) Trigger.old; 
        this.newAccountMap  = (Map<Id, Account>) Trigger.newMap;
        this.oldAccountMap  = (Map<Id, Account>) Trigger.oldMap;
    }

    public override void afterInsert() {
        if(AccountSettings__c.getInstance().TRG_SendMailOnMatch__c) {
            AccountTriggerService.sendMail(newAccountList);
        }
    }

    public override void afterUpdate() {
        if(AccountSettings__c.getInstance().TRG_SendMailOnMatch__c) {
            AccountTriggerService.sendMail(newAccountList);
        }
    }


}
