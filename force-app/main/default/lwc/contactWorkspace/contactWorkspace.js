import { LightningElement, api } from 'lwc';
import queryContacts from '@salesforce/apex/ContactController.queryContacts';

export default class ContactWorkspace extends LightningElement {
  @api recordId;
  contacts = [];

  columns = [
    { label: 'First Name', fieldName: 'FirstName', type: 'text' },
    { label: 'Last Name', fieldName: 'LastName', type: 'text' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' },
    { label: 'Email', fieldName: 'Email', type: 'email' },
  ];

  connectedCallback() {
    queryContacts({ accountId: this.recordId })
      .then(result => {
        this.contacts = result;
      })
      .catch(error => {
        console.error('Error fetching contacts:', error)
      })
  }

  handleNewContact(event) {
    this.contacts = [...this.contacts, event.detail];
  }
}