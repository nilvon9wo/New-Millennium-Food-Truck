@isTest
public class PricebookEntryTestDataFactory {
    public static final String PREFIX = PricebookEntry.SObjectType.getDescribe().getKeyPrefix();
    public static final Id EXAMPLE_ID = PREFIX + '3E000003NYTS';

	public static final Id DEFAULT_PRICEBOOK_ID = PricebookTestDataFactory.STANDARD_PRICEBOOK_ID; 
	public static final Boolean DEFAULT_IS_ACTIVE = true;
	public static final Decimal DEFAULT_UNIT_PRICE = 123.45;

    public static Bundle createBundle(
    		List<PricebookEntry> templatePricebookEntryList,  
    		TEST_InsertModeEnum insertMode,
    		TEST_InsertRelationshipsEnum insertOptionalRelationships
    	) {
    	Integer quantity = templatePricebookEntryList.size();
		Bundle bundle = new Bundle(quantity, insertMode, insertOptionalRelationships);
    		
        bundle.pricebookEntryList = new List<PricebookEntry>();
        Integer i = 0;
        for (PricebookEntry templatePricebookEntry : templatePricebookEntryList) {
            bundle.pricebookEntryList.add(new PricebookEntry(
            	Pricebook2Id = (Id) TEST_DefaultHelper.valueOrDefault(templatePricebookEntry.Pricebook2Id, DEFAULT_PRICEBOOK_ID),
            	Product2Id = (Id) TEST_DefaultHelper.valueOrDefault(templatePricebookEntry.Product2Id, null),
            	IsActive = (Boolean) TEST_DefaultHelper.valueOrDefault(templatePricebookEntry.IsActive, DEFAULT_IS_ACTIVE),
            	UnitPrice = (Decimal) TEST_DefaultHelper.valueOrDefault(templatePricebookEntry.UnitPrice, DEFAULT_UNIT_PRICE)
            ));
            i++;
        }
 
		bundle = createRelationships(bundle, insertOptionalRelationships);

        if (insertMode == TEST_InsertModeEnum.INSERT_NOW) {
            insert bundle.pricebookEntryList;
        } else if (insertMode == TEST_InsertModeEnum.MOCK_INSERT) {
            TEST_MockInsertHelper.addIds(bundle.pricebookEntryList);  
        }
        
        return bundle;
    }    

    public static Bundle createBundle(
    		Integer quantity,  
    		TEST_InsertModeEnum insertMode,
    		TEST_InsertRelationshipsEnum insertOptionalRelationships
    	) {
    	List<PricebookEntry> templatePricebookEntryList = new List<PricebookEntry>();
        for (Integer i = 1; i <= quantity; i++) {
            templatePricebookEntryList.add(new PricebookEntry());
        }
		return createBundle(templatePricebookEntryList, insertMode, insertOptionalRelationships);
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
		for (Integer i = 0; i < bundle.pricebookEntryList.size(); i++) {
			PricebookEntry pricebookEntry = bundle.pricebookEntryList[i];
			if (pricebookEntry.product2Id == null && bundle.productList != null && bundle.productList[i] != null) {
				pricebookEntry.product2Id = bundle.productList[i].Id;
			} 

			if (insertOptionalRelationships == TEST_InsertRelationshipsEnum.INCLUDE) {
				//TODO
			}
		}
		return bundle;
	}

    public static List<PricebookEntry> createList(
    		Integer quantity,  
    		TEST_InsertModeEnum insertMode
    	) {
    		return createBundle(quantity, insertMode, TEST_InsertRelationshipsEnum.EXCLUDE).pricebookEntryList;
    }    

    public static List<PricebookEntry> createList(Integer quantity){
    	return createList(quantity, TEST_InsertModeEnum.NEVER_INSERT);
    }

    public static List<PricebookEntry> createList(Integer quantity, List<Product2> productList, TEST_InsertModeEnum insertMode){
    	Integer possibleProduct2Values = productList.size();
    	
    	List<PricebookEntry> templatePricebookEntryList = new List<PricebookEntry>();
    	for (Integer i = 0; i < quantity; i++) {
    		templatePricebookEntryList.add(new PricebookEntry(
    			Product2Id = productList[Math.mod(i, possibleProduct2Values)].id
    		));
    	}
    	return createBundle(templatePricebookEntryList, insertMode, TEST_InsertRelationshipsEnum.EXCLUDE).pricebookEntryList;
    }

    public static List<PricebookEntry> createList(Integer quantity, List<Product2> productList){
    	return createList(quantity, productList, TEST_InsertModeEnum.NEVER_INSERT);
    }

    public static List<PricebookEntry> createList(List<Product2> productList, TEST_InsertModeEnum insertMode){
    	List<PricebookEntry> templatePricebookEntryList = new List<PricebookEntry>();
    	for (Product2 product: productList) { 
    		templatePricebookEntryList.add(new PricebookEntry(
    			Product2Id = product.id
    		));
    	} 
    	return createBundle(templatePricebookEntryList, insertMode, TEST_InsertRelationshipsEnum.EXCLUDE).pricebookEntryList;
    }
    
    public static List<PricebookEntry> createList(List<Product2> productList){
    	return createList(productList, TEST_InsertModeEnum.NEVER_INSERT);
    }

    public static PricebookEntry create(TEST_InsertModeEnum insertMode) {
    	Integer quantity = 1;
    	return createList(quantity, insertMode)[0];
    }

    public static PricebookEntry create() {
    	return create(TEST_InsertModeEnum.NEVER_INSERT);
    }
    
    public class Bundle {
		public Bundle(
			Integer quantity,  
			TEST_InsertModeEnum insertMode, 
			TEST_InsertRelationshipsEnum insertOptionalRelationships
		) {
			this.productList = ProductTestDataFactory.createList(quantity, insertMode);
			
			if (insertOptionalRelationships == TEST_InsertRelationshipsEnum.INCLUDE) {
				// TODO	 
			}
		}
		
		public List<Product2> productList;
		public List<PricebookEntry> pricebookEntryList;
    }
}