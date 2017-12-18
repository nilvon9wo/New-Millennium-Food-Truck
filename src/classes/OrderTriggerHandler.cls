public class OrderTriggerHandler extends TriggerHandlerAbstract {
	OrderService orderService;
	 
	public OrderTriggerHandler(OrderService orderService){
		this.orderService = orderService;
	}
	  
	public OrderTriggerHandler(){
		this(new OrderService()); 
	} 
	 
    public override List<SObject> onAfterInsert (){ 
    	this.orderService.updateQuantityOrdered((Map<Id, Order>) this.triggerWrapper.newSObjectByIdMap);
    	return this.triggerWrapper.newSObjectList;
    }

    public override List<SObject> onAfterUpdate (){
    	this.orderService.updateQuantityOrdered((Map<Id, Order>) this.triggerWrapper.newSObjectByIdMap);
    	return this.triggerWrapper.newSObjectList;
    }

    public override List<SObject> onAfterDelete (){
    	this.orderService.updateQuantityOrdered((Map<Id, Order>) this.triggerWrapper.newSObjectByIdMap);
    	return this.triggerWrapper.oldSObjectList;
    }
    
    public override List<SObject> onAfterUndelete(){
    	this.orderService.updateQuantityOrdered((Map<Id, Order>) this.triggerWrapper.newSObjectByIdMap);
    	return this.triggerWrapper.newSObjectList;
    }
}