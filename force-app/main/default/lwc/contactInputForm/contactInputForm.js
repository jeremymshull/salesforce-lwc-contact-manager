import { LightningElement, api } from 'lwc';
import saveContact from '@salesforce/apex/ContactController.saveContact';

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
    saveContact({ 
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
    }) 
    .catch(error => { 
      console.error('Error saving contact:', error); 
    }) 
  } 
  
  clearFields() { 
    this.firstName = ''; 
    this.lastName = ''; 
    this.phone = ''; 
    this.email = ''; 
  }
}