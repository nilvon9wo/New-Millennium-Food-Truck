@isTest
public class ContactTestDataFactory {
    public static final String PREFIX = Contact.SObjectType.getDescribe().getKeyPrefix();
    public static final Id EXAMPLE_ID = PREFIX + '3E000003NYTS';

	public static final String DEFAULT_NAME_PREFIX = 'Contact ';

    public static Bundle createBundle(
    		List<Contact> templateContactList,  
    		TEST_InsertModeEnum insertMode,
    		TEST_InsertRelationshipsEnum insertOptionalRelationships
    	) {
    	Integer quantity = templateContactList.size();
		Bundle bundle = new Bundle(quantity, insertMode, insertOptionalRelationships);
    		
        bundle.contactList = new List<Contact>();
        Integer i = 0;
        for (Contact templateContact : templateContactList) {
            bundle.contactList.add(new Contact(
            	LastName = (String) TEST_DefaultHelper.valueOrDefault(templateContact.LastName, DEFAULT_NAME_PREFIX + ' ' + i),
            	AccountId = (Id) TEST_DefaultHelper.valueOrDefault(templateContact.AccountId, null) 
            ));
            i++;
        }

		bundle = createRelationships(bundle, insertOptionalRelationships);

        if (insertMode == TEST_InsertModeEnum.INSERT_NOW) {
            insert bundle.contactList;
        } else if (insertMode == TEST_InsertModeEnum.MOCK_INSERT) {
            TEST_MockInsertHelper.addIds(bundle.contactList);  
        }
        
        return bundle;
    }    

    public static Bundle createBundle(
    		Integer quantity,  
    		TEST_InsertModeEnum insertMode,
    		TEST_InsertRelationshipsEnum insertOptionalRelationships
    	) {
    	List<Contact> templateContactList = new List<Contact>();
        for (Integer i = 1; i <= quantity; i++) {
            templateContactList.add(new Contact());
        }
		return createBundle(templateContactList, insertMode, insertOptionalRelationships);
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
		if (insertOptionalRelationships == TEST_InsertRelationshipsEnum.INCLUDE) {
			for (Integer i = 0; i < bundle.contactList.size(); i++) {
				Contact contact = bundle.contactList[i];
				if (contact.accountId == null && bundle.accountList != null && bundle.accountList[i] != null) {
					contact.accountId = bundle.accountList[i].Id;
				}
			}
		}
		return bundle;
	}

    public static List<Contact> createList(
    		Integer quantity,  
    		TEST_InsertModeEnum insertMode
    	) {
    		return createBundle(quantity, insertMode, TEST_InsertRelationshipsEnum.EXCLUDE).contactList;
    }    

    public static List<Contact> createList(Integer quantity){
    	return createList(quantity, TEST_InsertModeEnum.NEVER_INSERT);
    }

    public static List<Contact> createList(Integer quantity, List<Account> accountList, TEST_InsertModeEnum insertMode){
    	Integer possibleAccountValues = accountList.size();
    	
    	List<Contact> templateContactList = new List<Contact>();
    	for (Integer i = 0; i < quantity; i++) {
    		templateContactList.add(new Contact(
    			AccountId = accountList[Math.mod(i, possibleAccountValues)].id
    		));
    	}
    	return createBundle(templateContactList, insertMode, TEST_InsertRelationshipsEnum.EXCLUDE).contactList;
    }

    public static List<Contact> createList(Integer quantity, List<Account> accountList){
    	return createList(quantity, accountList, TEST_InsertModeEnum.NEVER_INSERT);
    }
    
    public static Contact create(TEST_InsertModeEnum insertMode) {
    	Integer quantity = 1;
    	return createList(quantity, insertMode)[0];
    }

    public static Contact create() {
    	return create(TEST_InsertModeEnum.NEVER_INSERT);
    }
    
    public class Bundle {
		public Bundle(
			Integer quantity, 
			TEST_InsertModeEnum insertMode, 
			TEST_InsertRelationshipsEnum insertOptionalRelationships
		) {
			if (insertOptionalRelationships == TEST_InsertRelationshipsEnum.INCLUDE) {
				this.accountList = AccountTestDataFactory.createList(quantity, insertMode);
			}
		}
		
		public List<Account> accountList;
		public List<Contact> contactList;
    }
}