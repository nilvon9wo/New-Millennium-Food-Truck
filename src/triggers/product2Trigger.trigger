trigger product2Trigger on Product2 (
    after update
) {
	Product2Helper.afterUpdate(Trigger.old, Trigger.new); 
}