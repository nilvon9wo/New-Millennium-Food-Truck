/**
 * @name orderTrigger
 * @description
**/
trigger orderTrigger on Order (
    before insert, after insert
    ,before update, after update
    ,before delete, after delete
    ,after undelete
) {
	// TODO: Implement a proper trigger handler
    try {
        if ( Trigger.New != null ){
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