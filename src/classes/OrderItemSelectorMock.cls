@isTest
public class OrderItemSelectorMock extends OrderItemSelector {
	public Set<Id> receivedOrderIdSet;
	public List<OrderItem> returnedOrderItemList;
	public override List<OrderItem> selectByOrderId(Set<Id> orderIdSet) {
		this.receivedOrderIdSet = orderIdSet;
    	return this.returnedOrderItemList;    	 
    }
}