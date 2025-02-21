/**
 * @description Clase que contiene la lógica del trigger para la entidad Case.
 * @author Sebastián Medina Delgado
 * @since  Febrero 2025
 */
public without sharing class CaseService {
    public final String EMAIL_ORIGIN = 'Email';
    public PlanetSelector planetSelector = new PlanetSelector();
    public ContactSelector contactSelector = new ContactSelector();
 
    /**
     * @description Asigna el planeta relacionado a cada caso nuevo en función de un id extraído de la descripción del caso.
     * @param newCases Lista de casos recién creados que requieren asignación de planeta.
     */
    public void getRelatedPlanet(List<Case> newCases) {
        Map<String, Planet__c> planetMap = planetSelector.getAllPlanets();

        for (Case objCase : newCases) {
            if (objCase.Description != null) {
                String extractedExternalId = extractExternalId(objCase.Description);
                if (extractedExternalId != null && planetMap.containsKey(extractedExternalId)) {
                    objCase.Planet__c = planetMap.get(extractedExternalId).Id;
                }
            }
        }
    }

    /**
     * @description Si el caso es creado desde el email-to-case busca si existe el contacto y si lo encuentra lo relaciona al caso.
     * @param newCases Lista de casos recién creados que requieren asignación de planeta.
     */
    public void assignContact(List<Case> newCases) {
        Set<String> contactEmails = new Set<String>();
        Map<String, Contact> contactMap = new Map<String, Contact>();

        for (Case caseRecord : newCases) {
            if (caseRecord.Origin == EMAIL_ORIGIN && String.isNotBlank(caseRecord.SuppliedEmail)) {
                contactEmails.add(caseRecord.SuppliedEmail);
            }
        }
        contactMap = contactSelector.getContactsByEmail(contactEmails);
        for(Case caseRecord : newCases) {
            if (caseRecord.Origin == EMAIL_ORIGIN && String.isNotBlank(caseRecord.SuppliedEmail)) {
                caseRecord.ContactId = contactMap.get(caseRecord.SuppliedEmail).Id;
            }
        }
    }

    /**
     * @description Metodo que se encarga de crear un platform event cada vez que se crea un caso a traves del email-to-case
     * @param newCases Lista de casos recién creados que requieren asignación de planeta.
     */
    public void publishEmalCaseCreationEnvent(List<Case> newCases) {
        List<EmailCasesCreated__e> events = new List<EmailCasesCreated__e>();

        for(Case caseRecord : newCases) {
            if (caseRecord.Origin == EMAIL_ORIGIN) {
                EmailCasesCreated__e event = new EmailCasesCreated__e(
                    CaseId__c = caseRecord.Id
                );
                events.add(event);
            }
        }

        if(!events.isEmpty()) {
            EventBus.publish(events);
        }
    }

    /**
     * @description Extrae el identificador externo del planeta a partir de la descripción del caso.
     * @param description Texto de la descripción del caso.
     * @return Identificador del planeta si se encuentra en la descripción, de lo contrario, null.
     */
    private String extractExternalId(String description) {
        Pattern pattern = Pattern.compile('Código de acceso al sistema de escaneo interplanetario:\\s*(\\S+)');
        Matcher matcher = pattern.matcher(description);
        return matcher.find() ? matcher.group(1) : null;
    }
}
