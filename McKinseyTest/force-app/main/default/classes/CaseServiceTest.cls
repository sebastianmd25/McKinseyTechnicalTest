/**
 * @description Clase test para probar la clase CaseService.
 * @author      Sebastián Medina Delgado
 * @since       Febrero 2025
 */
@Istest
public class CaseServiceTest {
    private static String CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';

    @TestSetup
    static void makeData(){
        Account accountRecord = TestDataBuilderUtility.createAccount(true);
        TestDataBuilderUtility.createContact(accountRecord.Id, true);
        List<Planet__c> planets = new List<Planet__c>();

        for(Integer i = 0; i < 9; i++) {
            String planetName = 'Planet 00' + i;
            String planetCode = '010020' + i;
            String planetAccessCode = generateAccessCode(9);
            Planet__c planet = TestDataBuilderUtility.createPlanet(planetName, planetCode, planetAccessCode, false);
            planets.add(planet);
        }
        
        insert planets;
    }

    @IsTest
    static void getRelatedPlanetTest() {
        List<Case> cases = new List<Case>();
        String randomPlanetName = [SELECT Name FROM Planet__c WHERE Name != '' LIMIT 1].Name;
        String randomPlanetCode = [SELECT Code__c FROM Planet__c WHERE Code__c != '' LIMIT 1].Code__c;

        for(Integer i = 0; i < 5; i++) {
            Case caseRecord = TestDataBuilderUtility.createEmailCase(randomPlanetName, randomPlanetCode, '', false);
            cases.add(caseRecord);
        }

        Test.StartTest();
            insert cases;
            String casePlanetCode = [SELECT Planet__r.Code__c FROM Case LIMIT 1].Planet__r.Code__c;
        Test.StopTest();

        List<Planet__c> planets = [SELECT Id FROM Planet__c WHERE Code__c = :casePlanetCode];
        Assert.isNotNull(planets.get(0).Id, 'Se relaciono el planeta correctamente');
    }

    @IsTest
    static void assignContactTest() {
        List<Case> cases = new List<Case>();
        Contact testContact = [SELECT Id, Name, Email FROM Contact WHERE Email != '' LIMIT 1];
        String randomPlanetName = [SELECT Name FROM Planet__c WHERE Name != '' LIMIT 1].Name;
        String randomPlanetCode = [SELECT Code__c FROM Planet__c WHERE Code__c != '' LIMIT 1].Code__c;

        for(Integer i = 0; i < 100; i++) {
            Case caseRecord = TestDataBuilderUtility.createEmailCase(randomPlanetName, randomPlanetCode, testContact.Email, false);
            cases.add(caseRecord);
        }

        Test.StartTest();
            insert cases;
        Test.StopTest();
        Case randomInsertedCase = [SELECT Id, Contact.Email, SuppliedEmail, Subject, Description FROM Case WHERE SuppliedEmail != '' LIMIT 1];

        Contact relatedContact = [SELECT Id, Name, Email FROM Contact WHERE Id = :randomInsertedCase.ContactId LIMIT 1];

        Assert.areEqual(testContact.Id, relatedContact.Id, 'Se relaciono el contacto correctamente');
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