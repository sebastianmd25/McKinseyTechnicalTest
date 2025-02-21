/**
 * @description Clase que se encarga de gestionar las consultas sobre el SObject Contact
 * @author Sebastián Medina Delgado
 * @since  Febrero 2025
 */
public inherited sharing class ContactSelector extends SelectorHandler {
    /**
     * @description Obtiene el nombre API del SObject Contact.
     * @return Nombre del objeto SObject correspondiente a Contact.
     */
    protected override String getSObjectName() {
        return Contact.SObjectType.getDescribe().getName();
    } 

    /**
     * @description Devuelve la lista de campos que se utilizarán en las consultas de Contact.
     * @return List<String> de nombres de los campos relevantes de la entidad Contact.
     */
    protected override List<String> getFields() {
        return new List<String>{
            Contact.SObjectType.fields.Id.getDescribe().getName(),
            Contact.SObjectType.fields.Name.getDescribe().getName(),
            Contact.SObjectType.fields.Email.getDescribe().getName()
        };
    }

    /**
     * @description Recupera todos los contactos cuyo email se encuentre en la lista recibida.
     * @param emails List<String> con los emails de los contactos a recuperar.
     * @return List<Contact> con los contactos correspondientes.
     */
    public Map<String, Contact> getContactsByEmail(Set<String> emails) {
        Map<String, Contact> result = new Map<String, Contact>();
        String query = new QueryBuilder()
            .objectName(getSObjectName())
            .fields(getFields())
            .conditions('Email IN :emails')
            .build();

        for (Contact contactRecord : (List<Contact>) Database.query(query)) {
            result.put(contactRecord.Email, contactRecord);
        }

        return result;
    }
}