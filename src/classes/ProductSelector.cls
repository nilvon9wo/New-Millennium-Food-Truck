public virtual class ProductSelector {
	SetHelper setHelper;
	
	public ProductSelector(SetHelper setHelper) {
		this.setHelper = setHelper;
	}
	
	public ProductSelector() {
		this(new SetHelper());
	}
	
	public virtual List<Product2> selectFor(List<PricebookEntry> pricebookEntryList) {
		Set<Id> productIdSet = this.setHelper.buildIdSetFor(pricebookEntryList, PricebookEntry.Product2Id);
		return [
			SELECT Id, Family, Name, Quantity_Remaining__c
			FROM Product2
			WHERE Id IN :productIdSet
		];
	}
	 
	public virtual List<AggregateResult> aggregateRemainingProduct() {
		return [
			SELECT Family family, SUM(Quantity_Remaining__c) total
			FROM Product2
			WHERE Quantity_Remaining__c > 0
			GROUP BY Family 
		];
	}
	
    public virtual Map<Id, Product2> aggregateQuantityOrderedByProduct2(Map<Id, Product2> productMap) {
		List<AggregateResult> aggregateResultList = [
			SELECT Pricebookentry.Product2Id, SUM(Quantity)
            FROM OrderItem
            WHERE Pricebookentry.Product2Id IN :productMap.keySet()
            	AND Order.ActivatedDate != null		
            GROUP BY Pricebookentry.Product2Id
		];    
		
		for (AggregateResult aggregateResult : aggregateResultList) {
			Product2 product = productMap.get((Id) aggregateResult.get('Product2Id'));
			product.Quantity_Ordered__c = (Decimal) aggregateResult.get('expr0');
		}
		
		return productMap;  
	}
}