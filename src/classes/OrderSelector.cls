public class OrderSelector {
    public List<Order> selectByOrderId(Set<Id> orderIdSet) {
    	return [
            SELECT Id, AccountId, EffectiveDate, Name, Status, Pricebook2Id,
                (
                    SELECT Id, OrderId, Quantity, PricebookEntryId, 
                    	PricebookEntry.Product2Id, PricebookEntry.Product2.Name, PricebookEntry.Product2.Family, 
                    	PricebookEntry.Product2.Quantity_Remaining__c, 
                    	UnitPrice
                        
                    FROM OrderItems
                )
            FROM Order
            WHERE Id IN :orderIdSet 
        ];
    }
}