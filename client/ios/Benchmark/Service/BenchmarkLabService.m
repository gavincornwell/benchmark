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
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:testsGetUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
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
        objectGetUrl = [NSString stringWithFormat:@"%@%@%@/%@", self.baseApiUrl, kUrlPathTests, kUrlPathRuns, object.name];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:objectGetUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
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
    completionHandler([NSArray array], nil);
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
    completionHandler(YES, nil);
}

- (void)startRun:(Run *)run completionHandler:(BOOLCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:run argumentName:@"run"];
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    completionHandler(YES, nil);
}

#pragma mark - Object construction methods

- (Test *)constructTestObjectFromDictionary:(NSDictionary *)json
{
    // extract the data from the dictionary representing the JSON
    NSString *idPath = [NSString stringWithFormat:@"%@.%@", kJSONId, kJSONOId];
    NSString *identifier = [json valueForKeyPath:idPath];
    NSString *name = [json objectForKey:kJSONName];
    NSString *summary = [json objectForKey:kJSONDescription];
    
    return [[Test alloc] initWithName:name summary:summary identifier:identifier];
}
            
- (Property *)constructPropertyFromDictionary:(NSDictionary *)json
{
    return [[Property alloc] initWithDictionary:json];
}

@end
