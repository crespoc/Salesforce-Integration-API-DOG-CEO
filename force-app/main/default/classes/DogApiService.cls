public with sharing class DogApiService {
    
    private static final String BASE_URL = 'https://dog.ceo/api/';

    @AuraEnabled(cacheable=true)
    public static Map<String, List<String>> getBreeds() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(BASE_URL + 'breeds/list/all');
        request.setMethod('GET');

        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            if (results.get('status') == 'success') {
                // Obtener el valor de 'message' que es un Map<String, Object>
                Object breedsData = results.get('message');
                if (breedsData instanceof Map<String, Object>) {
                    Map<String, Object> breedsMap = (Map<String, Object>) breedsData;
                    // Convertir las claves y valores del mapa a Map<String, List<String>>
                    Map<String, List<String>> breeds = new Map<String, List<String>>();
                    for (String breed : breedsMap.keySet()) {
                        // Convertir la lista de subrazas a List<String>
                        List<Object> subBreedList = (List<Object>) breedsMap.get(breed);
                        List<String> subBreeds = new List<String>();
                        for (Object subBreed : subBreedList) {
                            subBreeds.add((String) subBreed);
                        }
                        breeds.put(breed, subBreeds);
                    }
                    return breeds;
                }
            }
        }
        throw new CalloutException('Error fetching breeds: ' + response.getBody());
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getDogImages(String breed, String subBreed) {
        if (String.isEmpty(breed)) {
            throw new IllegalArgumentException('Breed is required');
        }

        String endpoint = BASE_URL + 'breed/' + breed.toLowerCase();
        if (!String.isEmpty(subBreed)) {
            endpoint += '/' + subBreed.toLowerCase();
        }
        endpoint += '/images';

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');

        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            if (results.get('status') == 'success') {
                // Convertir la lista de URLs de imágenes a List<String>
                List<Object> imagesData = (List<Object>) results.get('message');
                List<String> images = new List<String>();
                for (Object image : imagesData) {
                    images.add((String) image);
                }
                return images;
            }
        }
        throw new CalloutException('Error fetching dog images: ' + response.getBody());
    }

    @AuraEnabled
    public static void saveFavorite(String breed, String imageUrl) {
        if (String.isEmpty(breed) || String.isEmpty(imageUrl)) {
            throw new IllegalArgumentException('Breed and Image URL are required');
        }
        Dog_Favorite__c favorite = new Dog_Favorite__c();
        favorite.Name = breed;
        favorite.Image_URL__c = imageUrl;
        insert favorite;
    }

    @AuraEnabled(cacheable=true)
    public static List<Dog_Favorite__c> getFavorites() {
        return [SELECT Name, Image_URL__c FROM Dog_Favorite__c];
    }

    @AuraEnabled
    public static void deleteFavorite(String imageUrl) {
        List<Dog_Favorite__c> records = [
            SELECT Id FROM Dog_Favorite__c WHERE Image_URL__c = :imageUrl LIMIT 1
        ];
        if (!records.isEmpty()) {
            delete records;
        }
    }

}
