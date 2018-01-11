@isTest
public class OrderItemAggregateSelectorMock extends OrderItemAggregateSelector {
	public Set<Id> receivedProductIdSet;
	public List<AggregateResult> returnedAggregateResultList;
    public override List<AggregateResult> aggregateQuantityOrderedByProduct2(Set<Id> productIdSet) {
    	this.receivedProductIdSet = productIdSet;
		return this.returnedAggregateResultList;      
	}
}