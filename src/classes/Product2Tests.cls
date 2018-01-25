@isTest
public class Product2Tests {
	private static final User TEST_USER = TEST_RunAsUserFactory.create(); 
	private static final Integer DEFAULT_ROWS = Constants.DEFAULT_ROWS;
	
	private static final TEST_InsertModeEnum INSERT_NOW = TEST_InsertModeEnum.INSERT_NOW;
	private static final TEST_InsertModeEnum INSERT_LATER = TEST_InsertModeEnum.INSERT_LATER;
	private static final List<Product2> TEST_PRODUCT_LIST = ProductTestDataFactory.createList(DEFAULT_ROWS, INSERT_LATER); 
	private static final List<PricebookEntry> TEST_PRICEBOOK_ENTRY_LIST = PricebookEntryTestDataFactory.createList(DEFAULT_ROWS, INSERT_LATER); 

	@testSetup
	static void setupTestData (){
    	CollaborationGroupTestDataFactory.create(INSERT_NOW);
	}	
		
	@isTest 
	public static void Product2Extension_UnitTest(){
		// Arrange
        Product2Extension extensionUnderTest = createProduct2Extension();
        
        // Act and Assert -- This is BAD        
        testAddRows(extensionUnderTest);

		Integer rowsToPopulate = DEFAULT_ROWS;  
        for (Integer i = 0; i < rowsToPopulate; i++) {
            ProductWrapper wrapper = extensionUnderTest.productsToInsert[i];
            Product2 product = TEST_PRODUCT_LIST[i];
            wrapper.productRecord = product;
            
            wrapper.pricebookEntryRecord = TEST_PRICEBOOK_ENTRY_LIST[i];
            wrapper.pricebookEntryRecord.Product2Id = product.Id; 
        }
        
        Test.startTest();
        System.runAs(TEST_USER) {
        	extensionUnderTest.save();
        }
        Test.stopTest();
        
        exerciseGets(extensionUnderTest); // This is terrible
        List<Product2> createdProducts = [
            SELECT Id
            FROM Product2
        ];
        System.assertEquals(5, createdProducts.size());
    } 
    
    private static Product2Extension createProduct2Extension() {
        Test.setCurrentPage(Page.Product2New);

        Product2 product = new Product2(name='Test', isActive=true);        
        ApexPages.StandardController stdcontroller = new ApexPages.StandardController(product);        
        return new Product2Extension(stdcontroller);        
    }
    
    private static void testAddRows(Product2Extension extensionUnderTest) {
       	System.assertEquals(DEFAULT_ROWS, extensionUnderTest.productsToInsert.size());
        
        extensionUnderTest.addRows();
        System.assertEquals(DEFAULT_ROWS * 2, extensionUnderTest.productsToInsert.size());
    }
    
    private static void exerciseGets(Product2Extension extensionUnderTest) {
        extensionUnderTest.GetFamilyOptions();
        extensionUnderTest.GetInventory();
    }
}