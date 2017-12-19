public class Product2Extension { 
	ApexPages.StandardController controller;
    DatabaseHelper databaseHelper;
    GenericDml genericDml;
	VisualForceHelper visualForceHelper;
   
    public Product2Extension(
    		ApexPages.StandardController controller, 
    		DatabaseHelper databaseHelper, 
    		GenericDml genericDml,
    		VisualForceHelper visualForceHelper
    	) { 
    	this.controller = controller;
        this.databaseHelper = databaseHelper;
        this.genericDml = genericDml;
        this.visualForceHelper = visualForceHelper;
        
        this.productsToInsert = new List<ProductWrapper>();
        this.addRows();
    }

    public Product2Extension(ApexPages.StandardController controller){
   		this(controller, new DatabaseHelper(), new GenericDml(), new VisualForceHelper());
    }

    public List<ProductWrapper> productsToInsert {get;set;}

	private static final String SELECT_ONE = Constants.SELECT_ONE;

    public void addRows(){
        for (Integer i = 0; i < Constants.DEFAULT_ROWS; i++){
            productsToInsert.add( new ProductWrapper() );
        }
    }

    public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.GetInventory();
    }
    
    public List<SelectOption> getFamilyOptions() {
    	List<SelectOption> optionList = new List<SelectOption>();
    	optionList.add(new SelectOption(SELECT_ONE, SELECT_ONE));
    	for (Schema.PicklistEntry picklistEntry : Constants.PRODUCT_FAMILY) {
    		optionList.add(new SelectOption(picklistEntry.getLabel(), picklistEntry.getValue()));
    	}
    	return optionList;
    }

    public PageReference save(){
    	System.debug('####### Save: ');
    	SavePoint savePoint = this.databaseHelper.setSavePoint();
    	System.debug('####### savePoint: ' + savePoint);
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
    
    private Map<PriceBookEntry, Product2> buildProductByPriceBookEntryMap() {
    	Map<PriceBookEntry, Product2> productByPriceBookEntryMap = new Map<PriceBookEntry, Product2>();
    	for (ProductWrapper productWrapper : this.productsToInsert) {
    	System.debug('####### productWrapper.hasAllDataRequiredToSave(): ' + productWrapper.hasAllDataRequiredToSave());
    		if (productWrapper.hasAllDataRequiredToSave()) {
    			productByPriceBookEntryMap.put(productWrapper.pricebookEntryRecord, productWrapper.productRecord);
    		}
    	}
    	System.debug('####### productByPriceBookEntryMap: ' + productByPriceBookEntryMap);
		return productByPriceBookEntryMap;    	
    }
    
    private String saveProductList(List<Product2> productList) {
    	String errorMessage = this.genericDml.doInsertOrReturnErrorMessage(productList); 
    	if (String.isBlank(errorMessage)) {
	    	visualForceHelper.addInfoMessage(productList.size() + ' Inserted');
    	}
    	return errorMessage;
    }
    
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
    
    private void resetForm() {
    		this.productsToInsert.clear();
	    	this.addRows();
    }
}