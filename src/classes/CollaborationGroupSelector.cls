public virtual class CollaborationGroupSelector {
    public virtual CollaborationGroup selectByName(String name){
    	return [
	        SELECT Id
	        FROM CollaborationGroup
	        WHERE Name = :name
	        LIMIT 1
	    ];
    }     
}