import { LightningElement, track } from 'lwc';
import getDirections from '@salesforce/apex/DirectionsController.getDirections';
import getPlaceAutocomplete from '@salesforce/apex/DirectionsController.getPlaceAutocomplete';

export default class DirectionsLWC extends LightningElement {
    @track origin = '';
    @track destination = '';
    @track originSuggestions = [];
    @track destinationSuggestions = [];
    @track directionsData;

    handleOriginChange(event) {
        this.origin = event.target.value;
    }
    @track mode = 'Driving';
    modeOptions = [
        { label: 'Driving', value: 'Driving' },
        { label: 'Walking', value: 'Walking' },
        { label: 'Transit', value: 'Transit' },
        { label: 'Bicycling', value: 'Bicycling' },
    ];

    handleModeChange(event) {
        this.mode = event.detail.value;
    }
    handleOriginKeyup(event) {
        getPlaceAutocomplete({ input: event.target.value})
        .then(result => {
            this.originSuggestions = result;
        })
        .catch(error => {
            console.error('Error in getting place autocomplete', error);
        });
    }

    handleOriginSuggestionClick(event) {
        this.origin = event.target.textContent;
        this.originSuggestions = []; // clear the suggestions
    }

    handleDestinationChange(event) {
        this.destination = event.target.value;
    }

    handleDestinationKeyup(event) {
        getPlaceAutocomplete({ input: event.target.value})
        .then(result => {
            this.destinationSuggestions = result;
        })
        .catch(error => {
            console.error('Error in getting place autocomplete', error);
        });
    }

    handleDestinationSuggestionClick(event) {
        this.destination = event.target.textContent;
        this.destinationSuggestions = []; // clear the suggestions
    }

    handleClick() {
        getDirections({ origin: this.origin, destination: this.destination,mode:this.mode})
        .then(result => {
            this.directionsData = result;
        })
        .catch(error => {
            console.error('Error in getting directions', error);
        });
    }
}