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
}
