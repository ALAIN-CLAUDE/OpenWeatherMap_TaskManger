trigger LocationTrigger on Location__c (after insert, after update) {
    LocationTriggerHandler.handleTrigger(Trigger.new, Trigger.oldMap, Trigger.operationType);
}