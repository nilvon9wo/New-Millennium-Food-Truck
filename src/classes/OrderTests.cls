@isTest
public class OrderTests {

	@testSetup
	static void setupTestData (){
	    TestDataFactory.InsertTestData(5);   
	}
 
    static testmethod void OrderUpdate_UnitTest (){
        Product2 product = selectProduct();

        test.startTest();
        Order order = [
        	SELECT Id, Status 
        	FROM Order 
        	LIMIT 1
        ];
        order.status = Constants.ACTIVATED_ORDER_STATUS;
        update order;
        Test.stopTest();

        Product2 updatedprod = selectProduct();
        
        // FIXME
        TestDataFactory.VerifyQuantityOrdered(product, updatedprod, Constants.DEFAULT_ROWS);
    }
    
    private static Product2 selectProduct() {
    	return [
        	SELECT Id, Name, Family, Quantity_Ordered__c, Quantity_Remaining__c 
        	FROM Product2 
        	LIMIT 1
        ];
    }
}