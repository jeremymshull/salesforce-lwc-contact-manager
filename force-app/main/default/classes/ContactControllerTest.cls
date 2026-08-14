@isTest
private class ContactControllerTest {

    @TestSetup
    static void setupTestData() {
        Account acc = TestDataFactory.createAccount(true);
        TestDataFactory.createContacts(acc, 251, true);
    }

    // ─── queryContacts ────────────────────────────────────────────────────

    @isTest
    static void shouldReturnContacts_WhenValidAccountId() {
        // Given
        Account acc = [SELECT Id FROM Account LIMIT 1];

        // When
        Test.startTest();
        List<Contact> result = ContactController.queryContacts(acc.Id);
        Test.stopTest();

        // Then
        Assert.areEqual(251, result.size(), 'Should return all 251 contacts for the account');
        Assert.isNotNull(result[0].FirstName, 'FirstName should be populated');
        Assert.isNotNull(result[0].LastName,  'LastName should be populated');
        Assert.isNotNull(result[0].Email,     'Email should be populated');
        Assert.isNotNull(result[0].Phone,     'Phone should be populated');
    }

    @isTest
    static void shouldReturnEmpty_WhenAccountHasNoContacts() {
        // Given
        Account emptyAcc = TestDataFactory.createAccount(true);

        // When
        Test.startTest();
        List<Contact> result = ContactController.queryContacts(emptyAcc.Id);
        Test.stopTest();

        // Then
        Assert.isTrue(result.isEmpty(), 'Should return empty list for account with no contacts');
    }

    @isTest
    static void shouldReturnEmpty_WhenAccountIdIsNull() {
        // When
        Test.startTest();
        List<Contact> result = ContactController.queryContacts(null);
        Test.stopTest();

        // Then
        Assert.isTrue(result.isEmpty(), 'Should return empty list when accountId is null');
    }

    // ─── createContact ────────────────────────────────────────────────────

    @isTest
    static void shouldCreateContact_WhenValidInput() {
        // Given
        Account acc = [SELECT Id FROM Account LIMIT 1];

        // When
        Test.startTest();
        ContactController.createContact('Jane', 'Doe', 'jane@example.com', '555-1234', acc.Id);
        Test.stopTest();

        // Then
        List<Contact> contacts = [
            SELECT FirstName, LastName, Email, Phone, AccountId
            FROM Contact
            WHERE AccountId = :acc.Id AND LastName = 'Doe'
        ];
        Assert.areEqual(1, contacts.size(), 'One new contact should have been created');
        Assert.areEqual('Jane',             contacts[0].FirstName, 'FirstName should match');
        Assert.areEqual('Doe',              contacts[0].LastName,  'LastName should match');
        Assert.areEqual('jane@example.com', contacts[0].Email,     'Email should match');
        Assert.areEqual('555-1234',         contacts[0].Phone,     'Phone should match');
        Assert.areEqual(acc.Id,             contacts[0].AccountId, 'AccountId should match');
    }

    @isTest
    static void shouldThrowException_WhenLastNameIsNull() {
        // Given
        Account acc = [SELECT Id FROM Account LIMIT 1];

        // When / Then
        Test.startTest();
        try {
            ContactController.createContact('Jane', null, 'jane@example.com', '555-1234', acc.Id);
            Assert.fail('Expected DmlException for missing required LastName');
        } catch (DmlException e) {
            Assert.isTrue(
                e.getMessage().contains('REQUIRED_FIELD_MISSING') || e.getMessage().contains('LastName'),
                'Exception should indicate LastName is required: ' + e.getMessage()
            );
        }
        Test.stopTest();
    }

    // ─── updateContacts ───────────────────────────────────────────────────

    @isTest
    static void shouldUpdateContacts_WhenValidInput() {
        // Given
        Account acc = [SELECT Id FROM Account LIMIT 1];
        List<Contact> contacts = [SELECT Id, FirstName, LastName, Email, Phone FROM Contact WHERE AccountId = :acc.Id LIMIT 5];
        for (Contact c : contacts) {
            c.Phone = '999-9999';
        }

        // When
        Test.startTest();
        List<Contact> result = ContactController.updateContacts(contacts);
        Test.stopTest();

        // Then
        Assert.areEqual(5, result.size(), 'Should return all 5 updated contacts');
        for (Contact c : result) {
            Assert.areEqual('999-9999', c.Phone, 'Phone should be updated to 999-9999 for contact ' + c.Id);
        }
    }

    @isTest
    static void shouldUpdateContacts_WhenBulk251Records() {
        // Given
        Account acc = [SELECT Id FROM Account LIMIT 1];
        List<Contact> contacts = [SELECT Id, Phone FROM Contact WHERE AccountId = :acc.Id];
        Assert.areEqual(251, contacts.size(), 'Should have 251 contacts for bulk test');
        for (Contact c : contacts) {
            c.Phone = '888-8888';
        }

        // When
        Test.startTest();
        List<Contact> result = ContactController.updateContacts(contacts);
        Test.stopTest();

        // Then
        Assert.areEqual(251, result.size(), 'Should return all 251 updated contacts');
        for (Contact c : result) {
            Assert.areEqual('888-8888', c.Phone, 'Phone should be updated for contact ' + c.Id);
        }
    }

    @isTest
    static void shouldReturnEmpty_WhenUpdateCalledWithEmptyList() {
        // When
        Test.startTest();
        List<Contact> result = ContactController.updateContacts(new List<Contact>());
        Test.stopTest();

        // Then
        Assert.isTrue(result.isEmpty(), 'Should return empty list when passed an empty list');
    }
}
