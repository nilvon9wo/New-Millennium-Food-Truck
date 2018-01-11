@isTest
public class CollaborationGroupTestDataFactory { 
    public static final String PREFIX = CollaborationGroup.SObjectType.getDescribe().getKeyPrefix();
    public static final Id EXAMPLE_ID = PREFIX + '3E000003NYTS';
    
    public static final String DEFAULT_NAME_PREFIX = 'Collaboration Group ';
    public static final String DEFAULT_COLLABORATION_TYPE = 'Public';
    public static final Boolean DEFAULT_CAN_HAVE_GUESTS = false;
    public static final Boolean DEFAULT_IS_ARCHIVED = false;
    public static final Boolean DEFAULT_IS_AUTO_ARCHIVE_DISABLED = false;
    
    public static List<CollaborationGroup> createList(
    		List<CollaborationGroup> templateCollaborationGroupList,  
    		TEST_InsertModeEnum insertMode
    	) {
    	Integer quantity = templateCollaborationGroupList.size();

        List<CollaborationGroup> collaborationGroupList = new List<CollaborationGroup>();
        Integer i = 0;
        for (CollaborationGroup templateCollaborationGroup : templateCollaborationGroupList) {
            collaborationGroupList.add(new CollaborationGroup(
            	Name = (String) TEST_DefaultHelper.valueOrDefault(templateCollaborationGroup.Name, DEFAULT_NAME_PREFIX + ' ' + i), 
	    		CanHaveGuests = (Boolean) TEST_DefaultHelper.valueOrDefault(templateCollaborationGroup.CanHaveGuests, DEFAULT_CAN_HAVE_GUESTS),
    			CollaborationType = (String) TEST_DefaultHelper.valueOrDefault(templateCollaborationGroup.CollaborationType, DEFAULT_COLLABORATION_TYPE),
    			IsArchived = (Boolean) TEST_DefaultHelper.valueOrDefault(templateCollaborationGroup.IsArchived, DEFAULT_IS_ARCHIVED),
    			IsAutoArchiveDisabled = (Boolean) TEST_DefaultHelper.valueOrDefault(templateCollaborationGroup.IsAutoArchiveDisabled, DEFAULT_IS_AUTO_ARCHIVE_DISABLED)
            ));
            i++; 
        }

        if (insertMode == TEST_InsertModeEnum.INSERT_NOW) {
            insert collaborationGroupList;
        } else if (insertMode == TEST_InsertModeEnum.MOCK_INSERT) {
            TEST_MockInsertHelper.addIds(collaborationGroupList);  
        }
        
        return collaborationGroupList;
    } 
    
    public static List<CollaborationGroup> createList(
    		Integer quantity,  
    		TEST_InsertModeEnum insertMode
    	) {
    	List<CollaborationGroup> templateCollaborationGroup = new List<CollaborationGroup>();
        for (Integer i = 1; i <= quantity; i++) {
            templateCollaborationGroup.add(new CollaborationGroup());
        }
		return createList(templateCollaborationGroup, insertMode);
    }        
    
    public static List<CollaborationGroup> createList(Integer quantity){ 
    	return createList(quantity, TEST_InsertModeEnum.NEVER_INSERT);
    }

    public static CollaborationGroup create(TEST_InsertModeEnum insertMode) {
    	CollaborationGroup templateCollaborationGroup = new CollaborationGroup(
    		Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS
    	);
    	return createList(new List<CollaborationGroup>{templateCollaborationGroup}, insertMode)[0];
    } 

    public static CollaborationGroup create(){  
    	return create(TEST_InsertModeEnum.NEVER_INSERT);
    } 
}