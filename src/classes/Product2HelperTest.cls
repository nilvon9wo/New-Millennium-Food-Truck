@isTest
public class Product2HelperTest {
	private static final User TEST_USER = TEST_RunAsUserFactory.create(); 

	private static final CollaborationGroupSelectorMock MOCK_COLLABORATION_GROUP_SELECTOR = new CollaborationGroupSelectorMock();
	private static final InventorySettingSelectorMock MOCK_INVENTORY_SELECTOR = new InventorySettingSelectorMock(); 
	private static final Product2Helper HELPER_UNDER_TEST = new Product2Helper(MOCK_COLLABORATION_GROUP_SELECTOR, MOCK_INVENTORY_SELECTOR);
	
	private static final TEST_InsertModeEnum MOCK_INSERT = TEST_InsertModeEnum.MOCK_INSERT;
	private static final Integer TEST_PRODUCT_QUANTITY = 1;
	private static final List<Product2> TEST_NEW_PRODUCT_LIST = ProductTestDataFactory.createList(TEST_PRODUCT_QUANTITY, MOCK_INSERT);
	private static final List<Product2> TEST_OLD_PRODUCT_LIST = null; // We don't care.
	private static final Product2 TEST_PRODUCT = TEST_NEW_PRODUCT_LIST[0];
	
	private static final CollaborationGroup TEST_COLLABORATION_GROUP = CollaborationGroupTestDataFactory.create(MOCK_INSERT);
	private static final List<Inventory_Setting__mdt> TEST_INVENTORY_SETTING_LIST = InventorySettingTestDataFactory.createList(TEST_NEW_PRODUCT_LIST);

	private static Integer LOW_QUALITY_ALERT_THRESHOLD = InventorySettingTestDataFactory.DEFAULT_LOW_QUANTITY_ALERT;
	
	@isTest public static void testSelectInventoryAnnouncementCollaborationGroupShouldReturnCollaborationGroup() {/* TODO */}
    
	@isTest public static void testOnAfterUpdateShouldPostAnnouncements() {
		// Arrange
		MOCK_COLLABORATION_GROUP_SELECTOR.returnedCollaborationGroup = TEST_COLLABORATION_GROUP; 
		MOCK_INVENTORY_SELECTOR.returnedInventorySettingList = TEST_INVENTORY_SETTING_LIST;

		// Act
		Test.startTest();
		System.runAs(TEST_USER) {
			HELPER_UNDER_TEST.onAfterUpdate(TEST_OLD_PRODUCT_LIST, TEST_NEW_PRODUCT_LIST);
		}
		Test.stopTest();

		// Assert
		// TODO: add meaningful assertions.
		// But, the ID of a queueable Apex job isn’t returned in test context.
		// And the method itself is creating a list of ConnectApi.AnnouncementInput which should be posted,
		// but it doesn't seem to add to the group feed.... 
	}
	
	@isTest public static void testCreateProductAnnouncementListShouldReturnProductWhenQuantityIsLessThanThreshold() {
		testCreateProductAnnouncementList(LOW_QUALITY_ALERT_THRESHOLD - 1);
	}
	
	@isTest public static void testCreateProductAnnouncementListShouldNotReturnProductWhenQuantityIsAtThreshold() {
		testCreateProductAnnouncementList(LOW_QUALITY_ALERT_THRESHOLD);
	}
	
	@isTest public static void testCreateProductAnnouncementListShouldNotReturnProductWhenQuantityIsAboveThreshold() {
		testCreateProductAnnouncementList(LOW_QUALITY_ALERT_THRESHOLD + 1);
	}
	
	private static void testCreateProductAnnouncementList(Integer productQuantity) {
		// Arrange
		MOCK_COLLABORATION_GROUP_SELECTOR.returnedCollaborationGroup = TEST_COLLABORATION_GROUP;
		MOCK_INVENTORY_SELECTOR.returnedInventorySettingList = TEST_INVENTORY_SETTING_LIST;
		Product2 testProduct = createProductWithQuantity(productQuantity);
		List<Product2> testProductList = new List<Product2>{testProduct};

		// Act
		List<Product2> resultList; 
		Test.startTest();
		System.runAs(TEST_USER) {
			resultList = HELPER_UNDER_TEST.createProductAnnouncementList(testProductList);
		}
		Test.stopTest();

		// Assert
		Integer expectedListSize = productQuantity < LOW_QUALITY_ALERT_THRESHOLD ? 1 : 0;
		System.assertEquals(expectedListSize, resultList.size());
		
		if (expectedListSize > 1) {
			System.assertEquals(testProduct, resultList[0]);  
		}  
	}

	private static Product2 createProductWithQuantity(Integer quantity) { 
		Map<String, Object> mappedProduct = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(TEST_PRODUCT));	
		mappedProduct.put('Quantity_Remaining__c', String.valueOf(quantity));
		return (Product2) JSON.deserialize(JSON.serialize(mappedProduct), Product2.class);
	}

	@isTest public static void testDoPostAlertsShouldPostAlerts() {
		// Arrange
		MOCK_COLLABORATION_GROUP_SELECTOR.returnedCollaborationGroup = TEST_COLLABORATION_GROUP; 

		// Act
		Test.startTest();
		System.runAs(TEST_USER) {
			HELPER_UNDER_TEST.doPostAlerts(TEST_NEW_PRODUCT_LIST);
		}
		Test.stopTest();

		// Assert
		// TODO: add meaningful assertions.
		// But, the ID of a queueable Apex job isn’t returned in test context.
		// And the method itself is creating a list of ConnectApi.AnnouncementInput which should be posted,
		// but it doesn't seem to add to the group feed.... 
	}
	
	@isTest public static void testCreateTextSegmentInputShouldCreateTextSegmentInput()  {
		// Arrange
		// Nothing to do here.

		// Act
		ConnectApi.TextSegmentInput result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = HELPER_UNDER_TEST.createTextSegmentInput(TEST_PRODUCT);
		}
		Test.stopTest();

		// Assert
		System.assertEquals(TEST_PRODUCT.Name + Constants.INVENTORY_LEVEL_LOW, result.text);
	}
	
	@isTest public static void testCreateMessageBodyInputShouldCreateMessageBodyInput() {
		// Arrange
		ConnectApi.TextSegmentInput testTextSegmentInput = new ConnectApi.TextSegmentInput();

		// Act
		ConnectApi.MessageBodyInput result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = HELPER_UNDER_TEST.createMessageBodyInput(testTextSegmentInput);
		}
		Test.stopTest();

		// Assert
		List<ConnectApi.MessageSegmentInput> resultMessageSegmenetInputList = result.messageSegments;
		System.assertEquals(1, resultMessageSegmenetInputList.size());
		System.assertEquals(testTextSegmentInput, resultMessageSegmenetInputList[0]);
	}
	
	@isTest public static void testCreateAnnouncementInputShouldCreateAnnouncementInput() {
		// Arrange
		MOCK_COLLABORATION_GROUP_SELECTOR.returnedCollaborationGroup = TEST_COLLABORATION_GROUP; 
		ConnectApi.MessageBodyInput testMessageBodyInput = new ConnectApi.MessageBodyInput();

		// Act
		ConnectApi.AnnouncementInput result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = HELPER_UNDER_TEST.createAnnouncementInput(testMessageBodyInput);
		}
		Test.stopTest();

		// Assert
		System.assertEquals(Date.today().addDays(1), result.expirationDate);
		System.assert(result.sendEmails);
		System.assertEquals(TEST_COLLABORATION_GROUP.Id, result.parentId);
		System.assertEquals(testMessageBodyInput, result.body);
	}

	@isTest public static void testGetFamilyOptionsShouldReturnProductFamilyPicklistAsSelectOptions() {
		// Arrange
		// Nothing to do here

		// Act 
		List<SelectOption> resultSelectOptionList;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultSelectOptionList = HELPER_UNDER_TEST.getFamilyOptions();
		}
		Test.stopTest();
		
		// Assert
		ProductFamilyTestHelper.assertSelectOptionList(resultSelectOptionList);
	}
 
}