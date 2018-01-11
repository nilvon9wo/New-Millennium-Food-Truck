public virtual class OrderItemAggregateSelector {
    public virtual List<AggregateResult> aggregateQuantityOrderedByProduct2(Set<Id> productIdSet) {
		return [
			SELECT Pricebookentry.Product2Id, SUM(Quantity)
            FROM OrderItem
            WHERE Pricebookentry.Product2Id IN :productIdSet
            	AND Order.ActivatedDate != null		
            GROUP BY Pricebookentry.Product2Id
		];      
	}
}