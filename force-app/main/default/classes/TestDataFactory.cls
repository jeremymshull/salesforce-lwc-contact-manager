@isTest
public class TestDataFactory {

    // ─── Accounts ─────────────────────────────────────────────────────────

    public static List<Account> createAccounts(Integer count, Boolean doInsert) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            accounts.add(new Account(
                Name = 'Test Account ' + i
            ));
        }
        if (doInsert) insert accounts;
        return accounts;
    }

    public static Account createAccount(Boolean doInsert) {
        return createAccounts(1, doInsert)[0];
    }

    // ─── Contacts ─────────────────────────────────────────────────────────

    public static List<Contact> createContacts(Account account, Integer count, Boolean doInsert) {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < count; i++) {
            contacts.add(new Contact(
                FirstName = 'Test',
                LastName  = 'Contact ' + i,
                Email     = 'test.contact' + i + '@example.com',
                Phone     = '555-000-' + String.valueOf(i).leftPad(4, '0'),
                AccountId = account.Id
            ));
        }
        if (doInsert) insert contacts;
        return contacts;
    }

    public static Contact createContact(Account account, Boolean doInsert) {
        return createContacts(account, 1, doInsert)[0];
    }
}
