@isTest
public class Product2HelperIntTest {
	private static final User TEST_USER = TEST_RunAsUserFactory.create(); 
	
	private static TEST_InsertModeEnum INSERT_NOW = TEST_InsertModeEnum.INSERT_NOW;
	private static Integer TEST_PRODUCT_QUANTITY = 1;
	private static List<Product2> TEST_NEW_PRODUCT_LIST = ProductTestDataFactory.createList(TEST_PRODUCT_QUANTITY, INSERT_NOW);
	private static List<Product2> TEST_OLD_PRODUCT_LIST = null; // We don't care.
	
	@testSetup
	static void setupTestData (){
		CollaborationGroupTestDataFactory.create(INSERT_NOW);
	}	
	
	@isTest public static void testAfterUpdateShouldPostAnnouncements() {
		// Arrange
		// Nothing to do here.
		
		// Act
		Test.startTest();
		System.runAs(TEST_USER) {
			Product2Helper.afterUpdate(TEST_OLD_PRODUCT_LIST, TEST_NEW_PRODUCT_LIST);
		}
		Test.stopTest();

		// Assert
		// TODO: add meaningful assertions.
		// But, the ID of a queueable Apex job isn’t returned in test context.
		// And the method itself is creating a list of ConnectApi.AnnouncementInput which should be posted,
		// but it doesn't seem to add to the group feed.... 
	}
	
	@isTest public static void testPostAlertsShouldPostAlerts() {
		// Arrange
		// Nothing to do here.
	
		// Act
		Test.startTest();
		System.runAs(TEST_USER) {
			Product2Helper.postAlerts(TEST_NEW_PRODUCT_LIST);
		}
		Test.stopTest();

		// Assert
		// TODO: add meaningful assertions.
		// But, the ID of a queueable Apex job isn’t returned in test context.
		// And the method itself is creating a list of ConnectApi.AnnouncementInput which should be posted,
		// but I can't find any method to tests for ConnectApi.Announcements.postAnnouncement results. 
	}
    
}