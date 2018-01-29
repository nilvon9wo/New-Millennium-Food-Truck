@isTest
public class OrderSelectorMock extends OrderSelector {
	public Set<Id> receivedIdSet; 
	public List<Order> returnedOrderList;
	public override List<Order> selectById(Set<Id> idSet) { 
		this.receivedIdSet = idSet;
    	return this.returnedOrderList; 
    }    
}