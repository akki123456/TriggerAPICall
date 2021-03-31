/*---------------------------------------------------------------
Description :             Mailgun Integration Service class
Test Class :              AccountTriggerTest
-----------------------------------------------------------------*/
public class MailGunMailService {
    private static final String API_KEY      = AccountSettings__c.getInstance().MailGunApiKey__c;
    private static final String SENDER_EMAIL = AccountSettings__c.getInstance().MailGunSenderEmail__c;

    public static void sendEmail(String toEmail, String subject, String text) {
        String sBody = 'from='     + SENDER_EMAIL +
                       '&to='      + toEmail + 
                       '&subject=' + subject + 
                       '&text='    + text;

        Blob headerValue = Blob.valueOf('api'+ ':' + API_KEY);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);

        HttpRequest req = new HttpRequest();

        req.setEndpoint('callout:MailGunEndpoint');                         //Named Credentials
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setHeader('Accept', 'application/json, application/xml, text/json, text/x-json, text/javascript, text/xml, application/json');
        req.setBody(sBody);
        req.setHeader('Content-Length', string.valueOf(sBody.length()));
        req.setMethod('POST');
        req.setBody(sBody);

        try {
            HttpResponse res = new Http().send(req);
            if (res.getStatusCode() != 200) { throw new MailGunException(res.toString());}
        }catch (Exception e) {
            ExceptionLogger.addException(e);
        }
    }

    private class MailGunException extends Exception {

    }
}
