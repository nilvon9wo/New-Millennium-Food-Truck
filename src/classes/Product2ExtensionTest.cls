@isTest
public class Product2ExtensionTest {
	private static final User TEST_USER = TEST_RunAsUserFactory.create(); 
	
	private static final ApexPages.StandardController TEST_STANDARD_CONTROLLER = new ApexPages.StandardController(new Product2()); 
	private static final ChartHelper MOCK_CHART_HELPER = new ChartHelperMock(); 
    private static final DatabaseHelper MOCK_DATABASE_HELPER = new DatabaseHelperMock(); 
    private static final F45_DML_GenericDmlMock MOCK_GENERIC_DML = new F45_DML_GenericDmlMock();
    private static final VisualForceHelperMock MOCK_VISUAL_FORCE_HELPER = new VisualForceHelperMock();
	private static final Product2Extension EXTENSION_UNDER_TEST = new Product2Extension(
		TEST_STANDARD_CONTROLLER,
		MOCK_CHART_HELPER,
		MOCK_DATABASE_HELPER,
		MOCK_GENERIC_DML, 
		MOCK_VISUAL_FORCE_HELPER
	);

	private static final Product2 TEST_PRODUCT = ProductTestDataFactory.create(TEST_InsertModeEnum.MOCK_INSERT);
	private static final List<Product2> TEST_PRODUCT_LIST = new List<Product2>{TEST_PRODUCT};

	private static final PriceBookEntry TEST_PRICEBOOK_ENTRY = PricebookEntryTestDataFactory.create(TEST_InsertModeEnum.MOCK_INSERT);

	private static final String DUMMY_ERROR_MESSAGE = 'Save Failed';

	
	@isTest public static void testGetInventoryShouldReturnRemainingProducts() {/* TODO */}
	@isTest public static void testGetFamilyOptionsShouldConvertProductFamilyToPicklist() {/* TODO */}
	@isTest public static void testSaveShouldSaveProductsAndResetForm() {/* TODO */}
	@isTest public static void testSaveShouldRollbackDatabaseAndDisplayMessageOnFailure() {/* TODO */}
	@isTest public static void testBuildProductByPriceBookEntryMapShouldCreateMap() {/* TODO */}
	
	@isTest public static void testBuildProductByPriceBookEntryMapShouldNotMapProductsWithoutAName() {
		// Arrange
		ProductWrapper productWrapper = createTestProductWrapper();
		productWrapper.productRecord.Name = null;
	
		testBuildProductByPriceBookEntryMapShouldFail();	
	}
	
	@isTest public static void testBuildProductByPriceBookEntryMapShouldNotMapProductsWithoutAFamily() {
		// Arrange
		ProductWrapper productWrapper = createTestProductWrapper();
		productWrapper.productRecord.Family = null;
	
		testBuildProductByPriceBookEntryMapShouldFail();	
	}
	
	@isTest public static void testBuildProductByPriceBookEntryMapShouldNotMapProductsWithoutASelectedFamily() {
		// Arrange
		ProductWrapper productWrapper = createTestProductWrapper();
		productWrapper.productRecord.Family = Constants.SELECT_ONE;
	
		testBuildProductByPriceBookEntryMapShouldFail();	
	}
	
	@isTest public static void testBuildProductByPriceBookEntryMapShouldNotMapProductsWithoutAnInventoryValue() {
		// Arrange
		ProductWrapper productWrapper = createTestProductWrapper();
		productWrapper.productRecord.Initial_Inventory__c = null;
	
		testBuildProductByPriceBookEntryMapShouldFail();	
	}
	
	@isTest public static void testBuildProductByPriceBookEntryMapShouldNotMapProductsWithoutAPositiveInventoryValue() {
		// Arrange
		ProductWrapper productWrapper = createTestProductWrapper();
		productWrapper.productRecord.Initial_Inventory__c = 0;
	
		testBuildProductByPriceBookEntryMapShouldFail();	
	}
	
	@isTest public static void testBuildProductByPriceBookEntryMapShouldNotMapProductsWithoutActivation() {
		// Arrange
		ProductWrapper productWrapper = createTestProductWrapper();
		productWrapper.priceBookEntryRecord.IsActive = false;
	
		testBuildProductByPriceBookEntryMapShouldFail();	
	}
	
	@isTest public static void testBuildProductByPriceBookEntryMapShouldNotMapProductsWithoutAUnitPrice() {
		// Arrange
		ProductWrapper productWrapper = createTestProductWrapper();
		productWrapper.priceBookEntryRecord.UnitPrice = null;
	
		testBuildProductByPriceBookEntryMapShouldFail();	
	}

	private static ProductWrapper createTestProductWrapper() {
		ProductWrapper productWrapper = new ProductWrapper();
		productWrapper.productRecord = TEST_PRODUCT.clone();
		productWrapper.priceBookEntryRecord = TEST_PRICEBOOK_ENTRY.clone();
		return productWrapper;
	}

	@isTest public static void testBuildProductByPriceBookEntryMapShouldNotCreateMapWhenThereAreNoProductsToInsert() {
		// Arrange
		// Nothing to do here
	
		testBuildProductByPriceBookEntryMapShouldFail();	
	}
	
	private static void testBuildProductByPriceBookEntryMapShouldFail() {
		// Act
		Map<PriceBookEntry, Product2> resultMap;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultMap = EXTENSION_UNDER_TEST.buildProductByPriceBookEntryMap();
		}
		Test.stopTest();
		
		// Assert
		System.assert(resultMap.isEmpty());
	}
	
	@isTest public static void testSaveProductListShouldInsertProductListAndAddMessage() {
		// Arrange
		MOCK_GENERIC_DML.returnedErrorMessage = null;
		
		// Act
		String result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = EXTENSION_UNDER_TEST.saveProductList(TEST_PRODUCT_LIST);
		}
		Test.stopTest();
		
		// Assert
		System.assertEquals(1, MOCK_GENERIC_DML.insertedSObjectListList.size());
		System.assertEquals(TEST_PRODUCT_LIST, MOCK_GENERIC_DML.insertedSObjectListList[0]);
		String expectedMessage = TEST_PRODUCT_LIST.size() + ' Inserted';
		System.assertEquals(expectedMessage, MOCK_VISUAL_FORCE_HELPER.receivedMessage);
		System.assertEquals(null, result);
	}

	@isTest public static void testSaveProductListShouldReturnErrorMessageOnFailure() {
		// Arrange
		MOCK_GENERIC_DML.returnedErrorMessage = DUMMY_ERROR_MESSAGE;
		
		// Act
		String result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = EXTENSION_UNDER_TEST.saveProductList(TEST_PRODUCT_LIST);
		}
		Test.stopTest();
		
		// Assert
		System.assertEquals(1, MOCK_GENERIC_DML.insertedSObjectListList.size());
		System.assertEquals(TEST_PRODUCT_LIST, MOCK_GENERIC_DML.insertedSObjectListList[0]);
		System.assertEquals(null, MOCK_VISUAL_FORCE_HELPER.receivedMessage);
		System.assertEquals(DUMMY_ERROR_MESSAGE, result);
	}
	

	@isTest public static void testSavePriceBookEntryListShouldInsertPricebookEntryListFromMap() {
		// Arrange
		Map<PriceBookEntry, Product2> testProductByPriceBookEntryMap = new Map<PriceBookEntry, Product2>{TEST_PRICEBOOK_ENTRY => TEST_PRODUCT};
		
		// Act 
		String result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = EXTENSION_UNDER_TEST.savePriceBookEntryList(testProductByPriceBookEntryMap);
		}
		Test.stopTest();
		
		// Assert
		// TODO
		List<SObject> resultSObjectList = MOCK_GENERIC_DML.insertedSObjectListList[0];
		System.assertEquals(1, resultSObjectList.size());
		
		PricebookEntry resultPricebookEntry = (PricebookEntry) resultSObjectList[0];
		System.assertEquals(Constants.STANDARD_PRICEBOOK_ID, resultPricebookEntry.PriceBook2Id);
		System.assertEquals(TEST_PRODUCT.id, resultPricebookEntry.Product2Id);
		System.assertEquals(PricebookEntryTestDataFactory.DEFAULT_UNIT_PRICE, resultPricebookEntry.UnitPrice);
		System.assert(resultPricebookEntry.IsActive);
		
		System.assertEquals(null, result);
	}
	
	@isTest public static void testSavePriceBookEntryListShouldReturnErrorMessageOnFailure() {
		// Arrange
		Map<PriceBookEntry, Product2> testProductByPriceBookEntryMap = new Map<PriceBookEntry, Product2>();
		MOCK_GENERIC_DML.returnedErrorMessage = DUMMY_ERROR_MESSAGE;
		
		// Act
		String result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = EXTENSION_UNDER_TEST.savePriceBookEntryList(testProductByPriceBookEntryMap);
		}
		Test.stopTest();
		
		// Assert
		System.assertEquals(0, MOCK_GENERIC_DML.insertedSObjectListList.size());
		System.assertEquals(DUMMY_ERROR_MESSAGE, result);
	}
	
	@isTest public static void testResetFormShouldClearOldProductListAndNewRows() {
		// Arrange
		EXTENSION_UNDER_TEST.productsToInsert = new List<ProductWrapper>{new ProductWrapper()};
		
		// Act
		Test.startTest();
		System.runAs(TEST_USER) {
			EXTENSION_UNDER_TEST.resetForm();
		}
		Test.stopTest();
		
		// Assert
		System.assertEquals(Constants.DEFAULT_ROWS, EXTENSION_UNDER_TEST.productsToInsert.size());
	}
		
	@isTest public static void testAddRowsShouldAddProductWrappersToProductList() {
		// Arrange
		EXTENSION_UNDER_TEST.productsToInsert = new List<ProductWrapper>();
		
		// Act
		Test.startTest();
		System.runAs(TEST_USER) {
			EXTENSION_UNDER_TEST.addRows();
		}
		Test.stopTest();
		
		// Assert
		System.assertEquals(Constants.DEFAULT_ROWS, EXTENSION_UNDER_TEST.productsToInsert.size());
	}
}