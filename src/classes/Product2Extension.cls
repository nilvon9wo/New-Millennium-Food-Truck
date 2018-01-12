public class Product2Extension { 
	ApexPages.StandardController controller;
	ChartHelper chartHelper;
    DatabaseHelper databaseHelper;
    F45_DML_GenericDml genericDml;
	VisualForceHelper visualForceHelper;
   
    public Product2Extension(
    		ApexPages.StandardController controller,
    		ChartHelper chartHelper, 
    		DatabaseHelper databaseHelper, 
    		F45_DML_GenericDml genericDml, 
    		VisualForceHelper visualForceHelper
    	) { 
    	this.controller = controller;
    	this.chartHelper = chartHelper;
        this.databaseHelper = databaseHelper;
        this.genericDml = genericDml;
        this.visualForceHelper = visualForceHelper;
        
        this.productsToInsert = new List<ProductWrapper>();
        this.addRows();
    }

    public Product2Extension(ApexPages.StandardController controller){
   		this(controller, new ChartHelper(), new DatabaseHelper(), new F45_DML_GenericDml(), new VisualForceHelper());
    }

    public List<ProductWrapper> productsToInsert {get;set;}

	private static final String SELECT_ONE = Constants.SELECT_ONE;

    public void addRows(){
        for (Integer i = 0; i < Constants.DEFAULT_ROWS; i++){
            productsToInsert.add( new ProductWrapper() );
        }
    }
 
    public List<ChartHelper.ChartData> getInventory(){
        return this.chartHelper.selectRemainingProductList();
    }
    
    public List<SelectOption> getFamilyOptions() {
    	List<SelectOption> optionList = new List<SelectOption>();
    	optionList.add(new SelectOption(SELECT_ONE, SELECT_ONE));
    	for (Schema.PicklistEntry picklistEntry : Constants.PRODUCT_FAMILY) {
    		optionList.add(new SelectOption(picklistEntry.getLabel(), picklistEntry.getValue()));
    	}
    	return optionList;
    }

    public PageReference save() {
    	SavePoint savePoint = this.databaseHelper.setSavePoint();
    	Map<PriceBookEntry, Product2> productByPriceBookEntryMap = this.buildProductByPriceBookEntryMap();
    	
    	String errorMessage = this.saveProductList(productByPriceBookEntryMap.values());
    	if (String.isBlank(errorMessage)) {
    		errorMessage = this.savePriceBookEntryList(productByPriceBookEntryMap);
    	}

    	if (!String.isBlank(errorMessage)) {
    		this.databaseHelper.rollback(savePoint);
    		visualForceHelper.addErrorMessage(Constants.ERROR_MESSAGE + errorMessage);
    	} else {
    		resetForm();
    	}
    	
        return null;
    }
    
    @testVisible
    private Map<PriceBookEntry, Product2> buildProductByPriceBookEntryMap() {
    	Map<PriceBookEntry, Product2> productByPriceBookEntryMap = new Map<PriceBookEntry, Product2>();
    	for (ProductWrapper productWrapper : this.productsToInsert) {
    		if (productWrapper.hasAllDataRequiredToSave()) {
    			productByPriceBookEntryMap.put(productWrapper.pricebookEntryRecord, productWrapper.productRecord);
    		}
    	}
		return productByPriceBookEntryMap;    	
    }
    
    @testVisible
    private String saveProductList(List<Product2> productList) {
    	String errorMessage = this.genericDml.doInsertOrReturnErrorMessage(productList); 
    	if (String.isBlank(errorMessage)) {
	    	visualForceHelper.addInfoMessage(productList.size() + ' Inserted');
    	}
    	return errorMessage;
    }
    
    @testVisible
    private String savePriceBookEntryList(Map<PriceBookEntry, Product2> productByPriceBookEntryMap) {
		List<PriceBookEntry> pricebookEntryList = new List<PriceBookEntry>(); 
    	for (PricebookEntry pricebookEntry: productByPriceBookEntryMap.keySet()) {
    		pricebookEntryList.add(new PricebookEntry(
    			PriceBook2Id = Constants.STANDARD_PRICEBOOK_ID,
    			Product2Id = productByPriceBookEntryMap.get(pricebookEntry).Id,
    			UnitPrice = pricebookEntry.UnitPrice,
    			IsActive = true
    		));
    	}
    	
    	return this.genericDml.doInsertOrReturnErrorMessage(pricebookEntryList);
    }
    
    @testVisible
    private void resetForm() {
    		this.productsToInsert.clear();
	    	this.addRows();
    }
}