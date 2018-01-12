@isTest
public class OrderTestDataFactory {
    public static final String PREFIX = Order.SObjectType.getDescribe().getKeyPrefix();
    public static final Id EXAMPLE_ID = PREFIX + '3E000003NYTS';

	public static final String DEFAULT_NAME_PREFIX = 'Order ';
	public static final Date DEFAULT_EFFECTIVE_DATE = Date.today();
	public static final Id DEFAULT_PRICEBOOK_ID = PricebookTestDataFactory.STANDARD_PRICEBOOK_ID; 
	public static final String DEFAULT_STATUS = 'Draft';  // SFDC does not allow 'Activated' orders to be inserted.

    public static Bundle createBundle(
    		List<Order> templateOrderList,  
    		TEST_InsertModeEnum insertMode,
    		TEST_InsertRelationshipsEnum insertOptionalRelationships
    	) {
    	Integer quantity = templateOrderList.size();
		Bundle bundle = new Bundle(quantity, insertMode, insertOptionalRelationships);
    		
        bundle.orderList = new List<Order>();
        Integer i = 0;
        for (Order templateOrder : templateOrderList) {
            bundle.orderList.add(new Order(
            	Name = (String) TEST_DefaultHelper.valueOrDefault(templateOrder.Name, DEFAULT_NAME_PREFIX + ' ' + i),
            	AccountId = (Id) TEST_DefaultHelper.valueOrDefault(templateOrder.AccountId, null),
            	EffectiveDate = (Date) TEST_DefaultHelper.valueOrDefault(templateOrder.EffectiveDate, DEFAULT_EFFECTIVE_DATE),
            	Pricebook2Id = (Id) TEST_DefaultHelper.valueOrDefault(templateOrder.Pricebook2Id, DEFAULT_PRICEBOOK_ID),
            	Status = (String) TEST_DefaultHelper.valueOrDefault(templateOrder.Status, DEFAULT_STATUS)
            ));
            i++;
        }

		bundle = createRelationships(bundle, insertOptionalRelationships);

        if (insertMode == TEST_InsertModeEnum.INSERT_NOW) {
            insert bundle.orderList;
        } else if (insertMode == TEST_InsertModeEnum.MOCK_INSERT) {
            TEST_MockInsertHelper.addIds(bundle.orderList);  
        }
        
        return bundle;
    }    

    public static Bundle createBundle(
    		Integer quantity,  
    		TEST_InsertModeEnum insertMode,
    		TEST_InsertRelationshipsEnum insertOptionalRelationships
    	) {
    	List<Order> templateOrderList = new List<Order>();
        for (Integer i = 1; i <= quantity; i++) {
            templateOrderList.add(new Order());
        }
		return createBundle(templateOrderList, insertMode, insertOptionalRelationships);
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
		for (Integer i = 0; i < bundle.orderList.size(); i++) {
			Order order = bundle.orderList[i];
			if (order.accountId == null && bundle.accountList != null && bundle.accountList[i] != null) {
				order.accountId = bundle.accountList[i].Id;
			}
			
			if (insertOptionalRelationships == TEST_InsertRelationshipsEnum.INCLUDE) {
				//TODO
			}
		}
		return bundle;
	}

    public static List<Order> createList(
    		Integer quantity,  
    		TEST_InsertModeEnum insertMode
    	) {
    		return createBundle(quantity, insertMode, TEST_InsertRelationshipsEnum.EXCLUDE).orderList;
    }    

    public static List<Order> createList(Integer quantity){
    	return createList(quantity, TEST_InsertModeEnum.NEVER_INSERT);
    }

    public static List<Order> createList(Integer quantity, List<Account> accountList, TEST_InsertModeEnum insertMode){
    	Integer possibleAccountValues = accountList.size();
    	
    	List<Order> templateOrderList = new List<Order>();
    	for (Integer i = 0; i < quantity; i++) { 
    		templateOrderList.add(new Order(
    			AccountId = accountList[Math.mod(i, possibleAccountValues)].id
    		));
    	}
    	return createBundle(templateOrderList, insertMode, TEST_InsertRelationshipsEnum.EXCLUDE).orderList;
    }

    public static List<Order> createList(Integer quantity, List<Account> accountList){
    	return createList(quantity, accountList);
    }
    
    public static Order create(TEST_InsertModeEnum insertMode) {
    	Integer quantity = 1;
    	return createList(quantity, insertMode)[0];
    }

    public static Order create() {
    	return create(TEST_InsertModeEnum.NEVER_INSERT);
    }
    
    public class Bundle {
		public Bundle(
			Integer quantity, 
			TEST_InsertModeEnum insertMode, 
			TEST_InsertRelationshipsEnum insertOptionalRelationships
		) {
			this.accountList = AccountTestDataFactory.createList(quantity, insertMode);

			if (insertOptionalRelationships == TEST_InsertRelationshipsEnum.INCLUDE) {
				// TODO
			}
		}
		
		public List<Account> accountList;
		public List<Order> orderList;
    }
}