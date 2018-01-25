public class OrderSelector {
    public List<Order> selectById(Set<Id> idSet) {
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
            WHERE Id IN :idSet 
        ];
    }
}