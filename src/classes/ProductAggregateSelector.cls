public class ProductAggregateSelector {
    public List<AggregateResult> aggregateQuantityOrderedByProduct2(Set<Id> productIdSet) {
		return [
			SELECT Pricebookentry.Product2Id, SUM(Quantity)
            FROM OrderItem
            WHERE Pricebookentry.Product2Id IN :productIdSet
            	AND Order.ActivatedDate != null		
            GROUP BY Pricebookentry.Product2Id
		];      
	}
	
	public List<AggregateResult> aggregateRemainingProduct() {
		return [
			SELECT Family family, SUM(Quantity_Remaining__c) total
			FROM Product2
			WHERE Quantity_Remaining__c > 0
			GROUP BY Family
		];
	}
}