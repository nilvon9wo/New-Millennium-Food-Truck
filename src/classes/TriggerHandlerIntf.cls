public interface TriggerHandlerIntf {
    List<SObject> onBeforeInsert();
    List<SObject> onAfterInsert ();

    List<SObject> onBeforeUpdate();
    List<SObject> onAfterUpdate ();

    List<SObject> onBeforeDelete();
    List<SObject> onAfterDelete ();
    
    List<SObject> onAfterUndelete();
}