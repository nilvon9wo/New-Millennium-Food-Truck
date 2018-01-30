@isTest
public class OrderItemSelectorMock extends OrderItemSelector {
	public Set<Id> receivedOrderIdSet; 
	public List<OrderItem> returnedOrderItemList;
	public override List<OrderItem> selectByOrderId(Set<Id> orderIdSet) {
		this.receivedOrderIdSet = orderIdSet;
    	return this.returnedOrderItemList;    	
    }
    
    public Map<Id, Product2> receivedProductMap;
    public Map<Id, Product2> returnedProductMap;
    public override Map<Id, Product2> aggregateQuantityOrderedByProduct2(Map<Id, Product2> productMap) {
    	this.receivedProductMap = productMap;
    	return this.returnedProductMap;
    }    
}