@isTest
public class OrderTestDataFactory {
    public static List<Order> createList(Integer quantity, List<Account> accountList){
    	Integer possibleAccountValues = accountList.size();
    	
    	List<Order> ords = new List<Order>();
    	for (Integer i = 0; i < quantity; i++) {
    		ords.add(new Order(
    			Name = 'Order ' + (i + 1),
    			AccountId = accountList[Math.mod(i, possibleAccountValues)].id,
    			EffectiveDate = Date.today(),
    			Pricebook2Id = PricebookTestDataFactory.STANDARD_PRICEBOOK_ID,
    			Status = 'Draft'
    		));
    	}
    	return ords;
    }
}