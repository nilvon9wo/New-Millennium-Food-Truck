@isTest
public class OrderItemTestDataFactory {
    public static List<OrderItem> createList(Integer quantity, List<Pricebookentry> pricebookEntryList, List<Order> orderList){
    	Integer possiblePricebookEntryValues = pricebookEntryList.size();
    	Integer possibleOrderValues = orderList.size();

    	List<OrderItem> orderItemList = new List<OrderItem>();
    	for (Integer i = 0; i < quantity; i++) {
    		orderItemList.add(new OrderItem(
    			OrderId = orderList[Math.mod(i, possibleOrderValues)].id,
    			PriceBookEntryId = pricebookEntryList[Math.mod(i, possiblePricebookEntryValues)].id,
    			Quantity = Constants.DEFAULT_ROWS,
    			UnitPrice = 1
    		));
    	}
    	
        return orderItemList;
    }
}