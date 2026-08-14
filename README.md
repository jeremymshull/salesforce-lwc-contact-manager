# Real World LWC Project

## Project: Related Contacts Feature

This project implements a Related Contacts feature for Account record pages, allowing users to view, create, and inline-edit contacts directly from the Account detail page.

---

## Components

### `contactWorkspace` (Parent)
A Lightning Web Component placed on the Account record page via App Builder.

- **Target:** `lightning__RecordPage`
- **Receives:** `recordId` from the record page context
- **Responsibilities:**
  - Fetches all related contacts on load via `queryContacts`
  - Renders contacts in an editable `lightning-datatable`
  - Handles inline cell edits with draft values and saves via `updateContacts`
  - Fires success/error toast notifications for fetch and save operations
  - Listens for `newcontact` events from `contactInputForm` and appends the new contact to the table without re-querying

**Public API:**

| Property | Type | Description |
|---|---|---|
| `recordId` | `Id` | Injected automatically by the record page; used to scope contact queries to the current Account |

---

### `contactInputForm` (Child)
A form component embedded inside `contactWorkspace` for creating new contacts.

- **Target:** Not directly exposed (child component only)
- **Receives:** `accountId` from the parent
- **Responsibilities:**
  - Captures First Name, Last Name, Email, and Phone via `lightning-input` fields
  - Creates a new Contact record via `createContact` on button click
  - Fires a `newcontact` custom event with the new contact's field values so the parent table updates immediately
  - Clears all fields after a successful save
  - Fires success/error toast notifications for create operations

**Public API:**

| Property | Type | Description |
|---|---|---|
| `accountId` | `Id` | The Account Id to associate the new contact with |

**Events fired:**

| Event | Detail | Description |
|---|---|---|
| `newcontact` | `{ FirstName, LastName, Phone, Email }` | Fired after a successful contact insert so the parent datatable updates without a re-query |

---

## Apex

### `ContactController`
Server-side controller for all contact data operations.

| Method | Signature | Description |
|---|---|---|
| `queryContacts` | `List<Contact> queryContacts(Id accountId)` | Returns all contacts for the given Account, selecting `Id`, `FirstName`, `LastName`, `Email`, `Phone` |
| `createContact` | `void createContact(String firstName, String lastName, String email, String phone, Id accountId)` | Inserts a new Contact record linked to the given Account |
| `updateContacts` | `List<Contact> updateContacts(List<Contact> contacts)` | Bulk-updates the provided contacts and returns the refreshed records |

All methods use `with sharing` for record-level security enforcement.

---

### `ContactControllerTest`
Apex test class covering all three `ContactController` methods.

| Test Method | Scenario |
|---|---|
| `shouldReturnContacts_WhenValidAccountId` | Returns all 251 seeded contacts with expected field values |
| `shouldReturnEmpty_WhenAccountHasNoContacts` | Returns empty list for an account with no contacts |
| `shouldReturnEmpty_WhenAccountIdIsNull` | Returns empty list when null is passed as the account ID |
| `shouldCreateContact_WhenValidInput` | Inserts a contact and verifies all field values |
| `shouldThrowException_WhenLastNameIsNull` | Throws `DmlException` when required `LastName` is omitted |
| `shouldUpdateContacts_WhenValidInput` | Updates 5 contacts and verifies returned field values |
| `shouldUpdateContacts_WhenBulk251Records` | Bulk-updates 251 contacts across the trigger batch boundary |
| `shouldReturnEmpty_WhenUpdateCalledWithEmptyList` | Returns empty list when an empty list is passed |

---

### `TestDataFactory`
Shared test data factory used by all test classes.

| Method | Description |
|---|---|
| `createAccounts(Integer count, Boolean doInsert)` | Creates and optionally inserts a list of Accounts |
| `createAccount(Boolean doInsert)` | Creates and optionally inserts a single Account |
| `createContacts(Account account, Integer count, Boolean doInsert)` | Creates and optionally inserts contacts linked to the given Account |
| `createContact(Account account, Boolean doInsert)` | Creates and optionally inserts a single contact linked to the given Account |

---

## Deployment

Deploy all metadata to your org:

```bash
sf project deploy start --source-dir force-app/main/default --target-org <your-alias>
```

Run the Apex test suite:

```bash
sf apex run test --class-names ContactControllerTest --result-format human --code-coverage --target-org <your-alias>
```

After deploying, add `contactWorkspace` to the Account record page via **Setup > Lightning App Builder**.
