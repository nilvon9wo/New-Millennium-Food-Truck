@isTest
public class Product2Trigger_UnitTest {
	private static final User TEST_USER = TEST_RunAsUserFactory.create(); 
	
	private static TEST_InsertModeEnum INSERT_NOW = TEST_InsertModeEnum.INSERT_NOW;
	private static Integer TEST_PRODUCT_QUANTITY = 1;
	private static List<Product2> TEST_NEW_PRODUCT_LIST = ProductTestDataFactory.createList(TEST_PRODUCT_QUANTITY, INSERT_NOW);
	
	@testSetup
	static void setupTestData (){
	    TestDataFactory.insertTestData(5);   
	}	
	
	@isTest public static void testAfterUpdateShouldPostAnnouncements() {
		// Arrange
		// Nothing to do here.
		
		// Act
		Test.startTest();
		System.runAs(TEST_USER) {
			update TEST_NEW_PRODUCT_LIST;
		}
		Test.stopTest();

		// Assert
		// TODO: add meaningful assertions.
		// But, the ID of a queueable Apex job isn’t returned in test context.
		// And the method itself is creating a list of ConnectApi.AnnouncementInput which should be posted,
		// but it doesn't seem to add to the group feed.... 
	}
	
    public static TestMethod void Product2Trigger_UnitTest(){
         Integer productCount = [SELECT Count() FROM Product2];
         Integer pricebookCount = [SELECT Count() FROM PricebookEntry];
         PageReference pageRef = Page.Product2New;
         Test.setCurrentPage(pageRef);
         product2Extension ext = new product2Extension(new apexPages.standardController(new Product2()));
         ext.addRows();
         ext.addRows();
         ext.productsToInsert[0].productRecord.Name = 'TestTestTest';
         ext.productsToInsert[0].productRecord.Family = 'Entree';
         ext.productsToInsert[0].pricebookEntryRecord.UnitPrice = 1;
         ext.productsToInsert[0].pricebookEntryRecord.IsActive = true;
         ext.productsToInsert[0].productRecord.Initial_Inventory__c = 10;
         ext.save();
         
         system.assert( productCount+1 == [SELECT Count() FROM Product2] );
         system.assert( pricebookCount+1 == [SELECT Count() FROM PricebookEntry]);
         
         delete [SELECT Id FROM Product2 WHERE Name = 'TestTestTest'];
    }	
}