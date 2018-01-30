public class Product2Extension {  
	ApexPages.StandardController controller;
	ChartHelper chartHelper;
    DatabaseHelper databaseHelper;
    F45_DML_GenericDml genericDml;
    Product2Helper product2Helper;
	VisualForceHelper visualForceHelper;
    
    public Product2Extension(
    		ApexPages.StandardController controller,
    		ChartHelper chartHelper, 
    		DatabaseHelper databaseHelper, 
    		F45_DML_GenericDml genericDml,
    		Product2Helper product2Helper, 
    		VisualForceHelper visualForceHelper
    	) { 
    	this.controller = controller;
    	this.chartHelper = chartHelper; 
        this.databaseHelper = databaseHelper;
        this.genericDml = genericDml;
        this.product2Helper = product2Helper;
        this.visualForceHelper = visualForceHelper;
        
        this.productsToInsert = new List<ProductWrapper>();
        this.addRows();
    }

    public Product2Extension(ApexPages.StandardController controller){
   		this(
   			controller, 
   			new ChartHelper(), 
   			new DatabaseHelper(), 
   			new F45_DML_GenericDml(), 
   			new Product2Helper(),  
   			new VisualForceHelper()
   		);
    }

    public List<ProductWrapper> productsToInsert {get;set;}
 
    public List<ChartHelper.ChartData> getInventory(){ 
        return this.chartHelper.selectRemainingProductList(); 
    } 
     
    public List<SelectOption> getFamilyOptions() {		      
     	List<SelectOption> optionList = new List<SelectOption>();		 
     	optionList.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));		
     	for (Schema.PicklistEntry picklistEntry : Constants.PRODUCT_FAMILY) {		 
     		optionList.add(new SelectOption(picklistEntry.getLabel(), picklistEntry.getValue()));		
     	}		
     	return optionList;		
      }

    public PageReference save() { 
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
    
    @testVisible
    private Map<PriceBookEntry, Product2> buildProductByPriceBookEntryMap() {
    	List<PriceBookEntry> priceBookEntryList = new List<PriceBookEntry>();
    	List<Product2> productList = new List<Product2>();
    	
    	for (ProductWrapper productWrapper : this.productsToInsert) {
    		if (productWrapper.hasAllDataRequiredToSave()) {
    			priceBookEntryList.add(productWrapper.pricebookEntryRecord);
    			productList.add(productWrapper.productRecord);
    		}
    	}

    	Map<PriceBookEntry, Product2> productByPriceBookEntryMap = new Map<PriceBookEntry, Product2>();
		if (!productList.isEmpty()) {
			
			String errorMessage = this.saveProductList(productList);
			if (!String.isBlank(errorMessage)) {
				throw new Product2ExtensionException(errorMessage);
			}
			
			for (Integer i = 0; i < productList.size(); i++) {
				Product2 product = productList[i];
				PricebookEntry pricebookEntry = priceBookEntryList[i];
				productByPriceBookEntryMap.put(pricebookEntry, product);
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

    public void addRows(){
        for (Integer i = 0; i < Constants.DEFAULT_ROWS; i++){
            productsToInsert.add( new ProductWrapper() );
        }
    }
}