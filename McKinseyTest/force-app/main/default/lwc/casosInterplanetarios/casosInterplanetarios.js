import { LightningElement, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import getCasesData from '@salesforce/apex/CasosInterplanetariosCtr.getCasesData';

const CHANNEL = '/event/EmailCasesCreated__e';
const FIELD_SET_NAME = 'Casos_interplanetarios'; 
export default class CasosInterplanetarios extends LightningElement {
    cases;
    record;
    wiredCaseTableData;

    subscription = null;
    isModalOpen = false;
    fieldSetName = FIELD_SET_NAME;

    @wire(getCasesData)
    async wiredGetCaseData(wiredCaseData) {
        const { data, error } = wiredCaseData;
        this.wiredCaseTableData = wiredCaseData;
        if (data) {
            this.cases = data;
        } else if (error) {
            this.showToast('Error: ',error.message, 'error');
        }
    }

    connectedCallback() {
        this.subscribeToPlatformEvent();
    }

    disconnectedCallback() {
        this.unsubscribeFromPlatformEvent();
    }

    subscribeToPlatformEvent() {
        subscribe(CHANNEL, -1, (event) => {
            this.updateTableData(event);
        }).then((response) => {
            this.subscription = response;
        });

        onError((error) => {
            console.error('Error: ', JSON.stringify(error));
        });
    }

    unsubscribeFromPlatformEvent() {
        if (this.subscription) {
            unsubscribe(this.subscription);
            this.subscription = null;
        }
    }

    updateTableData(event) {
        refreshApex(this.wiredCaseTableData)
    }

    
    handleCaseClick(event) {
        event.preventDefault();
        const caseId = event.target.dataset.id;
        this.record = this.cases.find(c => c.id === caseId);
        this.isModalOpen = true;
    }

    handleCloseModal() {
        this.record = {};
        this.isModalOpen = false;
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}
