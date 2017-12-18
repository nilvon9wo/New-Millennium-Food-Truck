public abstract class TriggerHandlerAbstract implements TriggerHandlerIntf {
	protected TriggerWrapper triggerWrapper;
 
    public TriggerHandlerAbstract(TriggerWrapper triggerWrapper) {
    	this.triggerWrapper = triggerWrapper;
    }
    
    public TriggerHandlerAbstract() {
    	this(new TriggerWrapper());
    }
    
    public List<SObject> invoke() {
		if (this.triggerWrapper.isBefore) {
            if (this.triggerWrapper.isInsert ) {
                return this.onBeforeInsert();
            } else if(this.triggerWrapper.isUpdate) {
                return this.onBeforeUpdate();
            } else if (this.triggerWrapper.isDelete) {
                return this.onBeforeDelete();
            }
        } else if (this.triggerWrapper.isAfter) {
            if (this.triggerWrapper.isInsert) {
                return this.onAfterInsert();
            } else if (this.triggerWrapper.isUpdate) {
                return this.onAfterUpdate();
            } else if (this.triggerWrapper.isDelete) {
                return this.onAfterDelete();
            } else if (this.triggerWrapper.isUndelete) {
                return this.onAfterUndelete();
            }
        }
        return null;
	}
    
    public virtual List<SObject> onBeforeInsert() {
    	return null;
    }
    
    public virtual List<SObject> onAfterInsert () {
    	return null;
    }
    
    public virtual List<SObject> onBeforeUpdate() {
    	return null;
    }
    
    public virtual List<SObject> onAfterUpdate () {
    	return null;
    }
    
    public virtual List<SObject> onBeforeDelete() {
    	return null;
    }
    
    public virtual List<SObject> onAfterDelete () {
    	return null;
    }
    
    public virtual List<SObject> onAfterUndelete() {
    	return null;
    }
}