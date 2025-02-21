/**
 * @description Clase que se encarga de gestionar las consultas sobre el SObject Case
 * @author Sebastián Medina Delgado
 * @since  Febrero 2025
 */ 
public inherited sharing class CaseSelector extends SelectorHandler {
    /**
     * @description Obtiene el nombre API del SObject Case.
     * @return Nombre del objeto SObject correspondiente a Case.
     */
    protected override String getSObjectName() {
        return Case.SObjectType.getDescribe().getName();
    }

    /**
     * @description Devuelve la lista de campos que se utilizarán en las consultas de Case.
     * @return List<String> de nombres de los campos relevantes de la entidad Case.
     */
    protected override List<String> getFields() {
        return new List<String>{
            Case.SObjectType.fields.Id.getDescribe().getName(),
            Case.SObjectType.fields.OwnerId.getDescribe().getName(),
            Case.SObjectType.fields.CreatedDate.getDescribe().getName(),
            Case.SObjectType.fields.CaseNumber.getDescribe().getName(),
            Case.SObjectType.fields.Subject.getDescribe().getName(),
            Case.SObjectType.fields.Status.getDescribe().getName(),
            Case.SObjectType.fields.ContactId.getDescribe().getName(),
            Case.SObjectType.fields.Planet__c.getDescribe().getName(),
            Case.SObjectType.fields.SuccessfulScan__c.getDescribe().getName(),
            Case.SObjectType.fields.isClosed__c.getDescribe().getName(),
            'Contact.Name',
            'Contact.Email',
            'Contact.ContactURL__c',
            'Planet__r.Name',
            'Planet__r.Code__c',
            'Planet__r.Access_Code__c'
        };
    }

    /**
     * @description Recupera todos los 5 casos abiertos mas antiguos asignados al usuario.
     * @return List<Case> con los casos correspondientes.
     */
    public List<Case> getOldOpenCases() {
        String userId = UserInfo.getUserId();
        List<Case> result = new List<Case>();
        String query = new QueryBuilder()
            .objectName(getSObjectName())
            .fields(getFields())
            .conditions('isClosed__c = false AND OwnerId = :userId')
            .orderBy(new List<String>{'CreatedDate'})
            .orderByDirection('ASC')
            .rowLimit(5)
            .build();

        for (Case caseRecord : (List<Case>) Database.query(query)) {
            result.add(caseRecord);
        }

        return result;
    }
} 