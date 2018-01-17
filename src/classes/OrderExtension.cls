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
    public List<chartHelper.chartData> pieData {get;set;}
    public Map<Id,OrderItem> orderItemMap;
    public Decimal total {get;set;}
    public String selectedFamily {get;set;}

	ApexPages.StandardController standardController;
    ApexPages.StandardSetController standardSetController {
    	get{
    		if (this.standardSetController == null) {
	       		this.standardSetController = new ApexPages.StandardSetController(this.pricebookEntrySelector.getQueryLocator()); 
	          	this.standardSetController.setPageSize(Constants.DEFAULT_ROWS);
    		}
		    return this.standardSetController;
    	}
    	private set;
    }
    
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
    	
    	this.orderItemMap = new Map<Id,OrderItem>();
    	this.setOrderRecord();
        this.refreshPieChart(this.orderRecord.OrderItems);

        this.populateOrderItemList(); 
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

    public OrderExtension(){
    	this(null);
    }
    
    private Order setOrderRecord() { 
		if (this.standardController != null) {
	        this.orderRecord = (Order) this.standardController.getRecord(); 
	        if ( this.orderRecord.Id != null ){
	            this.orderRecord = this.selectOrderRecord(orderRecord.Id);
	        }
        }
        return this.orderRecord;    		
    }

    private Order selectOrderRecord(Id orderId){
    	return this.orderSelector.selectByOrderId(new Set<Id>{orderId})[0];
    }

    private List<ChartHelper.ChartData> refreshPieChart(List<OrderItem> orderItemList) {
        this.pieData = null;
        this.total = 0;
        
        for (OrderItem orderItem : this.orderRecord.OrderItems) {
        	this.addToPieChart(orderItem);
        }
        return this.pieData;
    }
    
    private List<ChartHelper.ChartData> addToPieChart(OrderItem orderItem){
        this.orderItemMap.put(this.getOrderItemProductId(orderItem), orderItem);
        if (orderItem.Quantity > 0) {
            if (null == this.pieData) {
                this.pieData = new List<ChartHelper.ChartData>();
            }
            this.pieData.add(new ChartHelper.ChartData(orderItem.PricebookEntry.Product2.Name, orderItem.Quantity * orderItem.UnitPrice));
            this.total += orderItem.UnitPrice * orderItem.Quantity;
        }
        return this.pieData;
    }

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

    private void populateOrderItemList() {
        this.orderItemList = new List<OrderItem>();
        List<PricebookEntry> pricebookEntryList = (List<PricebookEntry>) this.standardSetController.getRecords();
        Map<Id, Product2> productByIdMap = new Map<Id, Product2>(this.productSelector.selectFor(pricebookEntryList));
        for (PricebookEntry pricebookEntry : pricebookEntryList) {
        	Id productId = pricebookEntry.Product2Id;
        	if (productId != null) {
	            OrderItem orderItem = this.orderItemMap.containsKey(productId)
	            		? orderItemMap.get(productId).clone()
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

    public void onFieldChange(){
        for (OrderItem orderItem : this.orderItemList) {
            this.orderItemMap.put(this.getOrderItemProductId(orderItem), orderItem);
        }
        this.refreshPieChart(this.orderItemList);
    }

    public void selectFamily(){
        this.resetStandardSetController();
        this.populateOrderItemList();
    }

    private void resetStandardSetController() {
        this.standardSetController = new ApexPages.StandardSetController(this.pricebookEntrySelector.getQueryLocatorForFamily(this.selectedFamily));
        this.standardSetController.setPageSize(Constants.DEFAULT_ROWS);
    }

    public void save(){
        System.Savepoint sp = Database.setSavepoint();
        try {
            if (this.orderRecord.Pricebook2Id == null) {
                this.orderRecord.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            }
            this.genericDml.doUpsert(new List<Order>{orderRecord});

            List<OrderItem> orderItemToUpsertList = new List<OrderItem>();
            List<OrderItem> orderItemToDeleteList = new List<OrderItem>();
            for (OrderItem orderItem : this.orderItemMap.values()) {
                if (orderItem.Quantity > 0) {
                    if (orderItem.OrderId == null) {
                        orderItem.OrderId = this.orderRecord.Id;
                    }
                    orderItemToUpsertList.add(orderItem);
                } else if (orderItem.Id != null) {
                    orderItemToDeleteList.add(orderItem);
                }
            }
            this.genericDml.doUpsert(orderItemToUpsertList);
            this.genericDml.doDelete(orderItemToDeleteList);
        } catch (Exception e) {
            Database.rollback(sp);
            this.visualForceHelper.addInfoMessage(Constants.ERROR_MESSAGE);
        }
    }

    public void first(){
    	this.preserveValues();
        this.standardSetController.first();
        this.populateOrderItemList();
    }

    public void next(){
    	this.preserveValues();
        this.standardSetController.next();
        this.populateOrderItemList();
    }

    public void previous(){
    	this.preserveValues();
        this.standardSetController.previous();
        this.populateOrderItemList();
    }

    public void last(){
    	this.preserveValues();
        this.standardSetController.last();
        this.populateOrderItemList();
    }

    private void preserveValues() {
    	for (OrderItem orderItem : this.orderItemList) {
    		Id productId = this.getOrderItemProductId(orderItem);
    		if (productId != null) {
	    		this.orderItemMap.put(productId, orderItem);
    		}
    	}
    }

    public Boolean getHasPrevious(){
        return this.standardSetController.getHasPrevious();
    }

    public Boolean getHasNext(){
        return this.standardSetController.getHasNext();
    }

    public Integer getTotalPages(){
        return (Integer) Math.ceil(this.standardSetController.getResultSize() / (Decimal)Constants.DEFAULT_ROWS);
    }

    public Integer getPageNumber(){
        return this.standardSetController.getPageNumber();
    }

    public List<SelectOption> getFamilyOptions(){
    	// return this.product2Helper.getFamilyOptions();
    	List<SelectOption> optionList = new List<SelectOption>();
    	String SELECT_ONE = Constants.SELECT_ONE;
    	optionList.add(new SelectOption(SELECT_ONE, SELECT_ONE));
    	for (Schema.PicklistEntry picklistEntry : Constants.PRODUCT_FAMILY) {
    		optionList.add(new SelectOption(picklistEntry.getLabel(), picklistEntry.getValue()));
    	}
    	return optionList;
    }

    public static Order queryOrderRecord(Id orderId){
    	return (new OrderExtension()).selectOrderRecord(orderId);
    }
}