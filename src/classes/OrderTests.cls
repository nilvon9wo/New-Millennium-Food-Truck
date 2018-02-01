@isTest (seeAllData=false)
public class OrderTests {
  public static Boolean isExceptionTest = false;	
	
  @TestSetup
    static void SetupTestData(){
        TestDataFactory.InsertTestData(5);
    }

    static TestMethod void OrderUpdate_UnitTest(){
        
          Order orderRecord = [SELECT Id, Status FROM Order LIMIT 1];
          Product2 originalProduct = [SELECT Id, Quantity_Ordered__c FROM Product2 LIMIT 1];
        
          orderRecord.Status = Constants.ACTIVATED_ORDER_STATUS;
          update orderRecord;
          
          Product2 updatedProduct = [SELECT Id, Quantity_Ordered__c FROM Product2 LIMIT 1];
        Test.startTest();
//      TestDataFactory.VerifyQuantityOrdered(originalProduct,updatedProduct,Constants.DEFAULT_ROWS);
        Test.stopTest();
    }
    static TestMethod void OrderExtension_UnitTest(){
        //TestDataFactory.ConstructProducts(1);
        PageReference pageRef = Page.OrderEdit;
        Test.setCurrentPage(pageRef);
        //SetupTestData();
        Order ord = [SELECT AccountId,Description,Status,EffectiveDate,Name,Pricebook2Id FROM Order LIMIT 1];
        ApexPages.StandardController stdcontroller = new ApexPages.StandardController(ord);       
        OrderExtension ext = new OrderExtension(stdcontroller);       
        System.assertEquals(Constants.DEFAULT_ROWS, ext.orderItemList.size());
        ext.OnFieldChange();
        ext.SelectFamily();
        ext.Save();
        ext.First();
        ext.Next();
        ext.Previous();
        ext.Last();
        ext.GetHasPrevious();
        ext.GetHasNext();
        ext.GetTotalPages();
        ext.GetPageNumber();
        List<SelectOption> options = ext.GetFamilyOptions();

    }
    
    @isTest public static void exerciseGenericExceptionOnTrigger() {
    	isExceptionTest = true;
    	Order testOrder = [SELECT Id FROM Order LIMIT 1];
    	update testOrder;
    	isExceptionTest = false;
    }
}