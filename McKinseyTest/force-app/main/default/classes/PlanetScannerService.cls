/**
 * @description Clase encargada de realizar el serivicio para encontrar a Yoda
 * @author Sebastián Medina Delgado
 * @since  Febrero 2025
 */
public without sharing class PlanetScannerService {
    public static final String CASE_STATUS_CLOSED = 'Closed';

    /**
     * @description Realiza un escaneo interplanetario para verificar la presencia de Yoda en un planeta, si es encontrado, cierra automáticamente el caso.
     * @param caseId ID del caso a actualizar.
     * @param planetAccessCode Código de acceso del planeta a escanear.
     * @return Boolean indicando si Yoda fue encontrado en el planeta.
     */
    @AuraEnabled
    public static Boolean scanAndCloseCase(String caseId, String planetAccessCode) {
        if (String.isEmpty(planetAccessCode) || String.isBlank(planetAccessCode)) {
            throw new AuraHandledException('Es necesario un codigo de acceso valido para realizar este scan.');
        }

        Boolean foundYoda = false;
        try {
            HttpResponse response = callYodaLocationAPI(planetAccessCode);
            Integer responseStatusCode = response.getStatusCode();
            String responseBody = response.getBody();
            Map<String, Object> responseMessageMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
            String errorMessage = responseMessageMap.containsKey('message') ? (String) responseMessageMap.get('message') : '';
            
            if (responseStatusCode != 200 ) {
                throw new AuraHandledException('Codigo: ' + responseStatusCode + ': ' + errorMessage);

            }

            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
            foundYoda = responseMap.containsKey('found') ? (Boolean) responseMap.get('found') : false;
            updateCaseAsClosed(caseId, foundYoda);

            return foundYoda;
        } catch (AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw new AuraHandledException('Codigo: ' + e.getMessage());
        }
    }

    /**
     * @description Llama a la API externa para consultar la ubicación de Yoda en un planeta.
     * @param planetAccessCode Código de acceso del planeta a consultar.
     * @return HttpResponse con la respuesta de la API.
     * @throws CalloutException Si hay problemas de conexión con la API.
     */
    private static HttpResponse callYodaLocationAPI(String planetAccessCode) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:YodaPlanetLocationAPI/' + EncodingUtil.urlEncode(planetAccessCode, 'UTF-8'));
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');

        Http http = new Http();
        return http.send(req);
    }

    /**
     * @description Actualiza el estado de un caso a "Closed" y marca el escaneo como exitoso.
     * @param caseId ID del caso a actualizar.
     * @param wasFound Boolean que verifica si Yoda fue encontrado o no.
     * @throws AuraHandledException Si la actualización del caso falla.
     */
    private static void updateCaseAsClosed(String caseId, Boolean wasFound) {
        if (Schema.SObjectType.Case.isUpdateable()) {
            Case caseRecord = new Case(
                Id = caseId,
                SuccessfulScan__c = wasFound,
                Status = CASE_STATUS_CLOSED
            );
            update caseRecord;
        } else {
            throw new AuraHandledException('No tienes permisos para actualizar el caso.');
        }
    }
}
