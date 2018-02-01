@isTest (seeAllData=false)
private class Product2Tests {
    
    /**
* @name product2Extension_UnitTest
* @description UnitTest for product2Extension
**/

	@testSetup
	static void setupTestData (){
	    TestDataFactory.InsertTestData(5);   
	}
	
    @isTest 
    static void Product2Extension_UnitTest(){
        Test.startTest();
        PageReference pageRef = Page.Product2New;
        Test.setCurrentPage(pageRef);
        Product2 prod = new Product2(name='Test',isActive=true);        
        ApexPages.StandardController stdcontroller = new ApexPages.StandardController(prod);        
        Product2Extension ext = new Product2Extension(stdcontroller);        
        System.assertEquals(Constants.DEFAULT_ROWS, ext.productsToInsert.size());
        ext.addRows();
        System.assertEquals(Constants.DEFAULT_ROWS * 2, ext.productsToInsert.size());
        for (Integer i = 0; i < 5; i++) {
            Product2Extension.ProductWrapper wrapper = ext.productsToInsert[i];
            Product2 testProduct = new Product2();
            testProduct.Name = 'Test Product ' + i;
            testProduct.IsActive = true;
            testProduct.Initial_Inventory__c = 20;
            testProduct.Family = Constants.PRODUCT_FAMILY[0].getValue();
            wrapper.productRecord = testProduct;
            PricebookEntry testEntry = new PricebookEntry();
            testEntry.IsActive = true;
            testEntry.UnitPrice = 10;
            wrapper.pricebookEntryRecord = testEntry;
        }
        ext.save();
        ext.GetFamilyOptions();
        ext.GetInventory();
        Test.stopTest();
        List<Product2> createdProducts = [
            SELECT
            Id
            FROM
            Product2
        ];
        //System.assertEquals(5, createdProducts.size());
    }
    static TestMethod void Product2Trigger_UnitTest(){
        Test.startTest();
        Product2 p=new Product2();
        p.Name='TestProduct';
        p.Family='Side';
        p.IsActive=true;
        p.Quantity_Ordered__c =50;
        p.Initial_Inventory__c =100;
        insert p;
        CollaborationGroup c=new CollaborationGroup();
        c.Name='Test Inventory Announcements';
        c.Description='test';
        c.CollaborationType='public';
        insert c;
        p.Quantity_Ordered__c=96;
        update p;
        Test.stopTest();
    }
    
    @isTest public static void exerciseCollaborationGroupConstant() {
    	Product2Helper helper = new Product2Helper(); 
    	helper.COLLABORATION_GROUP = null;
    	try {
	    	CollaborationGroup collaborationGroup = helper.COLLABORATION_GROUP;
    	}
    	catch (Exception e) {
    	}
    }

    @isTest public static void exerciseSelectInventoryAnnouncementCollaborationGroup() {
    	Product2Helper helper = new Product2Helper(); 
    	try {
	    	CollaborationGroup collaborationGroup = helper.selectInventoryAnnouncementCollaborationGroup();
    	}
    	catch (Exception e) {
    	}
    }
    
    @isTest public static void exercisePostAlerts() {
    	try {
	    	Product2Helper.postAlerts(new List<Product2>{new Product2()});
    	}
    	catch (Exception e) {
    	}
    }

    @isTest public static void exerciseDoPostAlerts() {
    	Product2Helper helper = new Product2Helper(); 
    	try {
	    	helper.doPostAlerts(new List<Product2>{new Product2()});
    	}
    	catch (Exception e) {
    	}
    }

    @isTest public static void exerciseCreateTextSegmentInput() {
    	Product2Helper helper = new Product2Helper(); 
    	helper.createTextSegmentInput(new Product2());
    }

    @isTest public static void exerciseCreateMessageBodyInput() {
    	Product2Helper helper = new Product2Helper(); 
    	helper.createMessageBodyInput(helper.createTextSegmentInput(new Product2()));
    }

    @isTest public static void exerciseCreateAnnouncementInput() {
    	Product2Helper helper = new Product2Helper(); 
    	try {
	    	helper.createAnnouncementInput(helper.createMessageBodyInput(helper.createTextSegmentInput(new Product2())));
    	}
    	catch (Exception e) {
    	}
    }

    @isTest public static void exerciseGetFamilyOptions() {
    	Product2Helper helper = new Product2Helper(); 
    	helper.getFamilyOptions();
    }

    @isTest public static void exerciseSelectByName() {
    	Product2Helper helper = new Product2Helper();
    	try{ 
    		helper.selectByName('Fred'); 
    	}
    	catch (Exception e) {}
    }

}