import { LightningElement, track } from 'lwc';
import getBreeds from '@salesforce/apex/DogApiService.getBreeds';

export default class DogSelectForm extends LightningElement {
    @track breeds = [];
    @track subBreeds = [];
    selectedBreed = '';
    selectedSubBreed = '';

    connectedCallback() {
        // Llamada Apex para obtener razas
        getBreeds()
            .then((result) => {
                this.breeds = Object.keys(result).map((key) => ({
                    label: key.charAt(0).toUpperCase() + key.slice(1),
                    value: key,
                    subBreeds: result[key],
                }));
            })
            .catch((error) => {
                console.error('Error fetching breeds:', error);
            });
    }

    handleBreedChange(event) {
        this.selectedBreed = event.target.value;
        const breed = this.breeds.find((b) => b.value === this.selectedBreed);
        this.subBreeds = breed ? breed.subBreeds.map((sb) => ({ label: sb, value: sb })) : [];
    }

    handleSubBreedChange(event) {
        this.selectedSubBreed = event.target.value;
    }

    handleGetDogs() {
        const eventDetail = {
            breed: this.selectedBreed,
            subBreed: this.selectedSubBreed,
        };
        this.dispatchEvent(new CustomEvent('getdogs', { detail: eventDetail }));
    }
}
