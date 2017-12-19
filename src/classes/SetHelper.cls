public class SetHelper {
    public Set<Id> buildHasChangedToTargetValueIdSet(
    		List<SObject> newSObjectList, 
    		List<SObject> oldSObjectList, 
    		SObjectField sObjectField,
    		Object targetValue
    	) {
    	if (oldSObjectList == null || oldSObjectList.isEmpty()) {
    		return (new Map<Id, SObject>(newSObjectList)).keySet();
    	}
    	
    	Map<Id, SObject> oldSObjectByIdMap = new Map<Id, SObject>(oldSObjectList);
    	return this.buildHasChangedToTargetValueIdSet(newSObjectList, oldSObjectByIdMap, sObjectField, targetValue);
    }
    
    private Set<Id> buildHasChangedToTargetValueIdSet(
    		List<SObject> newSObjectList, 
    		Map<Id, SObject> oldSObjectByIdMap, 
    		SObjectField sObjectField,
    		Object targetValue
    	) {
    	Set<Id> changeSObjectIdSet = new Set<Id>();
    	for (SObject newSObject : newSObjectList) {
    		Object newValue = newSObject.get(sObjectField);
    		
    		SObject oldSObject = oldSObjectByIdMap.get(newSObject.Id);
    		Object oldValue = (oldSObject != null) ? oldSObject : null;
    		
    		if (newValue == targetValue &&  newValue != oldValue) {
    			changeSObjectIdSet.add(newSObject.Id);
    		}
    	}
    	return changeSObjectIdSet;
    }
}