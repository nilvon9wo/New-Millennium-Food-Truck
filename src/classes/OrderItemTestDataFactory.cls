@isTest
public class OrderItemTestDataFactory {
    public static final String PREFIX = OrderItem.SObjectType.getDescribe().getKeyPrefix();
    public static final Id EXAMPLE_ID = PREFIX + '3E000003NYTS';

	public static final Integer DEFAULT_QUANTITY = Constants.DEFAULT_ROWS;
	public static final Decimal DEFAULT_UNIT_PRICE = 123.45;
	

    public static Bundle createBundle(
    		List<OrderItem> templateOrderItemList,   
    		TEST_InsertModeEnum insertMode,
    		TEST_InsertRelationshipsEnum insertOptionalRelationships
    	) {
    	Integer quantity = templateOrderItemList.size();
		Bundle bundle = new Bundle(quantity, insertMode, insertOptionalRelationships);
    		
        bundle.orderItemList = new List<OrderItem>();
        Integer i = 0;
        for (OrderItem templateOrderItem : templateOrderItemList) {
            bundle.orderItemList.add(new OrderItem(
            	OrderId = (Id) TEST_DefaultHelper.valueOrDefault(templateOrderItem.OrderId, null),
            	PriceBookEntry = (PriceBookEntry) TEST_DefaultHelper.valueOrDefault(templateOrderItem.PriceBookEntry, null),
            	PriceBookEntryId = (Id) TEST_DefaultHelper.valueOrDefault(templateOrderItem.PriceBookEntryId, null),
            	Quantity = (Decimal) TEST_DefaultHelper.valueOrDefault(templateOrderItem.Quantity, DEFAULT_QUANTITY),
            	UnitPrice = (Decimal) TEST_DefaultHelper.valueOrDefault(templateOrderItem.UnitPrice, DEFAULT_UNIT_PRICE)
            ));
            i++; 
        }

		bundle = createRelationships(bundle, insertOptionalRelationships);

        if (insertMode == TEST_InsertModeEnum.INSERT_NOW) {
            insert bundle.orderItemList;
        } else if (insertMode == TEST_InsertModeEnum.MOCK_INSERT) {
            TEST_MockInsertHelper.addIds(bundle.orderItemList);  
        }
        
        return bundle;
    }    

    public static Bundle createBundle(
    		Integer quantity,  
    		TEST_InsertModeEnum insertMode,
    		TEST_InsertRelationshipsEnum insertOptionalRelationships
    	) {
    	List<OrderItem> templateOrderItemList = new List<OrderItem>();
        for (Integer i = 1; i <= quantity; i++) {
            templateOrderItemList.add(new OrderItem());
        }
		return createBundle(templateOrderItemList, insertMode, insertOptionalRelationships);
    }    

    public static Bundle createBundle(Integer quantity, TEST_InsertModeEnum insertMode) {
    	return createBundle(quantity, insertMode, TEST_InsertRelationshipsEnum.INCLUDE);
    }

    public static Bundle createBundle(Integer quantity) {
    	return createBundle(quantity, TEST_InsertModeEnum.MOCK_INSERT, TEST_InsertRelationshipsEnum.INCLUDE);
    }

    public static Bundle createBundle() {
    	Integer quantity = 1;
    	return createBundle(quantity, TEST_InsertModeEnum.MOCK_INSERT, TEST_InsertRelationshipsEnum.INCLUDE);
    }

	private static Bundle createRelationships(Bundle bundle, TEST_InsertRelationshipsEnum insertOptionalRelationships) {
		for (Integer i = 0; i < bundle.orderItemList.size(); i++) {
			OrderItem orderItem = bundle.orderItemList[i];
			if (orderItem.OrderId == null && bundle.orderList != null && bundle.orderList[i] != null) {
				orderItem.OrderId = bundle.orderList[i].Id;
			}
			if (orderItem.PriceBookEntry == null && bundle.pricebookEntryList != null && bundle.pricebookEntryList[i] != null) {
				orderItem.PriceBookEntry = bundle.pricebookEntryList[i];
			}
			if (orderItem.PriceBookEntryId == null && bundle.pricebookEntryList != null && bundle.pricebookEntryList[i] != null) {
				orderItem.PriceBookEntryId = bundle.pricebookEntryList[i].Id;
			}

			if (insertOptionalRelationships == TEST_InsertRelationshipsEnum.INCLUDE) {
				// TODO	
			}
		}
		return bundle;
	}

    public static List<OrderItem> createList(
    		Integer quantity,  
    		TEST_InsertModeEnum insertMode
    	) {
    		return createBundle(quantity, insertMode, TEST_InsertRelationshipsEnum.EXCLUDE).orderItemList;
    }    

    public static List<OrderItem> createList(Integer quantity){
    	return createList(quantity, TEST_InsertModeEnum.NEVER_INSERT);
    }

    public static List<OrderItem> createList(Integer quantity, List<Pricebookentry> pricebookEntryList, List<Order> orderList, TEST_InsertModeEnum insertMode){
    	Integer possiblePricebookEntryValues = pricebookEntryList.size();
    	Integer possibleOrderValues = orderList.size();

    	List<OrderItem> templateOrderItemList = new List<OrderItem>();
    	for (Integer i = 0; i < quantity; i++) {
    		templateOrderItemList.add(new OrderItem(
    			OrderId = orderList[Math.mod(i, possibleOrderValues)].id,
    			PriceBookEntry = pricebookEntryList[Math.mod(i, possiblePricebookEntryValues)],
    			PriceBookEntryId = pricebookEntryList[Math.mod(i, possiblePricebookEntryValues)].id
    		));
    	}
    	
        return createBundle(templateOrderItemList, insertMode, TEST_InsertRelationshipsEnum.EXCLUDE).orderItemList;
    }

    public static List<OrderItem> createList(Integer quantity, List<Pricebookentry> pricebookEntryList, List<Order> orderList){
    	return createList(quantity, pricebookEntryList, orderList, TEST_InsertModeEnum.NEVER_INSERT);
    }
    
    
    public static OrderItem create(TEST_InsertModeEnum insertMode) {
    	Integer quantity = 1;
    	return createList(quantity, insertMode)[0];
    }

    public static OrderItem create() {
    	return create(TEST_InsertModeEnum.NEVER_INSERT);
    }
    
    public class Bundle {
		public Bundle(
			Integer quantity, 
			TEST_InsertModeEnum insertMode, 
			TEST_InsertRelationshipsEnum insertOptionalRelationships
		) {
			TEST_InsertModeEnum relationInsertMode = (insertMode != TEST_InsertModeEnum.MOCK_INSERT && insertMode != TEST_InsertModeEnum.NEVER_INSERT)
				? TEST_InsertModeEnum.INSERT_NOW
				: insertMode;
			
			this.orderList = OrderTestDataFactory.createList(quantity, relationInsertMode);
			this.pricebookEntryList = PricebookEntryTestDataFactory.createList(quantity, relationInsertMode);
			
			if (insertOptionalRelationships == TEST_InsertRelationshipsEnum.INCLUDE) {
				// TODO	
			}
		} 
		
		public List<OrderItem> orderItemList;
		public List<Order> orderList;
		public List<Pricebookentry> pricebookEntryList;
    }
}