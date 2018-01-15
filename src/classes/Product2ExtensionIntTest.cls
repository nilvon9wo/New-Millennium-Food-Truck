@isTest
public class Product2ExtensionIntTest { 
	private static final User TEST_USER = TEST_RunAsUserFactory.create(); 
	
	private static final ApexPages.StandardController TEST_STANDARD_CONTROLLER = new ApexPages.StandardController(new Product2()); 
	private static final Product2Extension EXTENSION_UNDER_TEST = new Product2Extension(TEST_STANDARD_CONTROLLER);
	
	private static final TEST_InsertModeEnum INSERT_LATER = TEST_InsertModeEnum.INSERT_LATER;
	private static final Product2 TEST_PRODUCT = ProductTestDataFactory.create(INSERT_LATER);
	private static final PriceBookEntry TEST_PRICEBOOK_ENTRY = PricebookEntryTestDataFactory.create(INSERT_LATER);
	
	@isTest public static void testSaveShouldSaveProductsAndResetForm()  {
		// Arrange
		EXTENSION_UNDER_TEST.productsToInsert = createTestProductWrapperList();

		// Act
		Test.startTest();
		System.runAs(TEST_USER) {
			EXTENSION_UNDER_TEST.save();
		}
		Test.stopTest();
		
		// Assert
		List<Product2> resultProductList = [
			SELECT Id
			FROM Product2
			WHERE Name = :TEST_PRODUCT.Name
		];
		System.assertEquals(1, resultProductList.size());

		List<PriceBookEntry> resultPriceBookEntryList = [
			SELECT Id, PriceBook2Id, UnitPrice, IsActive
			FROM PriceBookEntry
			WHERE Product2Id = :resultProductList[0].Id
		];
		System.assertEquals(1, resultPriceBookEntryList.size());
		PriceBookEntry resultPriceBookEntry = resultPriceBookEntryList[0];
		System.assertEquals(Constants.STANDARD_PRICEBOOK_ID, resultPriceBookEntry.PriceBook2Id);
		System.assertEquals(PricebookEntryTestDataFactory.DEFAULT_UNIT_PRICE, resultPricebookEntry.UnitPrice);
		System.assert(resultPriceBookEntry.IsActive);
	}
	
	private static List<ProductWrapper> createTestProductWrapperList() {
		ProductWrapper productWrapper = new ProductWrapper();
		productWrapper.productRecord = TEST_PRODUCT;
		productWrapper.priceBookEntryRecord = TEST_PRICEBOOK_ENTRY;
		return new List<productWrapper>{productWrapper};
	}
}