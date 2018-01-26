@isTest
public class CollaborationGroupSelectorMock extends CollaborationGroupSelector {
	public String receivedName;
	public CollaborationGroup returnedCollaborationGroup; 
    public override CollaborationGroup selectByName(String name){
    	this.receivedName = name;
    	return returnedCollaborationGroup;
    }     
}