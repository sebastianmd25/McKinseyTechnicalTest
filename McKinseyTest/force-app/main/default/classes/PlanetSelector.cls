/**
 * @description Clase que se encarga de gestionar las consultas sobre el SObject Plannet__c
 * @author Sebastián Medina Delgado
 * @since  Febrero 2025
 */
public inherited sharing class PlanetSelector extends SelectorHandler {
    /**
     * @description Obtiene el nombre API del SObject Planet__c.
     * @return Nombre del objeto SObject correspondiente a Planet__c.
     */
    protected override String getSObjectName() {
        return Planet__c.SObjectType.getDescribe().getName();
    } 

    /**
     * @description Devuelve la lista de campos que se utilizarán en las consultas de Planet__c.
     * @return List<String> de nombres de los campos relevantes de la entidad Planet__c.
     */
    protected override List<String> getFields() {
        return new List<String>{
            Planet__c.SObjectType.fields.Id.getDescribe().getName(),
            Planet__c.SObjectType.fields.Name.getDescribe().getName(),
            Planet__c.SObjectType.fields.Code__c.getDescribe().getName()
        };
    }

    /**
     * @description Recupera todos los planetas y los almacena en un mapa donde la clave es el código del planeta.
     * @return Map<String, Planet__c> con los planetas, la clave es el campo Code__c y el valor es el objeto Planet__c.
     */
    public Map<String, Planet__c> getAllPlanets() {
        Map<String, Planet__c> result = new Map<String, Planet__c>();

        String query = new QueryBuilder()
            .objectName(getSObjectName())
            .fields(getFields())
            .securityEnforced(true)
            .build();

        for (Planet__c planet : (List<Planet__c>) Database.query(query)) {
            result.put(planet.Code__c, planet);
        }

        return result;
    }
}
