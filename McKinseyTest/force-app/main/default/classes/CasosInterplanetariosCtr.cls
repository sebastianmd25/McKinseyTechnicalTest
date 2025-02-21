/**
 * @description Controlador del LWC casosInterplanetarios
 * @author Sebastián Medina Delgado
 * @since  Febrero 2025
 */
public with sharing class CasosInterplanetariosCtr {
    public static CaseSelector caseSelectorCls = new CaseSelector();
 
    /**
     * @description Método que retorna los casos interplanetarios más antiguos que siguen abiertos.
     * @return Lista de `CaseDataWrapper` con la información estructurada de los casos.
     * @throws AuraHandledException en caso de error al recuperar los datos.
     */
    @AuraEnabled(Cacheable=true)
    public static List<CaseDataWrapper> getCasesData(){
        List<CaseDataWrapper> result = new List<CaseDataWrapper>();
        List<Case> interplanetaryCases = caseSelectorCls.getOldOpenCases();

        for(Case caseRecord : interplanetaryCases) {
            CaseDataWrapper record = new CaseDataWrapper(
                caseRecord.Id,
                caseRecord.CaseNumber,
                caseRecord.Subject,
                caseRecord.Status,
                caseRecord.Contact.Name,
                caseRecord.Contact.Email,
                caseRecord.Contact.ContactURL__c,
                String.valueOf(caseRecord.SuccessfulScan__c),
                caseRecord.Planet__r.Name,
                caseRecord.Planet__r.Code__c,
                caseRecord.Planet__r.Access_Code__c,
                caseRecord.CreatedDate.format()
            );
            
            result.add(record);
        }
        try {
            return result;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /**
     * @description Clase wrapper para estructurar la información de un caso interplanetario.
     */
    public class CaseDataWrapper {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String caseNumber;
        @AuraEnabled
        public String subject;
        @AuraEnabled
        public String status;
        @AuraEnabled
        public String contactName;
        @AuraEnabled
        public String contactEmail;
        @AuraEnabled
        public String contactUrl;
        @AuraEnabled
        public String successfulScan;
        @AuraEnabled
        public String planet;
        @AuraEnabled
        public String planetCode;
        @AuraEnabled
        public String planetAccessCode;
        @AuraEnabled
        public String createdDate;

        /**
         * @description Constructor de la clase wrapper.
         * @param Id            Id del caso.
         * @param caseNumber    Numero del caso.
         * @param subject       Asunto del caso.
         * @param status        Estado del caso.
         * @param contactName   Nombre del contacto asociado al caso.
         * @param contactEmail  Email del contacto asociado al caso.
         * @param contactUrl    URL de contacto asociado al caso.
         * @param planet        Nombre del planeta asociado al caso.
         * @param planetCode    Código del planeta asociado al caso.
         * @param createdDate   Fecha y hora de creacion del caso.
         */
        public CaseDataWrapper(String id, String caseNumber,  String subject, String status, String contactName, String contactEmail, String contactUrl, String successfulScan, String planet, String planetCode, String planetAccessCode, String createdDate) {
            this.id = id;
            this.caseNumber = caseNumber;
            this.subject = subject;
            this.status = status;
            this.contactName = contactName;
            this.contactEmail = contactEmail;
            this.contactUrl = contactUrl;
            this.successfulScan = successfulScan;
            this.planet = planet;
            this.planetCode = planetCode;
            this.planetAccessCode = planetAccessCode;
            this.createdDate = createdDate;
        }
    }
}
