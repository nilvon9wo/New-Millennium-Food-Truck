public class VisualForceHelper {
    public ApexPages.message addInfoMessage(String message){
    	return this.addMessage(ApexPages.Severity.INFO, message);
    }

    public ApexPages.message addErrorMessage(String message){
    	return this.addMessage(ApexPages.Severity.ERROR, message);
    }

    private ApexPages.message addMessage(ApexPages.Severity severity, String message){
    	ApexPages.message pageMessage = new ApexPages.message(severity, message);
    	ApexPages.addMessage(pageMessage);
    	return pageMessage;
    }
}