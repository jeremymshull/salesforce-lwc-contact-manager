import { LightningElement, api } from 'lwc';
import queryContacts from '@salesforce/apex/ContactController.queryContacts';
import updateContacts from '@salesforce/apex/ContactController.updateContacts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ContactWorkspace extends LightningElement {
  @api recordId;
  contacts = [];
  draftValues = [];
  columns = [
    { label: 'First Name', fieldName: 'FirstName', type: 'text', editable: true },
    { label: 'Last Name', fieldName: 'LastName', type: 'text', editable: true },
    { label: 'Phone', fieldName: 'Phone', type: 'phone', editable: true },
    { label: 'Email', fieldName: 'Email', type: 'email', editable: true }
  ];

  connectedCallback() {
    queryContacts({ accountId: this.recordId })
      .then(result => {
        this.contacts = result;
      })
      .catch(error => {
        this.showToast('Error Fetching Contacts', error.body?.message ?? 'Unknown error', 'error')
      })
  }

  handleSave(event) {
    this.draftValues = event.detail.draftValues;

    updateContacts({ contacts: this.draftValues })
      .then(result => {
        this.contacts = result;
        this.draftValues = [];

        this.showToast('Success!', 'Everything saved.', 'success');
      })
      .catch(error => {
        this.showToast('Error', error.body.message, 'error');
      })
  }

  handleCancel(event) {
    this.draftValues = [];
  }

  showToast(title, message, variant) {
    this.dispatchEvent(
      new ShowToastEvent({
        title,
        message,
        variant
      })
    );
  }

  handleNewContact(event) {
    this.contacts = [...this.contacts, event.detail];
  }
}