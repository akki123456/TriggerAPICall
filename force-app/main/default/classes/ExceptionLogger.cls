/*---------------------------------------------------------------
Description :            Class to log Exceptions 
Test Class :             AccountTriggerTest
-----------------------------------------------------------------*/
public class ExceptionLogger {
    private static List<ExceptionLog__c> exceptionLogList = new List<ExceptionLog__c>();

    // Method to insert exception to Exception Log Object
    public static void addException (Exception ex) {
        try {
            String stackTrace = ex.getStackTraceString().substringBefore('\n');
            String className  = stackTrace.substringAfter('.').substringBefore('.');	
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            
            String exceptionLine       = ex.getLineNumber() + '';
            String exceptionStackTrace = ex.getStackTraceString();
            String exceptionType       = ex.getTypeName(); 
            String exceptionMessage    = ex.getMessage(); 

            ExceptionLog__c log = new ExceptionLog__c(
                                    ClassName__c        = className,
                                    MethodName__c       = methodName,
                                    ExceptionLine__c    = exceptionLine,
                                    ExceptionMessage__c = exceptionMessage,
                                    ExceptionDetails__c = exceptionStackTrace,
                                    ExceptionType__c    = exceptionType
                                    );

            exceptionLogList.add(log); 
        } catch (Exception e) {
            System.debug(e);
        }
    }

    public static void saveExceptionLog() {
        if(exceptionLogList.isEmpty() == false){
            Database.insert(exceptionLogList,false); 
        }
    }
 
}
