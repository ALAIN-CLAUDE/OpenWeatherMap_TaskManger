// newTaskModal.js
import { LightningElement, api } from 'lwc';

export default class NewTaskModal extends LightningElement {
    @api subject = '';
    @api dueDate = '';
    @api priority = '';
    @api picklistOptions = [];

  

    handlePriorityChange(event) {
        this.priority = event.detail.value;
    }
    handleCancel() {
        this.dispatchEvent(new CustomEvent('cancel'));
    }

    handleSave() {
        const newTask = {
            Subject: this.subject,
            ActivityDate: this.dueDate,
            Priority: this.priority
        };

        console.log('the  newTask before dispact===> ' + JSON.stringify(newTask));
        this.dispatchEvent(new CustomEvent('save', { detail: newTask }));
    }

    handleSubjectChange(event) {
        this.subject = event.target.value;
    }

    handleDueDateChange(event) {
        this.dueDate = event.target.value;
    }

}