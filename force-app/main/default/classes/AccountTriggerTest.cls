/*---------------------------------------------------------------
Description :            Test class for Account Trigger and Mailgun service
Test Class :             N/A
-----------------------------------------------------------------*/
@IsTest
public class AccountTriggerTest {
    
    @TestSetup
    static void setup(){
        AccountSettings__c accountSettings = new AccountSettings__c();

        accountSettings.TRG_SendMailOnMatch__c = true;
        accountSettings.MailGunApiKey__c       = '';
        accountSettings.RegexForSendingMail__c = '.*';
        accountSettings.MailGunSenderEmail__c  = 'someEmail';

        insert accountSettings;
    }

    @IsTest
    public static void testAccountTriggerWithSuccess() {
        Account account = new Account( Name     = 'Test Name',
                                       Email__c = 'test@test12323.com'  );

        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(true));

        Test.startTest();
        insert account;
        Test.stopTest();

        List<ExceptionLog__c> exceptionLog = [SELECT Id, Name FROM ExceptionLog__c];
        System.assertEquals(0, exceptionLog.size());
    }

    @IsTest
    public static void testAccountTriggerWithErrorCode() {
        Account account = new Account( Name     = 'Test Name',
                                       Email__c = 'test@test12323.com'  );

        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(false));

        Test.startTest();
        insert account;
        Test.stopTest();

        List<ExceptionLog__c> exceptionLog = [SELECT Id, Name FROM ExceptionLog__c];
        System.assertNotEquals(0, exceptionLog.size());
    }

    @IsTest
    public static void testAccountTriggerWithNonMatchingName() {
        AccountSettings__c accountSettings = [SELECT Id, RegexForSendingMail__c FROM AccountSettings__c];
        
        accountSettings.RegexForSendingMail__c = '\\bTest[0-9]\\b';

        update accountSettings;

        Account account = new Account( Name     = 'Test Name',
                                       Email__c = 'test@test12323.com'  );

        //If the mock response is called it will throw an assertion error. 
        //Expectation is regex wont match name and thus no callout should be made
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(true, false));

        Test.startTest();
        insert account;
        Test.stopTest();
    }

    @IsTest
    public static void testAccountTriggerWithUpdate() {
        AccountSettings__c accountSettings = [SELECT Id, RegexForSendingMail__c FROM AccountSettings__c];
        
        accountSettings.RegexForSendingMail__c = '\\bTest[0-9]\\b';

        update accountSettings;

        Account account = new Account( Name     = 'Test Name',
                                       Email__c = 'test@test12323.com'  );

        //If the mock response is called it will throw an assertion error. 
        //Expectation is regex wont match name and thus no callout should be made
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(true, false));
        insert account;
        // changing the mock along with matching name
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(true, true));
        account.Name = 'Test1';
        
        Test.startTest();
        update account;
        Test.stopTest();
    }

    @IsTest
    public static void testAccountTriggerWithBlankEmail() {
        Account account = new Account(Name = 'Test Name');

        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(true, false));

        Test.startTest();
        insert account;
        Test.stopTest();

        List<Account> accountList = [SELECT Id, Name FROM Account ];
        System.assertEquals(0, accountList.size());
    }

    @IsTest
    public static void testAccountTriggerWithRegexError() {
        AccountSettings__c accountSettings = [SELECT Id, RegexForSendingMail__c FROM AccountSettings__c];
        
        accountSettings.RegexForSendingMail__c = '*';

        update accountSettings;
        Account account = new Account( Name     = 'Test Name',
                                       Email__c = 'test@test12323.com'  );

        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(true, false));

        Test.startTest();
        insert account;
        Test.stopTest();

        List<Account> accountList = [SELECT Id, Name FROM Account ];
        System.assertEquals(0, accountList.size());
    }
}
