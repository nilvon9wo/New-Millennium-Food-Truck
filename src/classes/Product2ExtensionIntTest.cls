@isTest
public class Product2ExtensionIntTest {
	private static final User TEST_USER = TEST_RunAsUserFactory.create(); 
	
	private static final ApexPages.StandardController TEST_STANDARD_CONTROLLER = new ApexPages.StandardController(new Product2()); 
	private static final Product2Extension EXTENSION_UNDER_TEST = new Product2Extension(TEST_STANDARD_CONTROLLER);
	
	@isTest public static void testGetInventoryShouldReturnRemainingProducts() {/* TODO */}
	@isTest public static void testGetFamilyOptionsShouldConvertProductFamilyToPicklist() {/* TODO */}
	@isTest public static void testSaveShouldSaveProductsAndResetForm() {/* TODO */}
	@isTest public static void testSaveShouldRollbackDatabaseAndDisplayMessageOnFailure() {/* TODO */}    
}