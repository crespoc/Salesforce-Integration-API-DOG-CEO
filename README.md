# Dog Viewer App Salesforce Integration

## Description  
The **Dog Viewer App** is a Salesforce integration project designed for dog enthusiasts to explore dog breeds and sub-breeds, view images of their favorites, and save those images into a custom object in Salesforce. The app leverages Lightning Web Components (LWC) and Apex to fetch data from the Dog API (`https://dog.ceo/api`) and allows users to save their favorite dog pictures for future reference.  

## Apex Classes  
- **DogApiService**:  
  Handles API calls to the Dog API to fetch the list of breeds, sub-breeds, and images for a selected breed/sub-breed.  

## Lightning Web Components  
1. **DogViewer**:  
   The main component that includes two tabs:  
   - **Dogs!**: Displays the fetched dog images and allows favoriting.  
   - **Favorites**: Displays the favorited dog images and allows un-favoriting.  

2. **DogSelectForm**:  
   A form where users can select a breed and sub-breed, then fetch related dog images.  

3. **DogCard**:  
   A card component that displays individual dog images, breed names, and allows users to favorite/unfavorite images.  

## Custom Object  
- **Dog_Favorite__c**:  
  A custom Salesforce object used to store favorited dog images.  
  - **Fields**:  
    - **Name**: Stores the breed name of the dog.  
    - **Image_URL__c**: Stores the URL of the dog image.  

## Features  
- Fetches a list of dog breeds and sub-breeds from the Dog API.  
- Displays images of dogs based on user selection.  
- Allows favoriting and unfavoriting of dog images.  
- Saved favorites are stored in the `Dog_Favorite__c` custom object.  
- UI dynamically updates to reflect favorite states without reloading the page.  

## Installation and Setup  
1. Clone the repository:  
   ```bash
   git clone <repository-url>
