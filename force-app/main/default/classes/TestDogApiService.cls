@IsTest
public class TestDogApiService {

    @IsTest
    static void testGetBreeds_Success() {
        String mockResponse = '{"status":"success","message":{"hound":["afghan","basset"],"bulldog":["french","english"]}}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, mockResponse));

        Test.startTest();
        Map<String, List<String>> breeds = DogApiService.getBreeds();
        Test.stopTest();

        System.assertEquals(2, breeds.size());
        System.assert(breeds.containsKey('hound'));
        System.assert(breeds.containsKey('bulldog'));
    }

    @IsTest
    static void testGetBreeds_Error() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(500, 'Internal Server Error'));

        Test.startTest();
        try {
            DogApiService.getBreeds();
            System.assert(false, 'Se esperaba una excepción CalloutException');
        } catch (CalloutException e) {
            System.assert(e.getMessage().contains('Error fetching breeds'));
        }
        Test.stopTest();
    }

    @IsTest
    static void testGetDogImages_Success() {
        String breed = 'hound';
        String subBreed = 'afghan';
        String mockResponse = '{"status":"success","message":["url1","url2"]}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, mockResponse));

        Test.startTest();
        List<String> images = DogApiService.getDogImages(breed, subBreed);
        Test.stopTest();

        System.assertEquals(2, images.size());
        System.assert(images.contains('url1'));
        System.assert(images.contains('url2'));
    }

    @IsTest
    static void testGetDogImages_IllegalArgumentException() {
        Test.startTest();
        try {
            DogApiService.getDogImages('', '');
            System.assert(false, 'Se esperaba una excepción IllegalArgumentException');
        } catch (IllegalArgumentException e) {
            System.assertEquals('Breed is required', e.getMessage());
        }
        Test.stopTest();
    }

    @IsTest
    static void testGetDogImages_CalloutException() {
        String breed = 'hound';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(500, 'Internal Server Error'));

        Test.startTest();
        try {
            DogApiService.getDogImages(breed, '');
            System.assert(false, 'Se esperaba una excepción CalloutException');
        } catch (CalloutException e) {
            System.assert(e.getMessage().contains('Error fetching dog images'));
        }
        Test.stopTest();
    }

    @IsTest
    static void testSaveFavorite() {
        Test.startTest();
        DogApiService.saveFavorite('hound', 'http://example.com/image.jpg');
        Test.stopTest();

        Dog_Favorite__c favorite = [SELECT Name, Image_URL__c FROM Dog_Favorite__c LIMIT 1];
        System.assertEquals('hound', favorite.Name);
        System.assertEquals('http://example.com/image.jpg', favorite.Image_URL__c);
    }

    @IsTest
    static void testSaveFavorite_IllegalArgumentException() {
        Test.startTest();
        try {
            DogApiService.saveFavorite('', '');
            System.assert(false, 'Se esperaba una excepción IllegalArgumentException');
        } catch (IllegalArgumentException e) {
            System.assertEquals('Breed and Image URL are required', e.getMessage());
        }
        Test.stopTest();
    }

    @IsTest
    static void testGetFavorites() {
        Dog_Favorite__c favorite = new Dog_Favorite__c(Name = 'bulldog', Image_URL__c = 'http://example.com/bulldog.jpg');
        insert favorite;

        Test.startTest();
        List<Dog_Favorite__c> favorites = DogApiService.getFavorites();
        Test.stopTest();

        System.assertEquals(1, favorites.size());
        System.assertEquals('bulldog', favorites[0].Name);
        System.assertEquals('http://example.com/bulldog.jpg', favorites[0].Image_URL__c);
    }

    @IsTest
    static void testDeleteFavorite() {
        Dog_Favorite__c favorite = new Dog_Favorite__c(Name = 'bulldog', Image_URL__c = 'http://example.com/delete.jpg');
        insert favorite;

        Test.startTest();
        DogApiService.deleteFavorite('http://example.com/delete.jpg');
        Test.stopTest();

        List<Dog_Favorite__c> records = [SELECT Id FROM Dog_Favorite__c WHERE Image_URL__c = 'http://example.com/delete.jpg'];
        System.assertEquals(0, records.size());
    }

    @IsTest
    static void testDeleteFavorite_NoRecord() {
        Test.startTest();
        DogApiService.deleteFavorite('http://example.com/nonexistent.jpg');
        Test.stopTest();

        // Verificar que no se lanzó ninguna excepción
        System.assert(true, 'El método no lanzó ninguna excepción');
    }

    public class MockHttpResponseGenerator implements HttpCalloutMock {
        private Integer statusCode;
        private String responseBody;

        public MockHttpResponseGenerator(Integer statusCode, String responseBody) {
            this.statusCode = statusCode;
            this.responseBody = responseBody;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(statusCode);
            response.setBody(responseBody);
            return response;
        }
    }
}