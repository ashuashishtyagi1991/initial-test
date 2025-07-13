@isTest
private class InvocableTest {

    @isTest
    static void testGetPrompt() {
        // Arrange: create mock Contact
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@example.com'
        );
        insert testContact;
        RawJSON j = new RawJSON();
        string out = RawJSON.Myjson();
    
        // Arrange: create mock User
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser' + DateTime.now().getTime() + '@example.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = p.Id
        );
        insert testUser;

        // Arrange: create mock Product2
        Product2 testProduct = new Product2(
            Name = 'Program A',
            Description = 'A sample program',
            IsActive = true,
            Target_Clients__c = 'SMB'
        );
        insert testProduct;

        // Arrange: prepare request input
        Prompt_Program_Recommendation_Invocable.Request req = new Prompt_Program_Recommendation_Invocable.Request();
        req.Sender = testUser;
        req.Recipient = testContact;

        List<Prompt_Program_Recommendation_Invocable.Request> requests = new List<Prompt_Program_Recommendation_Invocable.Request>{ req };

        // Act: call the invocable method
        Test.startTest();
        List<Prompt_Program_Recommendation_Invocable.Response> responses =
            Prompt_Program_Recommendation_Invocable.getPrompt(requests);
        Test.stopTest();

        // Assert: verify response
        System.assertNotEquals(null, responses);
        System.assertEquals(1, responses.size());
        System.assertNotEquals(null, responses[0].prompt);
        System.debug('Prompt JSON: ' + responses[0].prompt);
    }
    @isTest
    static void testGenerateJSONContent() {
        // Arrange: create sample Product2 record
        Product2 p = new Product2(
            Name = 'Sample Product',
            Description = 'A product description',
            IsActive = true
        );
        insert p;

        // Arrange: build input map
        Map<String, List<SObject>> mapOfRecords = new Map<String, List<SObject>>();
        mapOfRecords.put('Programs', new List<SObject>{p});

        // Act: call the method
        Test.startTest();
        String jsonResult = JSONGenerator.generateJSONContent(mapOfRecords);
        Test.stopTest();

        // Assert: ensure valid non-empty JSON is returned
        System.debug('Generated JSON: ' + jsonResult);
        System.assertNotEquals(null, jsonResult, 'JSON result should not be null');
        System.assert(jsonResult.contains('"Name"'), 'JSON should contain the Name field');
        System.assert(jsonResult.contains('Sample Product'), 'JSON should include Product Name value');
        System.assert(jsonResult.startsWith('{') && jsonResult.endsWith('}'), 'JSON should be properly wrapped');
    }
}
