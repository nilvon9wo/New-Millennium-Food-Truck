@isTest
public class PricebookTestDataFactory {
    public static final String PREFIX = Pricebook2.SObjectType.getDescribe().getKeyPrefix();
    public static final Id EXAMPLE_ID = PREFIX + '3E000003NYTS';

	public static final Id STANDARD_PRICEBOOK_ID = Test.getStandardPricebookId();
			
	public static final String DEFAULT_NAME_PREFIX = 'Pricebook2 ';

    public static List<Pricebook2> createList( 
    		Integer quantity,  
    		TEST_InsertModeEnum insertMode
    	) {
        List<Pricebook2> pricebookList = new List<Pricebook2>();
        for (Integer i = 1; i <= quantity; i++) {
            pricebookList.add(new Pricebook2(
            	Name = DEFAULT_NAME_PREFIX + ' ' + i
            ));
        }

        if (insertMode == TEST_InsertModeEnum.INSERT_NOW) {
            insert pricebookList;
        } else if (insertMode == TEST_InsertModeEnum.MOCK_INSERT) {
            TEST_MockInsertHelper.addIds(pricebookList);  
        }
        
        return pricebookList;
    }    
    
    public static List<Pricebook2> createList(Integer quantity){
    	return createList(quantity, TEST_InsertModeEnum.NEVER_INSERT);
    }

    public static Pricebook2 create(TEST_InsertModeEnum insertMode) {
    	Integer quantity = 1;
    	return createList(quantity, insertMode)[0];
    }

    public static Pricebook2 create() {
    	return create(TEST_InsertModeEnum.NEVER_INSERT);
    }
}