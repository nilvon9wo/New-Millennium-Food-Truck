public class CollaborationGroupSelector {
    public CollaborationGroup selectByName(String name){

		// Existing Chatter Groups prevent SFDC from using the same name when groups are created as test data.  :-(
    	String chatterGroupName = (!Test.isRunningTest())
    		? name
    		: 'TEST' + name;
    	
    	return [
	        SELECT Id
	        FROM CollaborationGroup
	        WHERE Name = :chatterGroupName
	        LIMIT 1
	    ];
    }     
}