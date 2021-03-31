# TriggerAPICall

To switch the trigger on, add an orgwide(or for any user/profile) AccountSettings__c record with following config 

TRG_SendMailOnMatch__c = true; // flag to switch on/off the trigger of sending email from Account trigger

RegexForSendingMail__c = '\bTEST[0-9]\b'; // Use any regular expression. This will be used to match the Account name. 

Following values are for my test Mailgun account.
MailGunApiKey__c       = '7d52129ee955a7baf558c1cd3d55c92e-b6d086a8-7151dcda'; // This is the api key used to authenticate MailGun account
MailGunSenderEmail__c  = 'mailgun@sandbox9a784fc949b64716b5bd85ddb128adf3.mailgun.org'; // An email address which has the domain registered in Mailgun.

In case you want to use a different account , apart from above values , you will need to update the NamedCredential (MailGun Endpoint) url to reflect the new domain.

Notes: 
1) Email is sent to the email specified in matching account's Email__c field. (This is a new custom field created as part of this solution)

