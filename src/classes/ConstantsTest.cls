@isTest
public class ConstantsTest {
	private static final User TEST_USER = TEST_RunAsUserFactory.create();
	
	@testSetup  
	static void setupTestData (){
	}
		
	@isTest public static void testInventoryAnnouncementsStringShouldReturnTestInventoryAnnouncementsDuringNormalTests() {
		// Arrange
		// Nothing to do here.
		
		// Act
		String result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = Constants.INVENTORY_ANNOUNCEMENTS;
		}
		Test.stopTest();
		
		// Asset
		System.assertEquals('TEST Inventory Announcements', result);
	}
	
	@isTest public static void testProductFamilyShouldReturnAllPicklistValues() {
		// Arrange
		// Nothing to do here.
		
		// Act
		List<Schema.PicklistEntry> resultList;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultList = Constants.PRODUCT_FAMILY_PICKLIST;
		}
		Test.stopTest();
		
		// Asset
		Map<Schema.PicklistEntry, Boolean> isContainedByProductFamilyPicklistValueMap = new Map<Schema.PicklistEntry, Boolean>();

		List<Schema.PicklistEntry> productFamilyPicklistValueList = Product2.Family.getDescribe().getPicklistValues();
		for (Schema.PicklistEntry productFamilyPicklistValue : productFamilyPicklistValueList) {
			isContainedByProductFamilyPicklistValueMap.put(productFamilyPicklistValue, false);
		}
		
		for (Schema.PicklistEntry productFamilyPicklistValue : resultList) {
			isContainedByProductFamilyPicklistValueMap.put(productFamilyPicklistValue, true);
		}
		
		System.assertEquals(productFamilyPicklistValueList.size(), isContainedByProductFamilyPicklistValueMap.size());

		for (Schema.PicklistEntry productFamilyPicklistValue : isContainedByProductFamilyPicklistValueMap.keySet()) {
			System.assert(isContainedByProductFamilyPicklistValueMap.get(productFamilyPicklistValue));
		}
	}
	
	@isTest public static void testStandardPricebookIdShouldReturnExpectedValue() {
		// Arrange
		// Nothing to do here.
		
		// Act
		Id result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = Constants.STANDARD_PRICEBOOK_ID;
		}
		Test.stopTest();
		
		// Asset
		System.assertEquals(PricebookTestDataFactory.STANDARD_PRICEBOOK_ID, result);
	}
	
	@isTest public static void testGetStandardPriceBookIdShouldReturnConstantValueUnderTestConditions(){
		// Arrange
		// Nothing to do here. 
		 
		// Act 
		Id result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = Constants.getStandardPriceBookId();
		}
		Test.stopTest();
		 
		// Asset
		System.assertEquals(PricebookTestDataFactory.STANDARD_PRICEBOOK_ID, result);
	} 
	
	@isTest public static void testSelectStandardPriceBookIdShouldReturnValueFromSelector(){
		// Arrange
		PriceBookSelectorMock mockPriceBookSelector = new PriceBookSelectorMock();
		Pricebook2 testPriceBook = PricebookTestDataFactory.create(TEST_InsertModeEnum.MOCK_INSERT);
		mockPriceBookSelector.returnedPriceBook = testPriceBook;
		 
		Constants constantsUnderTest = new Constants(mockPriceBookSelector);
		constantsUnderTest.TEST_OF_SELECTOR = true; 
		 
		// Act 
		Id result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = constantsUnderTest.selectStandardPriceBookId();
		}
		Test.stopTest();
		
		// Asset
		System.assertEquals(testPriceBook.id, result);
		
		// Clean-up
		constantsUnderTest.TEST_OF_SELECTOR = false; 
	} 
}