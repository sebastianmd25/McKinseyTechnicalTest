import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getFieldServiceForm from '@salesforce/apex/FieldSetService.getFieldServiceForm';
import interplanetaryScan from '@salesforce/apex/PlanetScannerService.scanAndCloseCase';

export default class CaseDataModal extends LightningElement {
    @api record;
    @api fieldSet;

    error;
    fields;
    isLoading = true;

    connectedCallback() {
        getFieldServiceForm({ recordId: this.record["id"], fieldSetName: this.fieldSet }).then(result => {
            if (result) {
                this.fields = result.fields.map(field => {
                    const formattedFieldName = this.toCamelCase(field.fieldName);
                    return {
                        ...field,
                        value: this.record[formattedFieldName] !== undefined ? this.record[formattedFieldName] : '',
                        type: field.fieldType === 'BOOLEAN' ? 'checkbox' : 'text',
                        disabled: field.fieldType === 'BOOLEAN' ? true : false
                    };
                });
            }
        }).catch(error => {
            this.showToast('Error:', error.message, 'error');
        }).finally(() => {
            this.isLoading = false;
        }); 
    }

    toCamelCase(fieldName) {
        const isCustomField = fieldName.endsWith('__c'); 
        let transformedName = fieldName
            .split('_')
            .map((word, index) => index === 0 ? word.toLowerCase() : word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
            .join('');
        
        if (isCustomField) {
            transformedName = transformedName.slice(0, -1);
        }

        return transformedName; 
    }

    async onSubmit() {
        this.isLoading = true;
        const caseId = this.record["id"];
        const planetAccessCode = this.record["planetAccessCode"];
        
        if (!planetAccessCode) {
            this.showToast('Error', 'El caso no tiene un código de acceso al planeta válido.', 'error');
            return;
        }
        
        try {
            const result = await interplanetaryScan({ caseId, planetAccessCode });
        
            if (result) {
                this.showToast('Escaneo Exitoso!!! ', 'Has econtrado a Yoda!!!', 'success');
            } else {
                this.showToast('Escaneo Finalizado', 'Yoda no se encuentra en este planeta.', 'info');
            }
        } catch (error) {
            const errorMsg = error.body ? error.body.message : error.message;
            this.showToast('Error en el escaneo interplanetario:', errorMsg, 'error');
        } finally {
            this.isLoading = false;
            this.refreshApexData();
            this.closeModal();
        }
    }
    

    closeModal() {
        this.closeModalEvent();
    }

    closeModalEvent() {
        const closeModalEvent = new CustomEvent('close', {
            detail:{
                data:  false
            }
        });
        this.dispatchEvent(closeModalEvent);
    }

    refreshApexData() {
        const refreshMetadata = new CustomEvent('refresh', {
            detail: {
                data: true
            }
        });
        this.dispatchEvent(refreshMetadata);
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