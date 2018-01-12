public class ProductSelector {
	public List<AggregateResult> aggregateRemainingProduct() {
		return [
			SELECT Family family, SUM(Quantity_Remaining__c) total
			FROM Product2
			WHERE Quantity_Remaining__c > 0
			GROUP BY Family
		];
	}
}