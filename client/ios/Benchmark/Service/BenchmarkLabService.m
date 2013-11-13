//
//  BenchmarkLabService.m
//  Benchmark
//
//  Created by Gavin Cornwell on 14/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "BenchmarkLabService.h"
#import "Test.h"
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

- (void)retrieveTestsWithCompletionBlock:(ArrayCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    
    NSString *testsGetUrl = [self.baseApiUrl stringByAppendingString:kUrlPathTests];
    
    NSLog(@"Tests URL: %@", testsGetUrl);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:testsGetUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON response: %@", responseObject);
        
        // make sure response is an array
        if ([responseObject isKindOfClass:[NSArray class]])
        {
            NSArray *results = (NSArray *)responseObject;
            NSMutableArray *tests = [NSMutableArray arrayWithCapacity:results.count];
            // convert each test to an object
            for (NSDictionary *test in results)
            {
                [tests addObject:[self constructTestObjectFromDictionary:test]];
            }
            
            completionHandler(tests, nil);
        }
        else
        {
            completionHandler(nil, [Utils createErrorWithMessage:kErrorInvalidJSONReceived]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionHandler(nil, error);
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
    
    NSLog(@"Object URL: %@", objectGetUrl);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:objectGetUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON response: %@", responseObject);
        
        // make sure response is a dictionary
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *results = (NSDictionary *)responseObject;
            // get the "properties" array
            NSArray *jsonProperties = [results objectForKey:kJSONProperties];
            NSMutableArray *properties = [NSMutableArray arrayWithCapacity:jsonProperties.count];
            // convert each property into an object
            for (NSDictionary *property in jsonProperties)
            {
                [properties addObject:[self constructPropertyFromDictionary:property]];
            }
            
            completionHandler(properties, nil);
        }
        else
        {
            completionHandler(nil, [Utils createErrorWithMessage:kErrorInvalidJSONReceived]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionHandler(nil, error);
    }];
}

- (void)retrieveRunsForTest:(Test *)test completionHandler:(ArrayCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:test argumentName:@"test"];
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    
    NSString *runsGetUrl = [NSString stringWithFormat:@"%@%@/%@%@", self.baseApiUrl, kUrlPathTests, test.name, kUrlPathRuns];
    
    NSLog(@"Runs URL: %@", runsGetUrl);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:runsGetUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON response: %@", responseObject);
        
        // make sure response is an array
        if ([responseObject isKindOfClass:[NSArray class]])
        {
            NSArray *results = (NSArray *)responseObject;
            NSMutableArray *runs = [NSMutableArray arrayWithCapacity:results.count];
            // convert each run to an object
            for (NSDictionary *run in results)
            {
                [runs addObject:[self constructRunObjectFromDictionary:run test:test]];
            }
            
            completionHandler(runs, nil);
        }
        else
        {
            // TODO: This should really be an error as different responses are being returned!
//            completionHandler(nil, [Utils createErrorWithMessage:kErrorInvalidJSONReceived]);
            completionHandler([NSArray array], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionHandler(nil, error);
    }];
    
    
}

- (void)retrieveStatusForRun:(Run *)run completionHandler:(RunStatusCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:run argumentName:@"run"];
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    
    RunStatus *status = [[RunStatus alloc] initWithState:RunStateNotStarted startTime:nil duration:0 successRate:0 resultCount:0 eventQueue:0];
    
    completionHandler(status, nil);
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

    NSLog(@"Property URL: %@", propertyUrl);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
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
        [jsonBody setValue:property.currentValue forKey:kJSONValue];
    }
    
    NSLog(@"JSON body: %@", jsonBody);
    
    // PUT the new property value
    [manager PUT:propertyUrl parameters:jsonBody success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON response: %@", responseObject);
        
        // make sure response is a dictionary
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            // update the property object with the latest version
            NSDictionary *results = (NSDictionary *)responseObject;
            NSString *updatedVersion = [results objectForKey:kJSONVersion];
            property.version = updatedVersion;
            
            completionHandler(YES, nil);
        }
        else
        {
            completionHandler(NO, [Utils createErrorWithMessage:kErrorInvalidJSONReceived]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionHandler(NO, error);
    }];
}

- (void)startRun:(Run *)run completionHandler:(BOOLCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:run argumentName:@"run"];
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    
    // change the started flag on the run
    run.hasStarted = YES;
    
    completionHandler(YES, nil);
}

#pragma mark - Object construction methods

- (Test *)constructTestObjectFromDictionary:(NSDictionary *)json
{
    // extract the data from the dictionary representing the JSON
    NSString *idPath = [NSString stringWithFormat:@"%@.%@", kJSONId, kJSONOId];
    NSString *identifier = [json valueForKeyPath:idPath];
    
    return [[Test alloc] initWithName:[json objectForKey:kJSONName]
                              summary:[json objectForKey:kJSONDescription]
                           identifier:identifier];
}

- (Run *)constructRunObjectFromDictionary:(NSDictionary *)json test:(Test *)test
{
    // extract the data from the dictionary representing the JSON
    NSString *idPath = [NSString stringWithFormat:@"%@.%@", kJSONId, kJSONOId];
    NSString *identifier = [json valueForKeyPath:idPath];
    
    return [[Run alloc] initWithName:[json objectForKey:kJSONName]
                             summary:[json objectForKey:kJSONDescription]
                          identifier:identifier
                          hasStarted:[Utils retrieveBoolFromDictionary:json withKey:kJSONStarted]
                         hasCompleted:[Utils retrieveBoolFromDictionary:json withKey:kJSONCompleted]
                                 test:test];
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
                                 isSecret:isSecret
                              constraints:nil];
}

@end
