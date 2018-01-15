public virtual class OrderItemSelector {
    public virtual List<OrderItem> selectByOrderId(Set<Id> orderIdSet) {
    	return [
			SELECT Id, Pricebookentry.Product2Id, Pricebookentry.Product2.Id
            FROM OrderItem
            WHERE OrderId IN :orderIdSet
            	AND Order.ActivatedDate != null		
		];    	
    }
}