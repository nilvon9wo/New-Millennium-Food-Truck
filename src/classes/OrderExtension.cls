/**
 * @name OrderExtension
 * @description This class is provided for you to facilitate the Super Badge
**/
public class OrderExtension {
    DatabaseHelper databaseHelper;
    F45_DML_GenericDml genericDml; 
    OrderSelector orderSelector;
    PricebookEntrySelector pricebookEntrySelector;
    Product2Helper product2Helper;
    ProductSelector productSelector;
    VisualForceHelper visualForceHelper;
 
    public List<OrderItem> orderItemList {get;set;}
    public Order orderRecord {get;set;}
    public List<ChartData> pieData {get;set;} 
    public Map<Id,OrderItem> orderItemByProductIdMap;
    public Decimal total {get;set;}
    public String selectedFamily {get;set;}
 
    private static final Boolean SAVE_SUCCESS = true; 
    private static final Boolean SAVE_FAILURE = false; 

	@testVisible
    private enum DmlOperation { FOR_UPSERT, FOR_DELETE }

	public OrderExtension(
    		ApexPages.StandardController standardController,
    		DatabaseHelper databaseHelper, 
    		F45_DML_GenericDml genericDml,
    		OrderSelector orderSelector, 
    		PricebookEntrySelector pricebookEntrySelector,
    		Product2Helper product2Helper,
    		ProductSelector productSelector,
    		VisualForceHelper visualForceHelper
    	){
    	this.databaseHelper = databaseHelper;
    	this.genericDml = genericDml;
    	this.orderSelector = orderSelector;
    	this.pricebookEntrySelector = pricebookEntrySelector;
    	this.product2Helper = product2Helper;
    	this.productSelector = productSelector;
    	this.standardController = standardController;
    	this.visualForceHelper = visualForceHelper;
    	
    	if (standardController != null) {
	    	this.orderItemByProductIdMap = new Map<Id,OrderItem>();
	    	this.setOrderRecord();
	        this.refreshPieChart(this.orderRecord.OrderItems);
	
	        this.populateOrderItemList(); 
    	}
    }
     
    public OrderExtension(ApexPages.StandardController standardController){
    	this(
    		standardController, 
    		new DatabaseHelper(), 
    		new F45_DML_GenericDml(), 
    		new OrderSelector(),
    		new PricebookEntrySelector(), 
    		new Product2Helper(), 
    		new ProductSelector(),
    		new VisualForceHelper()
    	);
    }

	@testVisible
    private OrderExtension(){
    	this(null);
    }

	// Standard Controller -------------------------------------------------------------------------------------------------------

	@testVisible private ApexPages.StandardController standardController;
    
	// Standard Set Controller -------------------------------------------------------------------------------------------------------

	@testVisible
    ApexPages.StandardSetController standardSetController {
    	get{
    		if (this.standardSetController == null) {
    			// We need to inline this SOQL because of an SFDC limitation.  :-(
	       		this.standardSetController = new ApexPages.StandardSetController([
						SELECT Name, Product2Id, Product2.Family, Product2.Name, Product2.Quantity_Remaining__c, UnitPrice
                     	FROM PricebookEntry
                     	WHERE IsActive = TRUE
        				ORDER BY Name	       		
	       		]);
	          	this.standardSetController.setPageSize(Constants.DEFAULT_ROWS);
    		}
		    return this.standardSetController;
    	}
    	private set;
    }
    
	@testVisible
    private void resetStandardSetController() {
        this.standardSetController = new ApexPages.StandardSetController(this.pricebookEntrySelector.getQueryLocatorForFamily(this.selectedFamily));
        this.standardSetController.setPageSize(Constants.DEFAULT_ROWS);
    }

    public void first(){
    	this.preserveValues();
        this.standardSetController.first();
        this.populateOrderItemList();
    }

    public void previous(){
    	this.preserveValues();
        this.standardSetController.previous();
        this.populateOrderItemList();
    }

    public Boolean getHasPrevious(){
        return this.standardSetController.getHasPrevious();
    }

    public void next(){
    	this.preserveValues();
        this.standardSetController.next();
        this.populateOrderItemList();
    }

    public Boolean getHasNext(){
        return this.standardSetController.getHasNext();
    }

    public void last(){
    	this.preserveValues();
        this.standardSetController.last();
        this.populateOrderItemList();
    }

    public Integer getPageNumber(){
        return this.standardSetController.getPageNumber();
    }

    public Integer getTotalPages(){
        return (Integer) Math.ceil(this.standardSetController.getResultSize() / this.standardSetController.getPageSize());
    }

	// Order Record --------------------------------------------------------------------------------------------

   	@testVisible
    private Order setOrderRecord() { 
		if (this.standardController != null) {
	        this.orderRecord = (Order) this.standardController.getRecord(); 
	        if ( this.orderRecord.Id != null ){
	            this.orderRecord = this.selectOrderRecord(orderRecord.Id);
	        }
        }
        return this.orderRecord;    		
    }

    public static Order queryOrderRecord(Id orderId){
    	return (new OrderExtension()).selectOrderRecord(orderId);
    }

	@testVisible
    private Order selectOrderRecord(Id orderId){ 
    	return this.orderSelector.selectById(new Set<Id>{orderId})[0];
    }

	@testVisible
	private Boolean saveOrderRecord() {
        if (this.orderRecord.Pricebook2Id == null) {
            this.orderRecord.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
        }
        
        try {
        	this.genericDml.doUpsert(new List<Order>{this.orderRecord});
        }
        catch (DmlException e) {
            return SAVE_FAILURE;
        }
       	return SAVE_SUCCESS;
	} 

	// Order Items --------------------------------------------------------------------------------------------

	@testVisible
    private void populateOrderItemList() {
        this.orderItemList = new List<OrderItem>();
        List<PricebookEntry> pricebookEntryList = this.pricebookEntrySelector.getStandardSetFrom(this.standardSetController); 
        Map<Id, Product2> productByIdMap = new Map<Id, Product2>(this.productSelector.selectFor(pricebookEntryList));
        for (PricebookEntry pricebookEntry : pricebookEntryList) {
        	Id productId = pricebookEntry.Product2Id;
        	if (productId != null) {
	            OrderItem orderItem = this.orderItemByProductIdMap.containsKey(productId)
	            		? orderItemByProductIdMap.get(productId).clone()	// So we can write product2Id
	            		: new OrderItem(
		                    PricebookEntry = pricebookEntry,
		                    PricebookEntryId = pricebookEntry.Id,
		                    Product2Id = productId, 
		                    Quantity = 0,
		                    UnitPrice = pricebookEntry.UnitPrice
		                );
		        orderItem.Product2 = productByIdMap.get(productId);
		        orderItem.Product2Id = this.getOrderItemProductId(orderItem);
	            this.orderItemList.add(orderItem);
        	}
        }
    }

	@testVisible
    private void preserveValues() {
    	for (OrderItem orderItem : this.orderItemList) {
    		Id productId = this.getOrderItemProductId(orderItem);
    		if (productId != null) {
	    		this.orderItemByProductIdMap.put(productId, orderItem);
    		}
    	}
    }
	
    public void save(){
        System.Savepoint savepoint = this.databaseHelper.setSavepoint();
        
        if (
        	!this.saveOrderRecord()
    		|| !this.saveOrderItems()
    	) {
       		this.onDmlFailure(savepoint);
        }
    }
	
	@testVisible
	private Boolean saveOrderItems() {
    	Map<DmlOperation, List<OrderItem>> orderItemListByDmlOperationMap = this.buildOrderItemListByDmlOperationMap();
    	
    	return (
    		this.upsertOrderItems(orderItemListByDmlOperationMap.get(DmlOperation.FOR_UPSERT))
    		&& this.deleteOrderItems(orderItemListByDmlOperationMap.get(DmlOperation.FOR_DELETE))
    	);
	}
	
	@testVisible
	private Map<DmlOperation, List<OrderItem>> buildOrderItemListByDmlOperationMap() {
			List<OrderItem> orderItemToUpsertList = new List<OrderItem>();
            List<OrderItem> orderItemToDeleteList = new List<OrderItem>();
            for (OrderItem orderItem : this.orderItemByProductIdMap.values()) {
                if (orderItem.Quantity > 0) {
                    if (orderItem.OrderId == null) {
                        orderItem.OrderId = this.orderRecord.Id; // This probably shouldn't happen...
                    }
                    orderItemToUpsertList.add(orderItem);
                } else if (orderItem.Id != null) {
                    orderItemToDeleteList.add(orderItem);
                }
            }	
            
            return new Map<DmlOperation, List<OrderItem>> {
            	DmlOperation.FOR_UPSERT => orderItemToUpsertList,
            	DmlOperation.FOR_DELETE => orderItemToDeleteList
            };
	}
	
	@testVisible
	private Boolean upsertOrderItems(List<OrderItem> orderItemList) {
        try {
	    	this.genericDml.doUpsert(orderItemList);
	    }
	    catch (DmlException e) {
            return SAVE_FAILURE;
        }
       	return SAVE_SUCCESS;
	}

	@testVisible
	private Boolean deleteOrderItems(List<OrderItem> orderItemList) {
        try {
	    	this.genericDml.doDelete(orderItemList);
	    }
	    catch (DmlException e) {
            return SAVE_FAILURE;
        }
       	return SAVE_SUCCESS;
	}
	
	@testVisible
	private void onDmlFailure(System.Savepoint savepoint) {
		this.databaseHelper.rollback(savepoint);
        this.visualForceHelper.addInfoMessage(Constants.ERROR_MESSAGE);
	}
	
	// Product -----------------------------------------------------------------------------------------------------------------------

    public void selectFamily(){
        this.resetStandardSetController();
        this.populateOrderItemList();
    }

    public List<SelectOption> getFamilyOptions(){
    	return this.product2Helper.getFamilyOptions();
    }

    public void onFieldChange(){
        for (OrderItem orderItem : this.orderItemList) {
            this.orderItemByProductIdMap.put(this.getOrderItemProductId(orderItem), orderItem);
        }
        this.refreshPieChart(this.orderItemList);
    }

	@testVisible
    private List<ChartData> refreshPieChart(List<OrderItem> orderItemList) {
        this.pieData = null;
        this.total = 0;
        
        for (OrderItem orderItem : orderItemList) {
        	this.addToPieChart(orderItem);
        }
        return this.pieData;
    } 
    
	@testVisible
    private List<ChartData> addToPieChart(OrderItem orderItem){
        this.orderItemByProductIdMap.put(this.getOrderItemProductId(orderItem), orderItem);
        if (orderItem.Quantity > 0) {
            if (null == this.pieData) {
                this.pieData = new List<ChartData>();
            }
            this.pieData.add(new ChartData(orderItem.PricebookEntry.Product2.Name, orderItem.Quantity * orderItem.UnitPrice));
            this.total += orderItem.UnitPrice * orderItem.Quantity;
        }
        return this.pieData; 
    }

	@testVisible
    private Id getOrderItemProductId (OrderItem orderItem) {
    	Id productId;
    	try {
    		productId = orderItem.Product2Id;
    	}
    	catch (SObjectException ex) {
    		// Because SFDC has internal inconsistencies with regard to the relationship between Pricebooks and Products.
    	}
    	
		return (productId != null)
			? productId
			: (orderItem.Pricebookentry != null) ? orderItem.Pricebookentry.Product2Id : null;    	
    }
}