public class Product2HelperMock extends Product2Helper { 
	public CollaborationGroup returnedInventoryAnnouncementCollaborationGroup;
    public override CollaborationGroup selectInventoryAnnouncementCollaborationGroup() {
    	return this.returnedInventoryAnnouncementCollaborationGroup;  
    } 
} 