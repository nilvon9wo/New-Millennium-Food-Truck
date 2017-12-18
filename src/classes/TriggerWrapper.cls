public class TriggerWrapper {
	@testVisible public List<SObject>	 newSObjectList    {get; private set;}
	@testVisible public Map<Id, SObject> newSObjectByIdMap {get; private set;}
	@testVisible public List<SObject> 	 oldSObjectList    {get; private set;}
	@testVisible public Map<Id, SObject> oldSObjectByIdMap {get; private set;} 
	@testVisible public Integer		  	 size			   {get; private set;}
	@testVisible public Boolean 		 isBefore          {get; private set;}
	@testVisible public Boolean 		 isAfter           {get; private set;}
	@testVisible public Boolean 		 isInsert   	   {get; private set;}
	@testVisible public Boolean 		 isUpdate   	   {get; private set;}
	@testVisible public Boolean 		 isDelete   	   {get; private set;}
	@testVisible public Boolean 		 isUndelete 	   {get; private set;}
	@testVisible public Boolean 		 isExecuting 	   {get; private set;}
	
	public TriggerWrapper() {
		this.newSObjectList 	= Trigger.new;
		this.newSObjectByIdMap 	= Trigger.newMap;
		this.oldSObjectList 	= Trigger.old;
		this.oldSObjectByIdMap 	= Trigger.oldMap;
		this.size 				= Trigger.size;
		this.isBefore 			= Trigger.isBefore;
		this.isAfter 			= Trigger.isAfter;
		this.isInsert 			= Trigger.isInsert;
		this.isUpdate 			= Trigger.isUpdate;
		this.isDelete 			= Trigger.isDelete;
		this.isUndelete 		= Trigger.isUndelete;
		this.isExecuting 		= Trigger.isExecuting;
	}     
	
	@testVisible
	public SObjectType sObjectType {
		get {
			if (this.sObjectType == null) {
				Boolean hasNewSObjectList = (this.newSObjectList != null && !this.newSObjectList.isEmpty()); 		
				Boolean hasOldSObjectList = (this.oldSObjectList != null && !this.oldSObjectList.isEmpty()); 		
			    
			    SObject sampleSObject = hasNewSObjectList
			        ? this.newSObjectList[0] 
			        : ((hasOldSObjectList) ? this.oldSObjectList[0] : null); 
			        
		    	this.sObjectType = (sampleSObject != null)
		    		? sampleSObject.getSObjectType()
		    		: null;		
			}
			return this.sObjectType;
		}
		private set;
	}   
}