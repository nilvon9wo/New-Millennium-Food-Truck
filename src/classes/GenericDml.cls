public class GenericDml {
    public List<SObject> doInsert (List<SObject> sObjectList) {
    	insert sObjectList;
    	return sObjectList;
    }

    public String doInsertOrReturnErrorMessage(List<SObject> sObjectList) {
    	String errorMessage;
    	try {
	    	this.doInsert(sObjectList); 
    	}
    	catch (DmlException ex) {
    		errorMessage = ex.getMessage();
    	}
    	return errorMessage;
    }

    public List<SObject> doUpdate (List<SObject> sObjectList) {
    	update sObjectList;
    	return sObjectList;
    }
} 