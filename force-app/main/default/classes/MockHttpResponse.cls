/*---------------------------------------------------------------
Description :            Class to Mock the Http Response for Test classes
Test Class :             AccountTriggerTest
-----------------------------------------------------------------*/
public class MockHttpResponse implements HttpCalloutMock {
    Boolean  isMockResponseSuccessful;
    Boolean  shouldCallout; 

    public MockHttpResponse(Boolean isMockResponseSuccessful) {
        this(isMockResponseSuccessful, true);
    }

    public MockHttpResponse(Boolean isMockResponseSuccessful, Boolean shouldCallout) {
        this.isMockResponseSuccessful = isMockResponseSuccessful;
        this.shouldCallout            = shouldCallout;
    }

    public HTTPResponse respond(HTTPRequest req) {
        System.assertEquals(true, shouldCallout);
        System.assertEquals('POST', req.getMethod());
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
         if (this.isMockResponseSuccessful) {
            res.setStatusCode(200);      
        } else {
            res.setStatusCode(400);
            res.setStatus('Bad request');
        }
        return res;
    }
}
