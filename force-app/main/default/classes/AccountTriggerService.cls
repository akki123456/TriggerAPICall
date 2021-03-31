/*---------------------------------------------------------------
Description :            Class to log Exceptions 
Test Class :             AccountTriggerTest
-----------------------------------------------------------------*/
public inherited sharing class AccountTriggerService {

    public static final String EMAIL_FIELD_MISSING_MSG = 'Please add a valid email to the Email field of the account.';
    public static final String EMAIL_SUBJECT = 'Test Account Email';
    public static final String EMAIL_BODY    = 'Test Email Body';

    //Method to compare the Account Name with Regex
    public static void sendMail(List<Account> newAccountList) {
        try {
            String regex = AccountSettings__c.getInstance().RegexForSendingMail__c;
            List<String> emailsWithNameMatchList = new List<String>();

            if (String.isNotBlank(regex)) {
                Pattern pattern = Pattern.compile(regex);           //compile pattern for better performance in case of bulk operation
                
                for (Account account : newAccountList) {
                    if (pattern.matcher(account.Name).matches()) {
                        if (String.isNotBlank(account.Email__c) ) { emailsWithNameMatchList.add(account.Email__c); }
                        else                                      { account.addError(EMAIL_FIELD_MISSING_MSG);}  
                        
                    }
                }
            }
            if (emailsWithNameMatchList.size() > 0) { sendMailByMailGun(emailsWithNameMatchList); }
        } catch (Exception e) {
            for (Account account : newAccountList) { account.addError(e.getMessage());}  
        }
    }

    // future method to send email using Mailgun
    @future(Callout = true)
    public static void sendMailByMailGun(List<String> emailList) {
        String emailCsv = '';

        for (String email : emailList) {
            emailCsv = emailCsv == '' ? email : emailCsv + ',' + email;             // list to email csv
        }
        try {
            MailGunMailService.sendEmail(emailCsv, EMAIL_SUBJECT, EMAIL_BODY);
        } catch(Exception e) {
             ExceptionLogger.addException(e);
        } finally {
            ExceptionLogger.saveExceptionLog();
        }

    }
}
