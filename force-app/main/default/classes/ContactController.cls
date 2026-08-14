public with sharing class ContactController {
    @AuraEnabled
    public static List<Contact> queryContacts(Id accountId) {
        return [
            SELECT Id, FirstName, LastName, Email, Phone
            FROM Contact
            WHERE AccountId  = :accountId   
        ];
    }

    @AuraEnabled
    public static void createContact(String firstName, String lastName, String email, String phone, Id accountId) {
        Contact newContact = new Contact(
            FirstName = firstName,
            LastName = lastName,
            Email = email,
            Phone = phone,
            AccountId = accountId
        );

        insert newContact;
    }
}