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

    public PageReference Save(){
        Savepoint sp = Database.setSavepoint();
        try {
            List<Product2> products = new List<Product2>();
            List<PricebookEntry> entries = new List<PricebookEntry>();
            
            for (ProductWrapper wrp : productsToInsert){
                if(null!=wrp.productRecord && null!=wrp.pricebookEntryRecord){
                    
                    if(null!=wrp.productRecord.Name && null!=wrp.productRecord.Family && constants.SELECT_ONE!=wrp.productRecord.Family
                       && null!=wrp.productRecord.Initial_Inventory__c && null!=wrp.pricebookEntryRecord.UnitPrice){
                        products.add(wrp.productRecord);
                        PricebookEntry entry=wrp.pricebookEntryRecord;
                        entry.IsActive=true;
                        entry.Pricebook2Id=constants.STANDARD_PRICEBOOK_ID;
                        entries.add(entry);   
                    }
                }
            }
			
            insert products;
            
            for (integer itr=0; itr<entries.size();itr++){
                entries[itr].Product2Id=products[itr].id;
            }
            insert entries;
            //If successful clear the list and display an informational message
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,productsToInsert.size()+' Inserted'));
            productsToInsert.clear();   //Do not remove
            addRows();  //Do not remove
        } catch (Exception e){
			Database.rollback(sp);
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,constants.ERROR_MESSAGE));
        }
        return null;
    }


/*
    public PageReference save_IMPROVED(){
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
    
    private Map<PriceBookEntry, Product2> buildProductByPriceBookEntryMap() {
    	Map<PriceBookEntry, Product2> productByPriceBookEntryMap = new Map<PriceBookEntry, Product2>();
    	for (ProductWrapper productWrapper : this.productsToInsert) {
    		if (productWrapper.hasAllDataRequiredToSave()) {
    			productByPriceBookEntryMap.put(productWrapper.pricebookEntryRecord, productWrapper.productRecord);
    		}
    	}
		return productByPriceBookEntryMap;    	
    }
*/
    
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
    
	public class ProductWrapper {
		public Product2 productRecord {get; set;}
		public PriceBookEntry priceBookEntryRecord {get; set;}
		
		public ProductWrapper() {
			this.productRecord = new Product2();
			this.priceBookEntryRecord = new PriceBookEntry();
		}
	}    
}