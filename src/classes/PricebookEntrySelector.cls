public virtual class PricebookEntrySelector {
	public virtual List<PricebookEntry> getStandardSetFrom(ApexPages.StandardSetController standardSetController) {
		return (List<PricebookEntry>) standardSetController.getRecords();
	}
	
    public Database.QueryLocator getQueryLocator() {
    	String selectedFamily = null;  
		return this.getQueryLocatorForFamily(selectedFamily); 
    } 

    public Database.QueryLocator getQueryLocatorForFamily(String selectedFamily) {
        String query = 'SELECT Name, Product2Id, Product2.Family, Product2.Name, Product2.Quantity_Remaining__c, UnitPrice'
                     + ' FROM PricebookEntry'
                     + ' WHERE IsActive = TRUE';

        if (selectedFamily != null && selectedFamily != Constants.SELECT_ONE) {
            query += ' AND Product2.Family = :selectedFamily';
        }
        
        query += ' ORDER BY Name';
        return Database.getQueryLocator(query);
    }
}