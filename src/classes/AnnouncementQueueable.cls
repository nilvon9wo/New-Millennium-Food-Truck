public class AnnouncementQueueable implements Queueable {
    public List<ConnectApi.AnnouncementInput> toPost;
	
	public AnnouncementQueueable(List<ConnectApi.AnnouncementInput> announcementInputList) {
		this.toPost = announcementInputList;
	}
	
	public void execute(System.QueueableContext queueableContext) {
		postAnnouncements(this.toPost);	
	}

    public static void postAnnouncements(List<ConnectApi.AnnouncementInput> announcementInputList){
        while ( announcementInputList.size() > 0 ){
            if ( Limits.getDMLStatements() < Limits.getLimitDMLStatements() && !Test.isRunningTest() ){
                ConnectApi.AnnouncementInput announcementInput = announcementInputList.remove(0);
                ConnectApi.Announcements.postAnnouncement('Internal', announcementInput);
            } else {
                break;
            }
        }
        if ( announcementInputList.size() > 0 && !Test.isRunningTest() ){
            System.enqueueJob(new AnnouncementQueueable(announcementInputList));
        }
    }
}