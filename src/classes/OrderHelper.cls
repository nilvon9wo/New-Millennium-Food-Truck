public class OrderHelper {
	F45_DML_GenericDml genericDml;
	OrderItemSelector orderItemSelector;
	OrderItemAggregateSelector orderItemAggregateSelector;
	SetHelper setHelper;
	
	public OrderHelper(
			F45_DML_GenericDml genericDml, 
			OrderItemSelector orderItemSelector, 
			OrderItemAggregateSelector orderItemAggregateSelector,
			SetHelper setHelper
		) {
		this.genericDml = genericDml;
		this.orderItemSelector = orderItemSelector;
		this.orderItemAggregateSelector = orderItemAggregateSelector;
		this.setHelper = setHelper;
	}	

	public OrderHelper() {
		this(new F45_DML_GenericDml(), new OrderItemSelector(), new OrderItemAggregateSelector(), new SetHelper());
	}	

	private static String ACTIVATED_ORDER_STATUS = Constants.ACTIVATED_ORDER_STATUS;

    /**
     * @name AfterUpdate
     * @description 
     * @param List<Order> newList
     * @param List<Order> oldList
     * @return void
    **/
    public static void AfterUpdate(List<Order> newOrderList, List<Order> oldOrderList){
    	(new OrderHelper()).onAfterUpdate(newOrderList, oldOrderList);
    }
    
    private List<OrderItem> onAfterUpdate(List<Order> newOrderList, List<Order> oldOrderList) {
    	SObjectField targetField = Order.Status;
    	Object targetValue = ACTIVATED_ORDER_STATUS;
    	Set<Id> changeIdSet = this.setHelper.buildHasChangedToTargetValueIdSet(newOrderList, oldOrderList, targetField, targetValue);
        return this.updateOrderItemQuantities(changeIdSet);
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
     
    public List<OrderItem> updateOrderItemQuantities(Set<Id> activatedOrderIdSet) {
        List<OrderItem> orderItemList = this.orderItemSelector.selectByOrderId(activatedOrderIdSet);

        Map<Id, Product2> productMap = new Map<Id, Product2>();
        for (OrderItem orderItem : orderItemList) {
        	productMap.put(orderItem.Pricebookentry.Product2Id, orderItem.Pricebookentry.Product2);
        }
		
		List<AggregateResult> orderItemAggregateResultList = this.orderItemAggregateSelector.aggregateQuantityOrderedByProduct2(productMap.keySet());
		for (AggregateResult aggregateResult : orderItemAggregateResultList) {
			Product2 product = productMap.get((Id) aggregateResult.get('Product2Id'));
			product.Quantity_Ordered__c = (Decimal) aggregateResult.get('expr0');
		}
		
        this.genericDml.doUpdate(productMap.values());
        return orderItemList;
    }

}