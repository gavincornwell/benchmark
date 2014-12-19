//
//  BenchmarkLabService.m
//  Benchmark
//
//  Created by Gavin Cornwell on 14/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "BenchmarkLabService.h"
#import "Test.h"
#import "TestDefinition.h"
#import "Utils.h"

#import "AFHTTPRequestOperationManager.h"

@interface BenchmarkLabService ()
@property (nonatomic, strong, readwrite) NSURL *url;
@property (nonatomic, strong, readwrite) NSString *baseApiUrl;
@end

@implementation BenchmarkLabService

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self)
    {
        self.url = url;
        self.baseApiUrl = [self.url.absoluteString stringByAppendingString:kUrlPathApiV1];
    }
    return self;
}

#pragma mark - Protocol methods

- (void)retrieveTestDefinitionsWithCompletionBlock:(ArrayCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    
    NSString *testDefinitionsGetUrl = [self.baseApiUrl stringByAppendingString:kUrlPathTestDefinitions];
    
    [self executeArrayGetRequestForUrl:testDefinitionsGetUrl completionHandler:^(NSArray *responseArray, NSError *responseError) {
        NSMutableArray *testDefinitions = nil;
        
        if (responseArray)
        {
            testDefinitions = [NSMutableArray arrayWithCapacity:responseArray.count];
            // convert each test to an object
            for (NSDictionary *testDefinition in responseArray)
            {
                [testDefinitions addObject:[self constructTestDefinitionObjectFromDictionary:testDefinition]];
            }
        }
        
        completionHandler(testDefinitions, responseError);
    }];
}

- (void)retrieveTestsWithCompletionBlock:(ArrayCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    
    NSString *testsGetUrl = [self.baseApiUrl stringByAppendingString:kUrlPathTests];
    
    [self executeArrayGetRequestForUrl:testsGetUrl completionHandler:^(NSArray *responseArray, NSError *responseError) {
        NSMutableArray *tests = nil;
        
        if (responseArray)
        {
            tests = [NSMutableArray arrayWithCapacity:responseArray.count];
            // convert each test to an object
            for (NSDictionary *test in responseArray)
            {
                [tests addObject:[self constructTestObjectFromDictionary:test]];
            }
        }
        
        completionHandler(tests, nil);
    }];
}

- (void)retrievePropertiesOfBenchmarkObject:(BenchmarkObject *)object completionHandler:(ArrayCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:object argumentName:@"object"];
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    
    // generate the appropriate URL
    NSString *objectGetUrl = nil;
    if ([object isKindOfClass:[Test class]])
    {
        objectGetUrl = [NSString stringWithFormat:@"%@%@/%@", self.baseApiUrl, kUrlPathTests, object.name];
    }
    else
    {
        Run *run = (Run *)object;
        objectGetUrl = [NSString stringWithFormat:@"%@%@/%@%@/%@", self.baseApiUrl, kUrlPathTests, run.test.name, kUrlPathRuns, object.name];
    }
    
    [self executeDictionaryGetRequestForUrl:objectGetUrl completionHandler:^(NSDictionary *responseDictionary, NSError *responseError) {
        NSMutableArray *properties = nil;
        
        if (responseDictionary)
        {
            // get the "properties" array
            NSArray *jsonProperties = [responseDictionary objectForKey:kJSONProperties];
            properties = [NSMutableArray arrayWithCapacity:jsonProperties.count];
            // convert each property into an object
            for (NSDictionary *property in jsonProperties)
            {
                [properties addObject:[self constructPropertyFromDictionary:property]];
            }
        }
        
        completionHandler(properties, responseError);
    }];
}

- (void)retrieveRunsForTest:(Test *)test completionHandler:(ArrayCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:test argumentName:@"test"];
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    
    NSString *runsGetUrl = [NSString stringWithFormat:@"%@%@/%@%@", self.baseApiUrl, kUrlPathTests, test.name, kUrlPathRuns];
    
    [self executeArrayGetRequestForUrl:runsGetUrl completionHandler:^(NSArray *responseArray, NSError *responseError) {
        NSMutableArray *runs = nil;
        
        if (responseArray)
        {
            runs = [NSMutableArray arrayWithCapacity:responseArray.count];
            // convert each run to an object
            for (NSDictionary *run in responseArray)
            {
                [runs addObject:[self constructRunObjectFromDictionary:run test:test]];
            }
        }
        
        completionHandler(runs, responseError);
    }];
}

- (void)retrieveStatusForRun:(Run *)run completionHandler:(RunStatusCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:run argumentName:@"run"];
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    
    NSString *runStateGetUrl = [NSString stringWithFormat:@"%@%@/%@%@/%@%@", self.baseApiUrl, kUrlPathTests, run.test.name, kUrlPathRuns, run.name, kUrlPathSummary];
    
    [self executeDictionaryGetRequestForUrl:runStateGetUrl completionHandler:^(NSDictionary *responseDictionary, NSError *responseError) {
        RunStatus *status = nil;
        
        if (responseDictionary)
        {
            // construct run status object
            status = [self constructRunStatusObjectFromDictionary:responseDictionary];
            
            // if progress shows 100% change state on run object
            if (status.progess == 100)
            {
                run.state = RunStateCompleted;
            }
        }
        
        completionHandler(status, responseError);
    }];
}

- (void)updateProperty:(Property *)property ofBenchmarkObject:(BenchmarkObject *)object completionHandler:(BOOLCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:property argumentName:@"property"];
    [Utils assertArgumentNotNil:object argumentName:@"object"];
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    
    // generate the appropriate URL
    NSString *propertyUrl = nil;
    if ([object isKindOfClass:[Test class]])
    {
        propertyUrl = [NSString stringWithFormat:@"%@%@/%@/props/%@", self.baseApiUrl, kUrlPathTests, object.name, property.name];
    }
    else
    {
        Run *run = (Run *)object;
        propertyUrl = [NSString stringWithFormat:@"%@%@/%@%@/%@/props/%@", self.baseApiUrl, kUrlPathTests, run.test.name, kUrlPathRuns, object.name, property.name];
    }
        
    // create the dictionary to represent the JSON body
    NSMutableDictionary *jsonBody = [NSMutableDictionary dictionaryWithObject:property.version forKey:kJSONVersion];
    
    // only include the value in the body if it is set
    if (property.currentValue == nil || [property.currentValue isEqualToString:@""])
    {
        // make sure current value of property is reset
        property.currentValue = nil;
    }
    else
    {
        jsonBody[kJSONValue] = property.currentValue;
    }
    
    [self executePutRequestForUrl:propertyUrl bodyDictionary:jsonBody completionHandler:^(NSDictionary *responseDictionary, NSError *responseError) {
        BOOL succeeded = NO;
        
        if (responseDictionary)
        {
            // update property version
            NSNumber *updatedVersion = [responseDictionary objectForKey:kJSONVersion];
            property.version = updatedVersion;
            
            succeeded = YES;
        }
        
        completionHandler(succeeded, responseError);
    }];
}

- (void)scheduleRun:(Run *)run completionHandler:(BOOLCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:run argumentName:@"run"];
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    
    NSString *scheduleRunUrl = [NSString stringWithFormat:@"%@%@/%@%@/%@%@", self.baseApiUrl, kUrlPathTests, run.test.name, kUrlPathRuns, run.name, kUrlPathSchedule];
    
    // create the dictionary to represent the JSON body
    NSMutableDictionary *jsonBody = [NSMutableDictionary dictionaryWithObject:run.version forKey:kJSONVersion];
    // calculate now as the number of seconds since Jan 1 1970
    NSTimeInterval seconds = [[NSDate date] timeIntervalSince1970];
    unsigned long long millSecondsSince1970 = seconds * 1000;
    [jsonBody setValue:[NSNumber numberWithLongLong:millSecondsSince1970] forKey:kJSONScheduled];
    
    [self executePostRequestForUrl:scheduleRunUrl bodyDictionary:jsonBody completionHandler:^(NSDictionary *responseDictionary, NSError *responseError) {
        BOOL succeeded = NO;
        
        if (responseDictionary)
        {
            // update the run object with the latest version
            NSNumber *updatedVersion = [responseDictionary objectForKey:kJSONVersion];
            run.version = updatedVersion;
            
            // change the state of the run object
            run.state = RunStateScheduled;
            
            succeeded = YES;
        }
        
        completionHandler(succeeded, responseError);
    }];
}

- (void)stopRun:(Run *)run completionHandler:(BOOLCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:run argumentName:@"run"];
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    
    NSString *stopRunUrl = [NSString stringWithFormat:@"%@%@/%@%@/%@%@", self.baseApiUrl, kUrlPathTests, run.test.name, kUrlPathRuns, run.name, kUrlPathTerminate];

    [self executePostRequestForUrl:stopRunUrl bodyDictionary:nil completionHandler:^(NSDictionary *responseDictionary, NSError *responseError) {
        BOOL succeeded = NO;
        
        if (responseDictionary)
        {
            // update the run object with the latest version
            NSNumber *updatedVersion = [responseDictionary objectForKey:kJSONVersion];
            run.version = updatedVersion;
            
            // change the state of the run object
            run.state = RunStateStopped;
            
            succeeded = YES;
        }
        
        completionHandler(succeeded, responseError);
    }];
}

- (void)addTestWithDefinition:(TestDefinition *)definition name:(NSString *)name summary:(NSString *)summary completionHandler:(TestCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:definition argumentName:@"definition"];
    [Utils assertArgumentNotNil:name argumentName:@"name"];
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    
    NSMutableDictionary *bodyDictionary = [NSMutableDictionary dictionary];
    bodyDictionary[kJSONName] = name;
    bodyDictionary[kJSONRelease] = definition.name;
    bodyDictionary[kJSONSchema] = definition.schema;
    
    if (summary)
    {
        bodyDictionary[kJSONDescription] = summary;
    }
    
    NSString *addTestUrl = [NSString stringWithFormat:@"%@%@", self.baseApiUrl, kUrlPathTests];
    
    [self executePostRequestForUrl:addTestUrl bodyDictionary:bodyDictionary completionHandler:^(NSDictionary *responseDictionary, NSError *responseError) {
        Test *test = nil;
        
        if (responseDictionary)
        {
            test = [self constructTestObjectFromDictionary:responseDictionary];
        }
        
        completionHandler(test, responseError);
    }];
}

- (void)addRunToTest:(Test *)test name:(NSString *)name summary:(NSString *)summary completionHandler:(RunCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:test argumentName:@"test"];
    [Utils assertArgumentNotNil:name argumentName:@"name"];
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    
    NSMutableDictionary *bodyDictionary = [NSMutableDictionary dictionary];
    bodyDictionary[kJSONName] = name;
    
    if (summary)
    {
        bodyDictionary[kJSONDescription] = summary;
    }
    
    NSString *addRunUrl = [NSString stringWithFormat:@"%@%@/%@%@", self.baseApiUrl, kUrlPathTests, test.name, kUrlPathRuns];
    
    [self executePostRequestForUrl:addRunUrl bodyDictionary:bodyDictionary completionHandler:^(NSDictionary *responseDictionary, NSError *responseError) {
        Run *run = nil;
        
        if (responseDictionary)
        {
            run = [self constructRunObjectFromDictionary:responseDictionary test:test];
        }
        
        completionHandler(run, responseError);
    }];
}

- (void)deleteTest:(Test *)test completionHandler:(BOOLCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:test argumentName:@"test"];
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    
    NSString *deleteTestUrl = [NSString stringWithFormat:@"%@%@/%@", self.baseApiUrl, kUrlPathTests, test.name];
    
    [self executeDeleteRequestForUrl:deleteTestUrl completionHandler:completionHandler];
}

- (void)deleteRun:(Run *)run completionHandler:(BOOLCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:run argumentName:@"run"];
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    
    NSString *deleteRunUrl = [NSString stringWithFormat:@"%@%@/%@%@/%@", self.baseApiUrl, kUrlPathTests, run.test.name, kUrlPathRuns, run.name];
    
    [self executeDeleteRequestForUrl:deleteRunUrl completionHandler:completionHandler];
}

#pragma mark - Object construction methods

- (TestDefinition *)constructTestDefinitionObjectFromDictionary:(NSDictionary *)json
{
    // extract the data from the dictionary representing the JSON
    NSString *idPath = [NSString stringWithFormat:@"%@.%@", kJSONId, kJSONOId];
    NSString *identifier = [json valueForKeyPath:idPath];
    
    return [[TestDefinition alloc] initWithIdentifier:identifier
                                                 name:[json objectForKey:kJSONRelease]
                                               schema:[json objectForKey:kJSONSchema]];
}

- (Test *)constructTestObjectFromDictionary:(NSDictionary *)json
{
    // extract the data from the dictionary representing the JSON
    NSString *idPath = [NSString stringWithFormat:@"%@.%@", kJSONId, kJSONOId];
    NSString *identifier = [json valueForKeyPath:idPath];
    
    return [[Test alloc] initWithName:[json objectForKey:kJSONName]
                              summary:[json objectForKey:kJSONDescription]
                           identifier:identifier
                              version:[json objectForKey:kJSONVersion]];
}

- (Run *)constructRunObjectFromDictionary:(NSDictionary *)json test:(Test *)test
{
    // extract the data from the dictionary representing the JSON
    NSString *idPath = [NSString stringWithFormat:@"%@.%@", kJSONId, kJSONOId];
    NSString *identifier = [json valueForKeyPath:idPath];
    
    // determine the state of the run
    RunState state = RunStateNotScheduled;
    NSString *stateString = [json objectForKey:kJSONState];
    if (stateString != nil)
    {
        if ([stateString isEqualToString:kJSONStateScheduled])
        {
            state = RunStateScheduled;
        }
        else if ([stateString isEqualToString:kJSONStateStarted])
        {
            state = RunStateStarted;
        }
        else if ([stateString isEqualToString:kJSONStateStopped])
        {
            state = RunStateStopped;
        }
        else if ([stateString isEqualToString:kJSONStateCompleted])
        {
            state = RunStateCompleted;
        }
    }
    
    // retrieve times
    NSDate *scheduledStartTime = [Utils retrieveDateFromDictionary:json withKey:kJSONScheduled];
    NSDate *timeStarted = [Utils retrieveDateFromDictionary:json withKey:kJSONStarted];
    NSDate *timeCompleted = [Utils retrieveDateFromDictionary:json withKey:kJSONCompleted];
    NSDate *timeStopped = [Utils retrieveDateFromDictionary:json withKey:kJSONStopped];
    
    return [[Run alloc] initWithName:[json objectForKey:kJSONName]
                             summary:[json objectForKey:kJSONDescription]
                          identifier:identifier
                             version:[json objectForKey:kJSONVersion]
                                test:test
                               state:state
                  scheduledStartTime:scheduledStartTime
                         timeStarted:timeStarted
                       timeCompleted:timeCompleted
                         timeStopped:timeStopped];
}

- (RunStatus *)constructRunStatusObjectFromDictionary:(NSDictionary *)json
{
    // retrieve times
    NSDate *scheduledStartTime = [Utils retrieveDateFromDictionary:json withKey:kJSONScheduled];
    NSDate *timeStarted = [Utils retrieveDateFromDictionary:json withKey:kJSONStarted];
    
    NSInteger successRate = 0;
    NSInteger progress = 0;
    long long duration = 0;
    
    // convert the duration to seconds
    if ([json objectForKey:kJSONDuration])
    {
        duration = [[json objectForKey:kJSONDuration] longLongValue];
        if (duration > 0)
        {
            duration = duration / 1000;
        }
    }
    
    // convert success rate to a percentage
    if ([json objectForKey:kJSONSuccessRate])
    {
        successRate = [[json objectForKey:kJSONSuccessRate] floatValue] * 100;
    }
    
    // convert progress to a percentage
    if ([json objectForKey:kJSONProgress])
    {
        progress = [[json objectForKey:kJSONProgress] floatValue] * 100;
    }
    
    return [[RunStatus alloc] initWithScheduledStartTime:scheduledStartTime
                                             timeStarted:timeStarted
                                                duration:duration
                                             successRate:successRate
                                                progress:progress
                                       resultsTotalCount:[[json objectForKey:kJSONResultsTotal] integerValue]
                                     resultsSuccessCount:[[json objectForKey:kJSONResultsSuccess] integerValue]
                                        resultsFailCount:[[json objectForKey:kJSONResultsFail] integerValue]];
}

- (Property *)constructPropertyFromDictionary:(NSDictionary *)json
{
    // determine type
    PropertyType type;
    NSString *typeString = [json objectForKey:kJSONType];
    if ([@"INT" isEqualToString:typeString])
    {
        type = PropertyTypeInteger;
    }
    else if ([@"DECIMAL" isEqualToString:typeString])
    {
        type = PropertyTypeDecimal;
    }
    else
    {
        // default to string
        type = PropertyTypeString;
    }
    
    // handle string and boolean objects
    BOOL isHidden = NO;
    BOOL isSecret = NO;
    if ([json objectForKey:kJSONHide] != nil)
    {
        isHidden = [Utils retrieveBoolFromDictionary:json withKey:kJSONHide];
    }
    
    if ([json objectForKey:kJSONMask] != nil)
    {
        isSecret = [Utils retrieveBoolFromDictionary:json withKey:kJSONMask];
    }
    
    // construct and return the property object
    return [[Property alloc] initWithName:[json objectForKey:kJSONName]
                                    title:[json objectForKey:kJSONTitle]
                                  summary:[json objectForKey:kJSONDescription]
                             defaultValue:[json objectForKey:kJSONDefault]
                             currentValue:[json objectForKey:kJSONValue]
                                    group:[json objectForKey:kJSONGroup]
                                     type:type
                                  version:[json objectForKey:kJSONVersion]
                                 isHidden:isHidden
                                 isSecret:isSecret];
}

#pragma mark Network handling methods

- (void)executeDictionaryGetRequestForUrl:(NSString *)url completionHandler:(DictionaryCompletionHandler)completionHandler
{
    NSLog(@"GET: %@", url);
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error)
        {
            completionHandler(nil, error);
        }
        else
        {
            NSError *responseError = nil;
            NSDictionary *responseDictionary = [self dictionaryFromData:data response:response error:&responseError];
            completionHandler(responseDictionary, responseError);
        }
    }];
    
    // execute the request
    [task resume];
}

- (void)executeArrayGetRequestForUrl:(NSString *)url completionHandler:(ArrayCompletionHandler)completionHandler
{
    NSLog(@"GET: %@", url);
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error)
        {
            completionHandler(nil, error);
        }
        else
        {
            NSError *responseError = nil;
            NSArray *responseArray = [self arrayFromData:data response:response error:&responseError];
            completionHandler(responseArray, responseError);
        }
    }];
    
    // execute the request
    [task resume];
}

- (void)executePostRequestForUrl:(NSString *)url bodyDictionary:(NSDictionary *)bodyDictionary completionHandler:(DictionaryCompletionHandler)completionHandler
{
    NSLog(@"POST: %@", url);
    
    NSError *bodyError = nil;
    NSData *bodyData = nil;
    
    if (bodyDictionary)
    {
        bodyData = [NSJSONSerialization dataWithJSONObject:bodyDictionary options:0 error:&bodyError];
    }
    
    if (bodyError)
    {
        completionHandler(nil, bodyError);
    }
    else
    {
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        request.HTTPMethod = @"POST";
        
        // define block to use as response completion handler
        void (^responseHandler)(NSData *data,
                                NSURLResponse *response,
                                NSError *postError) = ^void(NSData *data, NSURLResponse *response, NSError *postError) {
            if (postError)
            {
                completionHandler(nil, postError);
            }
            else
            {
                NSError *responseError = nil;
                NSDictionary *responseDictionary = [self dictionaryFromData:data response:response error:&responseError];
                completionHandler(responseDictionary, responseError);
            }
        };
        
        NSURLSessionTask *task = nil;
        if (bodyData)
        {
            [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            task = [session uploadTaskWithRequest:request fromData:bodyData completionHandler:responseHandler];
        }
        else
        {
            task = [session dataTaskWithRequest:request completionHandler:responseHandler];
        }
        
        // execute the request
        [task resume];
    }
}

- (void)executePutRequestForUrl:(NSString *)url bodyDictionary:(NSDictionary *)bodyDictionary completionHandler:(DictionaryCompletionHandler)completionHandler
{
    NSLog(@"PUT: %@", url);
    
    NSError *bodyError = nil;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDictionary options:0 error:&bodyError];
    
    if (bodyError)
    {
        completionHandler(nil, bodyError);
    }
    else
    {
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        request.HTTPMethod = @"PUT";
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSURLSessionUploadTask *task = [session uploadTaskWithRequest:request
                                                             fromData:bodyData
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *putError) {
            if (putError)
            {
                completionHandler(nil, putError);
            }
            else
            {
                NSError *responseError = nil;
                NSDictionary *responseDictionary = [self dictionaryFromData:data response:response error:&responseError];
                completionHandler(responseDictionary, responseError);
            }
        }];
        
        // execute the request
        [task resume];
    }
}

- (void)executeDeleteRequestForUrl:(NSString *)url completionHandler:(BOOLCompletionHandler)completionHandler
{
    NSLog(@"DELETE: %@", url);
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"DELETE";
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *deleteError) {
        if (deleteError)
        {
            completionHandler(NO, deleteError);
        }
        else
        {
            NSError *responseError = nil;
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if (httpResponse.statusCode >= 400)
            {
                responseError = [Utils createErrorWithMessage:[self errorMessageForStatusCode:httpResponse.statusCode]];
            }
            
            completionHandler(responseError == nil ? YES : NO, responseError);
        }
    }];
    
    // execute the request
    [task resume];
}


- (NSDictionary *)dictionaryFromData:(NSData *)data response:(NSURLResponse *)response error:(NSError **)outError
{
    NSDictionary *responseDictionary = nil;
    
    if (data != nil)
    {
        responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:outError];
    }
    
    // check response status code
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if (httpResponse.statusCode >= 400)
    {
        NSString *errorMessage = nil;
        
        // look for an error message in the data
        if (responseDictionary && responseDictionary[kJSONError])
        {
            errorMessage = responseDictionary[kJSONError];
        }
        else
        {
            errorMessage = [self errorMessageForStatusCode:httpResponse.statusCode];
        }
        
        *outError = [Utils createErrorWithMessage:errorMessage];
        responseDictionary = nil;
    }

    return responseDictionary;
}

- (NSArray *)arrayFromData:(NSData *)data response:(NSURLResponse *)response error:(NSError **)outError
{
    NSArray *responseArray = nil;
    
    if (data != nil)
    {
        responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:outError];
    }
    
    // check response status code
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if (httpResponse.statusCode >= 400)
    {
        *outError = [Utils createErrorWithMessage:[self errorMessageForStatusCode:httpResponse.statusCode]];
        responseArray = nil;
    }
    
    return responseArray;
}

- (NSString *)errorMessageForStatusCode:(NSInteger)statusCode
{
    NSString *errorMessage = nil;
    
    if (statusCode == 404)
    {
        errorMessage = @"Requested item was not found";
    }
    else
    {
        errorMessage = @"An error occurred on the server";
    }
    
    return errorMessage;
}

@end
