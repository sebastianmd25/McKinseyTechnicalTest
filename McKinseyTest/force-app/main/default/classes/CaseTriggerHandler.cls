/**
 * @description Clase que encargada de ejecutar la logica relaiconada a la configuracion del trigger de casos.
 * @author      Sebastián Medina Delgado
 * @since       Febrero 2025
 */
public without sharing class CaseTriggerHandler extends TriggerHandler {
    public CaseService caseServiceCls = new CaseService();
 
    /**
     * @description Metodo que se ejecuta antes de la  insercion de nuevos casos.
     * @param records Lista de casos que están siendo insertados.
     */
    protected override void beforeInsert(List<SObject> records) {
        List<Case> newCases = (List<Case>) records;
        caseServiceCls.getRelatedPlanet(newCases);
        caseServiceCls.assignContact(newCases);
    }  
    
    /**
     * @description Metodo que se ejecuta despues de la  insercion de nuevos casos.
     * @param records Lista de casos que están siendo insertados.
     */
    protected override void afterInsert(List<SObject> records) {
        List<Case> newCases = (List<Case>) records;
        caseServiceCls.publishEmalCaseCreationEnvent(newCases);
    } 
}
