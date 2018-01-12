@isTest
public class Product2ExtensionTest {
	private static final User TEST_USER = TEST_RunAsUserFactory.create(); 
	
	private static final ApexPages.StandardController TEST_STANDARD_CONTROLLER = new ApexPages.StandardController(new Product2()); 
	private static final ChartHelper MOCK_CHART_HELPER = new ChartHelperMock(); 
    private static final DatabaseHelper MOCK_DATABASE_HELPER = new DatabaseHelperMock(); 
    private static final F45_DML_GenericDml MOCK_GENERIC_DML = new F45_DML_GenericDmlMock();
    private static final VisualForceHelper MOCK_VISUAL_FORCE_HELPER = new VisualForceHelperMock();
	private static final Product2Extension EXTENSION_UNDER_TEST = new Product2Extension(
		TEST_STANDARD_CONTROLLER,
		MOCK_CHART_HELPER,
		MOCK_DATABASE_HELPER,
		MOCK_GENERIC_DML, 
		MOCK_VISUAL_FORCE_HELPER
	);
	
	@isTest public static void testAddRowsShouldAddProductWrappersToProductList() {/* TODO */}
	@isTest public static void testGetInventoryShouldReturnRemainingProducts() {/* TODO */}
	@isTest public static void testGetFamilyOptionsShouldConvertProductFamilyToPicklist() {/* TODO */}
	@isTest public static void testSaveShouldSaveProductsAndResetForm() {/* TODO */}
	@isTest public static void testSaveShouldRollbackDatabaseAndDisplayMessageOnFailure() {/* TODO */}
	@isTest public static void testBuildProductByPriceBookEntryMapShouldCreateMap() {/* TODO */}
	@isTest public static void testBuildProductByPriceBookEntryMapShouldNotMapProductsWithInsufficientData() {/* TODO */}
	@isTest public static void testSaveProductListShouldInsertProductListAndAddMessage() {/* TODO */}
	@isTest public static void testSaveProductListShouldReturnErrorMessageOnFailure() {/* TODO */}
	@isTest public static void testSavePriceBookEntryListShouldInsertPricebookEntryListFromMap() {/* TODO */}
	@isTest public static void testSavePriceBookEntryListShouldReturnErrorMessageOnFailure() {/* TODO */}
	@isTest public static void testResetFormShouldClearOldProductListAndNewRows() {/* TODO */}	
}