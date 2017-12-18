public with sharing class OrderHelper {
	GenericDml genericDml;
	OrderItemSelector orderItemSelector;
	ProductAggregateSelector productAggregateSelector;
	
	public OrderHelper(
			GenericDml genericDml, 
			OrderItemSelector orderItemSelector, 
			ProductAggregateSelector productAggregateSelector
		) {
		this.genericDml = genericDml;
		this.orderItemSelector = orderItemSelector;
		this.productAggregateSelector = productAggregateSelector;
	}	

	public OrderHelper() {
		this(new GenericDml(), new OrderItemSelector(), new ProductAggregateSelector());
	}	

    /**
     * @name AfterUpdate
     * @description 
     * @param List<Order> newList
     * @param List<Order> oldList
     * @return void
    **/
    public static void AfterUpdate(List<Order> newList, List<Order> oldList){
        Set<Id> orderIds = new Set<Id>();
        for ( Integer i=0; i<newList.size(); i++ ){
            if ( newList[i].Status == 'Activation' && oldList[i].Status != 'Activate' ){
                orderIds.add(newList[i].Id);
            }
        }
    }

    /**
     * @name RollUpOrderItems 
     * @description Given a set of Activated Order ids, query the child Order Items and related Products to calculate Inventory levels
     * @param Set<Id> activatedOrderIds
     * @return void
    **/
    public static void RollUpOrderItems(Set<Id> activatedOrderIds){
    	(new OrderHelper()).updateOrderItemQuantities(activatedOrderIds);
    }
     
    public List<OrderItem> updateOrderItemQuantities(Set<Id> activatedOrderIds) {
        List<OrderItem> orderItemList = this.orderItemSelector.selectByOrderId(activatedOrderIds);

        //ToDo: Declare a Map named "productMap" of Ids to Product2 records
        Map<Id, Product2> productByIdMap = new Map<Id, Product2>();
        for (OrderItem orderItem : orderItemList) {
        	productByIdMap.put(orderItem.Pricebookentry.Product2Id, orderItem.Pricebookentry.Product2);
        }
		
		List<AggregateResult> aggregateResultList = this.productAggregateSelector
			.aggregateQuantityOrderedByProduct2(productByIdMap.keySet());
			 
		for (AggregateResult aggregateResult : aggregateResultList) {
			Product2 product = productByIdMap.get((Id) aggregateResult.get('Product2Id'));
			product.Quantity_Ordered__c = (Decimal) aggregateResult.get('expr0');
		}
		
        this.genericDml.doUpdate(productByIdMap.values());
        return orderItemList;
    }

}