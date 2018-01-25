trigger OrderTrigger on Order (after insert, before update, after undelete) {
	// TODO: Implement a proper trigger handler
    try {
        if ( Trigger.new != null ){
			OrderHelper.AfterUpdate(Trigger.new, Trigger.old);
        }
         
        // FIXME: Don't alter code flow for testing
        if (Test.isRunningTest() && OrderTriggerIntTest.isExceptionTest) {
        	throw new OrderTriggerException('Trigger Exception Test');
        }
    } 
    // FIXME: Don't catch generic exceptions!
    catch ( Exception e ){
    	// FIXME: Don't swallow exceptions!
    }
}