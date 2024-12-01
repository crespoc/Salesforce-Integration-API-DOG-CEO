import { LightningElement, api } from 'lwc';

export default class DogCard extends LightningElement {
    @api imgPath;
    @api breed;
    @api isFavorited = false;

    handleFavoriteClick() {
        const favoriteEvent = new CustomEvent('addfavorite', {
            detail: { imgPath: this.imgPath, breed: this.breed },
        });
        this.dispatchEvent(favoriteEvent);
    }
}
