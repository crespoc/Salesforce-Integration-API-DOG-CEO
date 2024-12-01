import { LightningElement, track } from 'lwc';
import getDogImages from '@salesforce/apex/DogApiService.getDogImages';
import saveFavorite from '@salesforce/apex/DogApiService.saveFavorite';
import getFavorites from '@salesforce/apex/DogApiService.getFavorites';
import deleteFavorite from '@salesforce/apex/DogApiService.deleteFavorite';

export default class DogViewer extends LightningElement {
    @track dogImages = [];
    @track favorites = [];
    favoritedUrls = new Set();
    isAlwaysFavorited = true;

    connectedCallback() {
        this.loadFavorites();
    }

    loadFavorites() {
        getFavorites()
            .then((result) => {
                this.favorites = result;
                this.favoritedUrls = new Set(result.map((fav) => fav.Image_URL__c));
            })
            .catch((error) => {
                console.error('Error loading favorites:', error);
            });
    }

    handleGetDogs(event) {
        const { breed, subBreed } = event.detail;
        getDogImages({ breed, subBreed })
            .then((images) => {
                this.dogImages = images.map((img) => ({
                    imgPath: img,
                    breed: subBreed ? `${subBreed} ${breed}` : breed,
                    isFavorited: this.favoritedUrls.has(img),
                }));
            })
            .catch((error) => {
                console.error('Error fetching dog images:', error);
            });
    }

    handleAddFavorite(event) {
        const { imgPath, breed } = event.detail;

        if (this.favoritedUrls.has(imgPath)) {
            deleteFavorite({ imageUrl: imgPath })
                .then(() => {
                    this.favoritedUrls.delete(imgPath);
                    this.favorites = this.favorites.filter((fav) => fav.Image_URL__c !== imgPath);
                    this.updateDogImagesFavorites();
                })
                .catch((error) => {
                    console.error('Error deleting favorite:', error);
                });
        } else {
            saveFavorite({ breed, imageUrl: imgPath })
                .then(() => {
                    this.favoritedUrls.add(imgPath);
                    this.favorites = [...this.favorites, { Name: breed, Image_URL__c: imgPath }];
                    this.updateDogImagesFavorites();
                })
                .catch((error) => {
                    console.error('Error saving favorite:', error);
                });
        }
    }

    updateDogImagesFavorites() {
        this.dogImages = this.dogImages.map((dog) => ({
            ...dog,
            isFavorited: this.favoritedUrls.has(dog.imgPath),
        }));
    }
}

