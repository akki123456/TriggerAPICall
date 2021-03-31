public virtual class TriggerHandler {
 
  @testVisible
  private static TriggerOperation triggerContext;

  public TriggerHandler() {
    if(!Trigger.isExecuting && !Test.isRunningTest()) {
      throw new TriggerHandlerException('TriggerHandler used outside of triggers / testing');
    }
  }

  public void run() {
    TriggerOperation context = triggerContext != null ? triggerContext : Trigger.operationType;
    
    switch on context {                         // Handling only After Insert and After Update for the solution.
      when AFTER_INSERT {
        this.afterInsert();
      } when AFTER_UPDATE {
        this.afterUpdate();
      }
    }
    this.andFinally();
  }

  protected virtual void afterInsert()   {}
  protected virtual void afterUpdate()   {}

  // runs after every context - can be used to easily implement something like apex-rollup!
  protected virtual void andFinally() {}

  private class TriggerHandlerException extends Exception {
  }
}