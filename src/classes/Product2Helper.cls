public class Product2Helper { 
	CollaborationGroupSelector collaborationGroupSelector;
	InventorySettingSelector inventorySettingSelector;
	
	private static final String SELECT_ONE = Constants.SELECT_ONE;
	
	public Product2Helper(CollaborationGroupSelector collaborationGroupSelector, InventorySettingSelector inventorySettingSelector) {
		this.collaborationGroupSelector = collaborationGroupSelector;
		this.inventorySettingSelector = inventorySettingSelector;
	} 

	public Product2Helper() {
		this(new CollaborationGroupSelector(), new InventorySettingSelector());
	}

    static CollaborationGroup COLLABORATION_GROUP = (new Product2Helper()).selectInventoryAnnouncementCollaborationGroup(); 
    
    private CollaborationGroup selectInventoryAnnouncementCollaborationGroup() {
    	return this.collaborationGroupSelector.selectByName(Constants.INVENTORY_ANNOUNCEMENTS); 
    } 

    public static void afterUpdate(List<Product2> oldList, List<Product2> newList){
    	(new Product2Helper()).onAfterUpdate(oldList, newList);
    }
    
    public void onAfterUpdate(List<Product2> oldProductList, List<Product2> newProductList){
		Map<String, Decimal> inventoryLowQualityAlertByProductNameMap = new Map<String, Decimal>();
        for (Inventory_Setting__mdt inventorySetting : this.inventorySettingSelector.selectAll()) {
            inventoryLowQualityAlertByProductNameMap.put(inventorySetting.DeveloperName, inventorySetting.Low_Quantity_Alert__c);
        }
        
        List<Product2> needsAnnouncementList = new List<Product2>();
        for (Product2 newProduct : newProductList) {
            if (
            	inventoryLowQualityAlertByProductNameMap.containsKey(newProduct.Name) 
            	&& newProduct.Quantity_Remaining__c < inventoryLowQualityAlertByProductNameMap.get(newProduct.Name)
            ) {
                needsAnnouncementList.add(newProduct);
            }
        }
        this.doPostAlerts(needsAnnouncementList);
    }

    public List<SelectOption> getFamilyOptions() {
    	List<SelectOption> optionList = new List<SelectOption>();
    	optionList.add(new SelectOption(SELECT_ONE, SELECT_ONE));
    	for (Schema.PicklistEntry picklistEntry : Constants.PRODUCT_FAMILY) {
    		optionList.add(new SelectOption(picklistEntry.getLabel(), picklistEntry.getValue()));
    	}
    	return optionList;
    }

    public static void PostAlerts(List<Product2> productList){
    	(new Product2Helper()).doPostAlerts(productList);
    }
 
    public void doPostAlerts(List<Product2> productList){
        List<ConnectApi.AnnouncementInput> announcementInputList = new List<ConnectApi.AnnouncementInput>();
        for ( Product2 product : productList ){
            ConnectApi.TextSegmentInput textSegmentInput = this.createTextSegmentInput(product);
            ConnectApi.MessageBodyInput messageBodyInput = this.createMessageBodyInput(textSegmentInput);
            announcementInputList.add(this.createAnnouncementInput(messageBodyInput));
        }
        System.enqueueJob(new AnnouncementQueueable(announcementInputList)); 
    } 

	private ConnectApi.TextSegmentInput createTextSegmentInput(Product2 product) {
		ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        textSegmentInput.text = product.Name + Constants.INVENTORY_LEVEL_LOW;
        return textSegmentInput;
	}
    
    private ConnectApi.MessageBodyInput createMessageBodyInput(ConnectApi.TextSegmentInput textSegmentInput) {
    	ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        messageBodyInput.messageSegments.add(textSegmentInput);
        return messageBodyInput;
    }
    
    private ConnectApi.AnnouncementInput createAnnouncementInput(ConnectApi.MessageBodyInput messageBodyInput) {
		ConnectApi.AnnouncementInput announcementInput = new ConnectApi.AnnouncementInput();
        announcementInput.expirationDate = Date.today().addDays(1);
        announcementInput.sendEmails = true;
        announcementInput.parentId = COLLABORATION_GROUP.Id;
        announcementInput.body = messageBodyInput;
        return announcementInput; 
    }
}