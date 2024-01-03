import { LightningElement, api, track } from 'lwc';
import getAllVehicleInfo from '@salesforce/apex/VinDecoderApi.getAllVehicleInfo';
import {FlowNavigationNextEvent,} from 'lightning/flowSupport';
export default class vinDecoder extends LightningElement {
    @track vinNumber = '';
    @api vehicle = {};
    @track error;
    @api
    availableActions = [];

    handleVinChange(event) {
        this.vinNumber = event.target.value.slice(0, 17);

        if (this.vinNumber.length === 17) {
            this.getAllVehicleInfo();
        }
    }

    getAllVehicleInfo() {
        getAllVehicleInfo({ vinNumber: this.vinNumber })
            .then(result => {
                this.vehicle = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.vehicle = {};
            });
    }

    handleSubmit() {
        if (this.availableActions.find((action) => action === 'NEXT')) {
            // navigate to the next screen
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }
    }
}
