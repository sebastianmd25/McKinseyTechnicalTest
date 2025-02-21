/**
 * @description Clase test para probar la clase FieldSetService.
 * @author      Sebastián Medina Delgado
 * @since       Febrero 2025
 */
@Istest
public class FieldSetServiceTest {
    @TestSetup
    static void makeData(){
        Planet__c planet = TestDataBuilderUtility.createPlanet('Planet 001', '0100201', 'kdlnask', true);      
    }

    @IsTest
    static void getFieldServiceFormTest(){
        String fieldSetName = 'Casos_interplanetarios';
        Planet__c planet = [SELECT Id, Name, Code__c FROM Planet__c LIMIT 1];
        Case caseRecord = TestDataBuilderUtility.createEmailCase(planet.Name, planet.Code__c, '', false);

        Test.StartTest();
            // FieldSetService.getFieldServiceForm(caseRecord.Id, fieldSetName);
        Test.StopTest();
    }
}
