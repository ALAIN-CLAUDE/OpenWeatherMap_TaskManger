import { LightningElement, wire , track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getTasks from '@salesforce/apex/TaskController.getTasks';
import getTaskStatusPicklistValues from '@salesforce/apex/TaskController.getTaskStatusPicklistValues';
import getTaskPriorityPicklistValues from '@salesforce/apex/TaskController.getTaskPriorityPicklistValues';
import updateTaskStatusToCompleted from '@salesforce/apex/TaskController.updateTaskStatusToCompleted';
import updateTasks from '@salesforce/apex/TaskController.updateTasks'; 
import createTask from '@salesforce/apex/TaskController.createTask';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from "lightning/navigation";



const cols = [
    { label: 'Subject', fieldName: 'Subject', type: 'text', sortable: true,editable: true, },
    { label: 'Due Date', fieldName: 'ActivityDate', type: 'Date', type: 'date', 
    typeAttributes: {
        year: 'numeric',
        month: 'numeric',
        day: 'numeric'
    }},
    {
        label: 'Status',
        fieldName: 'Status',
        wrapText: true,
        type: 'customPicklistStatus',
        editable: true,
        sortable: true,
        typeAttributes: {
            options:  { fieldName: 'picklistOptions'},
            value: { fieldName: 'Status' },
            placeholder: 'Choose Status',
            context: { fieldName: 'Id' }

        }
    }
];

export default class CustomTaskDatatable extends NavigationMixin(LightningElement){
    showSpinner = false;
    wiredTasksResult;
    wiredTaskStatusPicklist =[];
    draftValues = [];
    columns =cols;
    error;
    taskDataFull;
    //modal params
    @track showNewTaskModal = false;
    @track newTaskSubject = '';
    @track newTaskDueDate = '';
    @track newTaskPriority = '';
    wiredTaskPriorityPicklist = [];
    sortedBy;
sortedDirection;


    @wire(getTaskPriorityPicklistValues)
    wiredPicklistPriorityValues(result) {
        if (result.data) {
            this.wiredTaskPriorityPicklist = result.data.map(value => ({ label: value, value }));
            console.log('this.wiredTaskPriorityPicklist ===> ' + JSON.stringify(this.wiredTaskPriorityPicklist));
        } else {
            console.log('error ===> ' + JSON.stringify(result));
            this.wiredTaskPriorityPicklist = undefined;
        }
    }

    handleNewButton() {
        this.showNewTaskModal = true;
    }

    handleSaveNewTaskModal(event) {
        const newTask = event.detail;
        console.log('from modal cmp event newTask===> ' + JSON.stringify(newTask));

        // Add logic to create a new task
        createTask({ newTask })
            .then(() => {
                this.showToast('Success', 'New Task Created Successfully!', 'success', 'dismissable');
                this.showNewTaskModal = false;
                this.refresh();
            })
            .catch(error => {
                console.error('Error creating new task:', error);
                console.log('task new error===> ' + JSON.stringify(error));
                this.showToast('Error', 'An error occurred while creating a new task.', 'error', 'dismissable');
            });
    }

    handleCancelNewTaskModal() {
        this.showNewTaskModal = false;
    }


    @wire(getTaskStatusPicklistValues)
    wiredPicklistValues(result) {
        this.wiredPicklistValuesResult = result;
        if (result.data) {
            this.wiredTaskStatusPicklist = result.data.map(value => ({ label: value, value }));
            console.log('this.wiredTaskStatusPicklist ===> ' + JSON.stringify(this.wiredTaskStatusPicklist));
            //this.fetchUserTasks();
            this.error = undefined;
          } else{
           
            console.log('error ===> ' + JSON.stringify(result));
            this.wiredTaskStatusPicklist = undefined;
          }
    }



    @wire(getTasks)
    taskData(result) {
        this.taskDataFull = result;
        console.log('this.wiredTaskStatusPicklist22   ===> ' + JSON.stringify(this.wiredTaskStatusPicklist));
        console.log('this.taskDataFull22   ===> ' + JSON.stringify(this.taskDataFull));
        if (result.data) {
            let options = [];
            for (var key in this.wiredTaskStatusPicklist) {
                options.push({ label: this.wiredTaskStatusPicklist[key].label, value: this.wiredTaskStatusPicklist[key].value });
            }
            // Access result.data instead of result directly
            this.wiredTasksResult = result.data.map((record) => {
                return { ...record, 'picklistOptions': options }
            });
            this.previousStoreData = JSON.parse(JSON.stringify(this.wiredTasksResult));
        } else if (result.error) {
            this.wiredTasksResult = undefined;
            // Handle errors here
            console.error('Error fetching tasks: ' + result.error);
        }
    }

    // Add this method to handle sorting
    handleSort(event) {
        const { fieldName, sortDirection } = event.detail;
        // Update the sortedBy and sortedDirection properties
        this.sortedBy = fieldName;
        this.sortedDirection = sortDirection;
    
        // Clone the data to a new array for sorting
        let sortedData = [...this.wiredTasksResult];
    
        // Implement sorting logic based on the column
        if (fieldName === 'Subject') {
            // Sort by Name (Subject)
            sortedData.sort((a, b) => {
                const nameA = a.Subject.toUpperCase();
                const nameB = b.Subject.toUpperCase();
                return sortDirection === 'asc' ? nameA.localeCompare(nameB) : nameB.localeCompare(nameA);
            });
        } else if (fieldName === 'Status') {
            // Sort by Status
            sortedData.sort((a, b) => {
                const statusA = a.Status.toUpperCase();
                const statusB = b.Status.toUpperCase();
                return sortDirection === 'asc' ? statusA.localeCompare(statusB) : statusB.localeCompare(statusA);
            });
        }
    
        // Update the original data with the sorted data
        this.wiredTasksResult = sortedData;
    
        // Optionally, you can refresh the table or handle sorting in a different way based on your needs
        this.refresh();
    }
    

updateDraftValues(updateItem) {
    let draftValueChanged = false;
    let copyDraftValues = [...this.draftValues];
    //store changed value to do operations
    //on save. This will enable inline editing &
    //show standard cancel & save button
    copyDraftValues.forEach(item => {
        if (item.Id === updateItem.Id) {
            for (let field in updateItem) {
                item[field] = updateItem[field];
            }
            draftValueChanged = true;
        }
    });

    if (draftValueChanged) {
        this.draftValues = [...copyDraftValues];
    } else {
        this.draftValues = [...copyDraftValues, updateItem];
    }
}
 //handler to handle cell changes & update values in draft values
 handleCellChange(event) {
    //this.updateDraftValues(event.detail.draftValues[0]);
    let draftValues = event.detail.draftValues;
    console.log('draft===> '+JSON.stringify(draftValues));
    draftValues.forEach(ele=>{
        this.updateDraftValues(ele);
    })
}

handleSave() {
    // Show spinner to indicate that the save operation is in progress
    this.showSpinner = true;

    // Extract draft values and prepare them for saving
    const recordsToSave = this.draftValues.map((draft) => {
        return {
            Id: draft.Id,
            Status:draft.Status,
            Subject:draft.Subject,
        };
    });

    if (recordsToSave.length > 0) {
        // Call Apex method to update tasks
        updateTasks({ tasksToUpdate: recordsToSave })
            .then((result) => {
                if (!result) {
                    this.showToast('Success', 'Changes saved successfully!', 'success', 'dismissable');
                    this.draftValues = []; // Clear draft values after successful save
                    this.refresh();
                } else {
                    this.showToast('Error', result, 'error', 'dismissable');
                }
            })
            .catch((error) => {
                console.log('error====>  '+ JSON.stringify(error));
                console.error('Error updating tasks:', error);
                this.showToast('Error', 'An error occurred while saving changes.', 'error', 'dismissable');
            })
            .finally(() => {
                // Hide the spinner after the save operation is complete
                this.showSpinner = false;
            });
    } else {
        // Hide the spinner if there are no changes to save
        this.showSpinner = false;
        this.showToast('Info', 'No changes to save.', 'info', 'dismissable');
    }
}


handleCancel(event) {
    console.log('in calcel');
    //remove draftValues & revert data changes
    this.wiredTasksResult = JSON.parse(JSON.stringify(this.previousStoreData ));
    this.draftValues = [];
    this.refresh();
}


showToast(title, message, variant, mode) {
    const evt = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
        mode: mode
    });
    this.dispatchEvent(evt);
}
 // This function is used to refresh the table once data updated
 
 async refresh() {
    this.showSpinner = true;

    await refreshApex(this.taskDataFull)
        .then(() => {
            this.showSpinner = false;
        })
        .catch(error => {
            this.showSpinner = false;
            console.error('Error refreshing table:', error);
            this.showToast('Error', 'An error occurred while refreshing the table.', 'error', 'dismissable');
        });
}


handleRowSelection(event) {
    this.selectedRows = event.detail.selectedRows;
}

handleSelectedRows() {
    // Call Apex method to update selected tasks to Completed
    if (this.selectedRows.length > 0) {
        console.log('selected rows===> ' + JSON.stringify(this.selectedRows));
        this.updateTaskStatusToCompleted(this.selectedRows.map(row => row.Id));
    } else {
        // Show a toast if no rows are selected
        this.showToast('Info', 'No rows selected.', 'info', 'dismissable');
    }
}

updateTaskStatusToCompleted(taskIds) {
    // Call the Apex method to update task statuses to Completed
    updateTaskStatusToCompleted({taskIds})
        .then(() => {
            this.showToast('Success', 'Selected records updated to Completed.', 'success', 'dismissable');
            // Use the result variable if needed
            this.refresh();
        })
        .catch(error => {
            console.error('Error updating records:', error);
            this.showToast('Error', 'An error occurred while updating records.', 'error', 'dismissable');
        });
}










}