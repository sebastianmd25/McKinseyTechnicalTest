/**
 * @description Clase test para probar la clase PlanetScannerService.
 * @author      Sebastián Medina Delgado
 * @since       Febrero 2025
 */
@Istest
public with sharing class PlanetScannerServiceTest {
    private static String CASE_STATUS_CLOSED = 'Closed';

    @TestSetup
    static void makeData(){
        TestDataBuilderUtility.createPlanet('Planet 001', '0100201', 'kdlnask', true);      
    }

    @IsTest
    static void scanAndCloseCaseSuccessTest() {
        Planet__c planet = [SELECT Id, Name, Code__c FROM Planet__c LIMIT 1];
        Case caseRecord = TestDataBuilderUtility.createEmailCase(planet.Name, planet.Code__c, '', true);

        Test.setMock(HttpCalloutMock.class, new MockYodaLocationResponse(200, true));
        Test.startTest();
            Boolean result = PlanetScannerService.scanAndCloseCase(caseRecord.Id, planet.Code__c);
        Test.stopTest();
        Case updatedCase = [SELECT Status, SuccessfulScan__c FROM Case WHERE Id = :caseRecord.Id];
        Assert.isTrue(result, 'Se ha encontrado a Yoda');
        Assert.areEqual(updatedCase.Status, CASE_STATUS_CLOSED, 'El caso se cerro correctamente');
        Assert.isTrue(updatedCase.SuccessfulScan__c, 'El escaneo del planeta termino exitosamente');
    }

    @IsTest
    static void scanAndCloseCaseFailureTest() {
        Planet__c planet = [SELECT Id, Name, Code__c FROM Planet__c LIMIT 1];
        Case caseRecord = TestDataBuilderUtility.createEmailCase(planet.Name, planet.Code__c, '', true);

        Test.setMock(HttpCalloutMock.class, new MockYodaLocationResponse(403, false));
        Test.startTest();
            try{
                PlanetScannerService.scanAndCloseCase(caseRecord.Id, planet.Code__c);
            } catch (Exception e) {
                System.debug('Test::: Excepción atrapada: ' + e.getMessage());
            }
        Test.stopTest();
        Case updatedCase = [SELECT Status, SuccessfulScan__c FROM Case WHERE Id = :caseRecord.Id];
        Assert.areNotEqual(updatedCase.Status, CASE_STATUS_CLOSED, 'El caso NO debe cerrarse cuando Yoda no es encontrado');
    }

    /**
     * @description Clase que implementa HttpCalloutMock para simular la respuesta de la API de ubicación de Yoda.
     */
    public class MockYodaLocationResponse implements HttpCalloutMock {
        private Integer statusCode;
        private Boolean foundYoda;

        /**
         * @description Constructor que inicializa la respuesta simulada con el valor de si Yoda fue encontrado.
         * @param statusCode Indica el codigo de la transaccion.
         * @param found Indica si Yoda fue encontrado en el planeta.
         */
        public MockYodaLocationResponse(Integer statusCode, Boolean found) {
            this.statusCode = statusCode;
            this.foundYoda = found;
        }

        /**
         * @description Implementación del método respond de HttpCalloutMock, Simula la respuesta HTTP con un código 200.
         * @param req Objeto HttpRequest recibido en la simulación.
         * @return HttpResponse con el estado 200 y el cuerpo de la respuesta simulada.
         */
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(statusCode);
            res.setBody('{"found": ' + foundYoda + '}');
            return res;
        }
    }
}