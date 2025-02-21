/**
 * @description Clase base para crear datos de prueba.
 * @author      Sebastián Medina Delgado
 * @since       Febrero 2025
 */
@Istest
public class TestDataBuilderUtility {
    private static final String TEST_CONTACT_EMAIL_PATTERN = 'mckinsey{0}@test.com';
    /**
     * @description  create Account
     * @param isInserted Decide if a record is inserted
     * @return Account
     */
    public static Account createAccount(Boolean isInserted) {
        Account account = new Account();
        account.Name = 'Test Account';
        account.BillingStreet = 'New York Street';
        account.BillingCity = 'New York';
        account.BillingCountry = 'USA';
        account.BillingPostalCode = '234324';
        account.ShippingStreet = 'Candata Street';
        account.ShippingCity = 'Canada';
        account.ShippingCountry = 'Canada';
        account.ShippingPostalCode = '32432';

        if(isInserted) {
            insert account; 
        }
        return account;
    }
    /**
     * @description  creats contact
     * @param accountId  Account ID
     * @param isInserted Decide if a record is inserted
     * @return Contact
     */
    public static Contact createContact(Id accountId, Boolean isInserted) {
        String email = String.format(
                TEST_CONTACT_EMAIL_PATTERN,
                new List<Object> {Integer.valueOf(Math.rint(Math.random() * 1000000))}
        );

        Contact contact = new Contact(
                AccountId = accountId,
                FirstName = 'Contact',
                LastName = 'Test',
                MailingCity = 'testMailingCity',
                MailingStreet = 'testMailingStreet',
                Email = email,
                MailingPostalCode = '90210',
                Phone= '123-456-7890',
                HomePhone= '123-456-7890'
        );

        if(isInserted) {
            insert contact;
        }
        return contact;
    }
    /**
     * @description  create planet
     * @param planetName  planet record Name
     * @param planetCode  planet record unique code
     * @param accessCode  planet record access code
     * @param isInserted Decide if a record is inserted
     * @return Planet__c
     */
    public static Planet__c createPlanet(String planetName, String planetCode, String accessCode, Boolean isInserted) {
        Planet__c planet = new Planet__c(
            Name = planetName,
            Code__c = planetCode,
            Access_Code__c = accessCode
        );
        if(isInserted) {
            insert planet;
        }
        return planet;
    }
    /**
     * @description  creats case
     * @param planet realated parent planet record
     * @param contactEmail contact email
     * @param isInserted Decide if a record is inserted
     * @return Case
     */
    public static Case createEmailCase(String planetName, String planetCode, String contactEmail, Boolean isInserted) {
        Case caseRecord = new Case(
            Status = 'New',
            Origin = 'Email',
            Subject = 'Solicitud de escaneo - ' + planetName,
            Description = 'Código de acceso al sistema de escaneo interplanetario: ' + planetCode,
            SuppliedEmail = contactEmail
        );
        if(isInserted) {
            insert caseRecord;
        }
        return caseRecord;
    }

}