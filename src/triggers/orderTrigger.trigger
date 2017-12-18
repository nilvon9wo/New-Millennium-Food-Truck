trigger orderTrigger on Order (after insert, after update, after delete, after undelete) {
	(new OrderTriggerHandler()).invoke();
}