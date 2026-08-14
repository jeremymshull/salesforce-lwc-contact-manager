import { LightningElement, api } from 'lwc';
import createContact from '@salesforce/apex/ContactController.createContact';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ContactInputForm extends LightningElement {
  @api accountId;
  firstName = '';
  lastName = '';
  phone = '';
  email = '';

  handleInputChange(event) {
    this[event.target.name] = event.target.value;  
  }

  handleNewContact(event) {
    createContact({ 
      firstName: this.firstName, 
      lastName: this.lastName, 
      phone: this.phone, 
      email: this.email, 
      accountId: this.accountId 
    }) 
    .then(() => { 
      this.dispatchEvent( 
        new CustomEvent('newcontact', { 
          detail: { 
            FirstName: this.firstName, 
            LastName: this.lastName, 
            Phone: this.phone, 
            Email: this.email 
          } 
        }) 
      );

      this.clearFields();
      
      this.showToast('Success!', 'Contact created successfully!', 'success');
    }) 
    .catch(error => { 
      this.showToast('Error', error.body?.message ?? 'Unknown error', 'error');
      console.error('Error saving contact:', error); 
    }) 
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
  
  clearFields() { 
    this.firstName = ''; 
    this.lastName = ''; 
    this.phone = ''; 
    this.email = ''; 
  }
}