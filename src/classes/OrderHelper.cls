public class OrderHelper {
	private static String ACTIVATED_ORDER_STATUS = Constants.ACTIVATED_ORDER_STATUS;

    /** 
     * @name AfterUpdate
     * @description  
     * @param List<Order> newList
     * @param List<Order> oldList
     * @return void
    **/
    public static void afterUpdate(List<Order> newOrderList, List<Order> oldOrderList){
    	(new OrderHelper()).onAfterUpdate(newOrderList, oldOrderList);
    }
    
    @testVisible
    private List<OrderItem> onAfterUpdate(List<Order> newOrderList, List<Order> oldOrderList) {
    	SObjectField targetField = Order.Status;
    	Object targetValue = ACTIVATED_ORDER_STATUS;
    	Set<Id> changeIdSet = this.buildHasChangedToTargetValueIdSet(newOrderList, oldOrderList, targetField, targetValue);
        return this.updateOrderItemQuantities(changeIdSet);
    } 

    /**
     * @name RollUpOrderItems 
     * @description Given a set of Activated Order ids, query the child Order Items and related Products to calculate Inventory levels
     * @param Set<Id> activatedOrderIds
     * @return void
    **/
    public static void rollUpOrderItems(Set<Id> activatedOrderIds){
    	(new OrderHelper()).updateOrderItemQuantities(activatedOrderIds);
    }
     
    @testVisible
    private List<OrderItem> updateOrderItemQuantities(Set<Id> activatedOrderIdSet) {
        List<OrderItem> orderItemList = this.selectByOrderId(activatedOrderIdSet);

        Map<Id, Product2> productMap = new Map<Id, Product2>();
        for (OrderItem orderItem : orderItemList) {
        	productMap.put(orderItem.Pricebookentry.Product2Id, orderItem.Pricebookentry.Product2);
        }
        
		Map<Id, Product2> resultProductMap = this.aggregateQuantityOrderedByProduct2(productMap);
        update resultProductMap.values();
        return orderItemList;
    }

    private virtual List<OrderItem> selectByOrderId(Set<Id> orderIdSet) {
    	return [
			SELECT Id, Pricebookentry.Product2Id, Pricebookentry.Product2.Id
            FROM OrderItem
            WHERE OrderId IN :orderIdSet
		];    	
    }

    private virtual Map<Id, Product2> aggregateQuantityOrderedByProduct2(Map<Id, Product2> productMap) {
		List<AggregateResult> aggregateResultList = [
			SELECT Pricebookentry.Product2Id, SUM(Quantity)
            FROM OrderItem
            WHERE Pricebookentry.Product2Id IN :productMap.keySet()
            GROUP BY Pricebookentry.Product2Id
		];    
		
		for (AggregateResult aggregateResult : aggregateResultList) {
			Product2 product = productMap.get((Id) aggregateResult.get('Product2Id'));
			product.Quantity_Ordered__c = (Decimal) aggregateResult.get('expr0');
		}
		
		return productMap;  
	}

    private virtual Set<Id> buildHasChangedToTargetValueIdSet(
    		List<SObject> newSObjectList, 
    		List<SObject> oldSObjectList, 
    		SObjectField sObjectField,
    		Object targetValue
    	) {
    	if (oldSObjectList == null || oldSObjectList.isEmpty()) {
    		return (new Map<Id, SObject>(newSObjectList)).keySet();
    	}
    	
    	Map<Id, SObject> oldSObjectByIdMap = new Map<Id, SObject>(oldSObjectList);
    	return this.buildHasChangedToTargetValueIdSet(newSObjectList, oldSObjectByIdMap, sObjectField, targetValue);
    }
    
    private Set<Id> buildHasChangedToTargetValueIdSet(
    		List<SObject> newSObjectList, 
    		Map<Id, SObject> oldSObjectByIdMap, 
    		SObjectField sObjectField,
    		Object targetValue
    	) {
    	Set<Id> changeSObjectIdSet = new Set<Id>();
    	for (SObject newSObject : newSObjectList) {
    		Object newValue = newSObject.get(sObjectField);
    		
    		SObject oldSObject = oldSObjectByIdMap.get(newSObject.Id);
    		Object oldValue = (oldSObject != null) ? oldSObject : null;
    		
    		if (newValue == targetValue &&  newValue != oldValue) {
    			changeSObjectIdSet.add(newSObject.Id);
    		}
    	}
    	return changeSObjectIdSet;
    }
}