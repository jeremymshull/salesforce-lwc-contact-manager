public with sharing class ContactController {
    @AuraEnabled
    public static List<Contact> queryContacts(Id accountId) {
        return [
            SELECT Id, FirstName, LastName, Email, Phone
            FROM Contact
            WHERE AccountId  = :accountId
            WITH USER_MODE   
        ];
    }

    @AuraEnabled
    public static void createContact(
        String firstName,
        String lastName,
        String email,
        String phone,
        Id accountId
    ) {
        Contact newContact = new Contact(
            FirstName = firstName,
            LastName = lastName,
            Email = email,
            Phone = phone,
            AccountId = accountId
        );

        try {
            insert as user newContact;
        } catch (DmlException e) {
            throw new AuraHandledException(e.getDmlMessage(0));
        }
    }

    @AuraEnabled
    public static List<Contact> updateContacts(List<Contact> contacts) {
        try {
            update as user contacts;

            return [
                SELECT Id, FirstName, LastName, Email, Phone
                FROM Contact
                WHERE Id IN :contacts
                WITH USER_MODE
            ];
        } catch (DmlException e) {
            throw new AuraHandledException(e.getDmlMessage(0));
        }
    }
}