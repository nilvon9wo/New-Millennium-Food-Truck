@isTest
public class SetHelperMock extends SetHelper{
	public List<SObject> receivedNewSObjectList; 
    public List<SObject> receivedOldSObjectList; 
	public SObjectField receivedSObjectField;
    public Object receivedTargetValue;
	public Set<Id> returnedIdSet;
    public override Set<Id> buildHasChangedToTargetValueIdSet(
    		List<SObject> newSObjectList, 
    		List<SObject> oldSObjectList, 
    		SObjectField sObjectField,
    		Object targetValue
    	) {
    	this.receivedNewSObjectList = newSObjectList;
    	this.receivedOldSObjectList = oldSObjectList;
		this.receivedSObjectField = sObjectField;
		this.receivedTargetValue = targetValue; 		
    	return this.returnedIdSet;
   }
}