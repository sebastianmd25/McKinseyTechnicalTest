trigger CaseTrigger on Case (before insert, after insert) {
    new CaseTriggerHandler().run();
}   