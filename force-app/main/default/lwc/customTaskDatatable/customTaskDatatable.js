import { LightningElement, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getTasks from '@salesforce/apex/TaskController.getTasks';
import getTaskStatusPicklistValues from '@salesforce/apex/TaskController.getTaskStatusPicklistValues';
import getTaskPriorityPicklistValues from '@salesforce/apex/TaskController.getTaskPriorityPicklistValues';
import updateTaskStatusToCompleted from '@salesforce/apex/TaskController.updateTaskStatusToCompleted';
import updateTasksInlineEdit from '@salesforce/apex/TaskController.updateTasksInlineEdit';
import createTask from '@salesforce/apex/TaskController.createTask';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from "lightning/navigation";

const cols = [
    { label: 'Subject', fieldName: 'Subject', type: 'text', sortable: true, editable: true },
    { label: 'Due Date', fieldName: 'ActivityDate', type: 'Date', type: 'date',
        typeAttributes: {
            year: 'numeric',
            month: 'numeric',
            day: 'numeric'
        }
    },
    {
        label: 'Status',
        fieldName: 'Status',
        wrapText: true,
        type: 'customPicklistStatus',
        editable: true,
        sortable: true,
        typeAttributes: {
            options: { fieldName: 'picklistOptions' },
            value: { fieldName: 'Status' },
            placeholder: 'Choose Status',
            context: { fieldName: 'Id' }
        }
    }
];

export default class CustomTaskDatatable extends NavigationMixin(LightningElement) {
    showSpinner = false;
    wiredTasksResult;
    wiredTaskStatusPicklist = [];
    draftValues = [];
    columns = cols;
    error;
    taskDataFull;

    // Modal params
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
        } else {
            this.wiredTaskPriorityPicklist = undefined;
        }
    }

    @wire(getTaskStatusPicklistValues)
    wiredPicklistValues(result) {
        this.wiredPicklistValuesResult = result;
        if (result.data) {
            this.wiredTaskStatusPicklist = result.data.map(value => ({ label: value, value }));
            this.error = undefined;
        } else {
            this.wiredTaskStatusPicklist = undefined;
        }
    }

    @wire(getTasks)
    taskData(result) {
        this.taskDataFull = result;
        if (result.data) {
            let options = [];
            for (var key in this.wiredTaskStatusPicklist) {
                options.push({ label: this.wiredTaskStatusPicklist[key].label, value: this.wiredTaskStatusPicklist[key].value });
            }
            this.wiredTasksResult = result.data.map((record) => {
                return { ...record, 'picklistOptions': options }
            });
            this.previousStoreData = JSON.parse(JSON.stringify(this.wiredTasksResult));
        } else if (result.error) {
            this.wiredTasksResult = undefined;
            console.error('Error fetching tasks: ' + result.error);
        }
    }

    handleSort(event) {
        const { fieldName, sortDirection } = event.detail;
        this.sortedBy = fieldName;
        this.sortedDirection = sortDirection;

        let sortedData = [...this.wiredTasksResult];

        if (fieldName === 'Subject') {
            sortedData.sort((a, b) => {
                const nameA = a.Subject.toUpperCase();
                const nameB = b.Subject.toUpperCase();
                return sortDirection === 'asc' ? nameA.localeCompare(nameB) : nameB.localeCompare(nameA);
            });
        } else if (fieldName === 'Status') {
            sortedData.sort((a, b) => {
                const statusA = a.Status.toUpperCase();
                const statusB = b.Status.toUpperCase();
                return sortDirection === 'asc' ? statusA.localeCompare(statusB) : statusB.localeCompare(statusA);
            });
        }

        this.wiredTasksResult = sortedData;
        this.refresh();
    }

    updateDraftValues(updateItem) {
        let draftValueChanged = false;
        let copyDraftValues = [...this.draftValues];

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

    handleCellChange(event) {
        let draftValues = event.detail.draftValues;
        draftValues.forEach(ele => {
            this.updateDraftValues(ele);
        });
    }

    handleSave() {
        this.showSpinner = true;

        const recordsToSave = this.draftValues.map((draft) => {
            return {
                Id: draft.Id,
                Status: draft.Status,
                Subject: draft.Subject,
            };
        });

        if (recordsToSave.length > 0) {
            updateTasksInlineEdit({ tasksToUpdate: recordsToSave })
                .then((result) => {
                    if (!result) {
                        this.showToast('Success', 'Changes saved successfully!', 'success', 'dismissable');
                        this.draftValues = [];
                        this.refresh();
                    } else {
                        this.showToast('Error', result, 'error', 'dismissable');
                    }
                })
                .catch((error) => {
                    console.error('Error updating tasks:', error);
                    this.showToast('Error', 'An error occurred while saving changes.', 'error', 'dismissable');
                })
                .finally(() => {
                    this.showSpinner = false;
                });
        } else {
            this.showSpinner = false;
            this.showToast('Info', 'No changes to save.', 'info', 'dismissable');
        }
    }

    handleCancel(event) {
        this.wiredTasksResult = JSON.parse(JSON.stringify(this.previousStoreData));
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
        if (this.selectedRows.length > 0) {
            this.updateTaskStatusToCompleted(this.selectedRows.map(row => row.Id));
        } else {
            this.showToast('Info', 'No rows selected.', 'info', 'dismissable');
        }
    }

    updateTaskStatusToCompleted(taskIds) {
        updateTaskStatusToCompleted({ taskIds })
            .then(() => {
                this.showToast('Success', 'Selected records updated to Completed.', 'success', 'dismissable');
                this.refresh();
            })
            .catch(error => {
                console.error('Error updating records:', error);
                this.showToast('Error', 'An error occurred while updating records.', 'error', 'dismissable');
            });
    }
}