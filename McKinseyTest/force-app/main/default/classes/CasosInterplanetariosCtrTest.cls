/**
 * @description Clase test para probar la clase CasosInterplanetariosCtr.
 * @author      Sebastián Medina Delgado
 * @since       Febrero 2025
 */
@Istest
public class CasosInterplanetariosCtrTest {
    private static String CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';

    @TestSetup
    static void makeData(){
        Account accountRecord = TestDataBuilderUtility.createAccount(true);
        List<Contact> contacts = new List<Contact>();
        List<Planet__c> planets = new List<Planet__c>();
        List<Case> cases = new List<Case>();

        for(Integer i = 0; i < 5; i++) {
            Contact contactRecord = TestDataBuilderUtility.createContact(accountRecord.Id, false);
            contacts.add(contactRecord);
        }

        insert contacts;

        for(Integer i = 0; i < 5; i++) {
            String planetName = 'Planet 00' + i;
            String planetCode = '010020' + i;
            String planetAccessCode = generateAccessCode(9);
            Planet__c planet = TestDataBuilderUtility.createPlanet(planetName, planetCode, planetAccessCode, false);
            planets.add(planet);
        }
        
        insert planets;

        for(Integer i = 0; i < 5; i++) {
            String randomPlanetName = planets.get(i).Name;
            String randomPlanetCode = planets.get(i).Code__c;
            String contactEmail = contacts.get(i).Email;

            Case caseRecord = TestDataBuilderUtility.createEmailCase(randomPlanetName, randomPlanetCode, contactEmail, false);

            cases.add(caseRecord);
        }

        insert cases;
    }

    @IsTest
    static void getCasesDataTest() {
        List<Case> cases = [SELECT Id, Subject, Status FROM Case ORDER BY CreatedDate ASC];
        List<CasosInterplanetariosCtr.CaseDataWrapper> result = new List<CasosInterplanetariosCtr.CaseDataWrapper>();

        Test.StartTest();
            result = CasosInterplanetariosCtr.getCasesData();
        Test.StopTest();

        Assert.areEqual(result.size(), cases.size(), 'Se mostraron los casos correctamente');
        Assert.areEqual(result.get(0).Id, cases.get(0).Id, 'Se mostraron los casos correctamente');
    }

    private static String generateAccessCode(Integer len) {
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), CHARS.length());
           randStr += CHARS.substring(idx, idx+1);
        }
        return randStr; 
    }
}