@isTest
public class AccountTestDataFactory {
    public static final String PREFIX = Account.SObjectType.getDescribe().getKeyPrefix();
    public static final Id EXAMPLE_ID = PREFIX + '3E000003NYTS';

	public static final String DEFAULT_NAME_PREFIX = 'Mozart MegaCorp';

    public static List<Account> createList(
    		Integer quantity,  
    		TEST_InsertModeEnum insertMode
    	) {
        List<Account> accountList = new List<Account>();
        for (Integer i = 1; i <= quantity; i++) {
            accountList.add(new Account(
            	Name = DEFAULT_NAME_PREFIX + ' ' + i
            ));
        }

        if (insertMode == TEST_InsertModeEnum.INSERT_NOW) {
            insert accountList;
        } else if (insertMode == TEST_InsertModeEnum.MOCK_INSERT) {
            TEST_MockInsertHelper.addIds(accountList);  
        }
        
        return accountList;
    }    
    
    public static List<Account> createList(Integer quantity){
    	return createList(quantity, TEST_InsertModeEnum.NEVER_INSERT);
    }

    public static Account create(TEST_InsertModeEnum insertMode) {
    	Integer quantity = 1;
    	return createList(quantity, insertMode)[0];
    }

    public static Account create() {
    	return create(TEST_InsertModeEnum.NEVER_INSERT);
    }
}