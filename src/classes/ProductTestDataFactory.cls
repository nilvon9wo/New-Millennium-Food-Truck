@isTest
public class ProductTestDataFactory {
    public static final String PREFIX = Product2.SObjectType.getDescribe().getKeyPrefix();
    public static final Id EXAMPLE_ID = PREFIX + '3E000003NYTS';

	public static final String DEFAULT_NAME_PREFIX = 'Product2 ';
	public static final Integer DEFAULT_INITIAL_INVENTORY = 10;
	public static final Boolean DEFAULT_IS_ACTIVE = true;

    public static List<Product2> createList(
    		Integer quantity,  
    		TEST_InsertModeEnum insertMode
    	) {
    	List<Schema.PickListEntry> familyValueList = Product2.Family.getDescribe().getPickListValues();
    	Integer possibleFamilyValues = familyValueList.size();

        List<Product2> productList = new List<Product2>();
        for (Integer i = 1; i <= quantity; i++) {
            productList.add(new Product2(
            	Name = DEFAULT_NAME_PREFIX + ' ' + i,
    			Family = familyValueList[Math.mod(i, possibleFamilyValues)].getValue(),
    			Initial_Inventory__c = DEFAULT_INITIAL_INVENTORY,
    			IsActive = DEFAULT_IS_ACTIVE
            ));
        }

        if (insertMode == TEST_InsertModeEnum.INSERT_NOW) {
            insert productList;
        } else if (insertMode == TEST_InsertModeEnum.MOCK_INSERT) {
            TEST_MockInsertHelper.addIds(productList);  
        }
        
        return productList;
    }    

    public static List<Product2> createList(Integer quantity){
    	return createList(quantity, TEST_InsertModeEnum.NEVER_INSERT);
    }

    public static Product2 create(TEST_InsertModeEnum insertMode) {
    	Integer quantity = 1;
    	return createList(quantity, insertMode)[0];
    }

    public static Product2 create() {
    	return create(TEST_InsertModeEnum.NEVER_INSERT);
    }
}