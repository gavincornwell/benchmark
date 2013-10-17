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

@interface BenchmarkLabService ()
@property (nonatomic, strong, readwrite) NSURL* url;
@end

@implementation BenchmarkLabService

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self)
    {
        self.url = url;
    }
    return self;
}

#pragma mark - Protocol methods

- (void)retrieveTestsWithCompletionBlock:(ArrayCompletionHandler)completionHandler
{
    /*
    [
     {
         "_id": {
             "$oid": "526041740364a60bea599f71"
         },
         "name": "SAMPLE1",
         "version": 0,
         "description": "A first sample",
         "release": "alfresco-benchmark-bm-sample-2.0-SNAPSHOT",
         "schema": 1
     },
     {
         "_id": {
             "$oid": "5260425f0364a60bea599f72"
         },
         "name": "SAMPLE2",
         "version": 0,
         "description": "A second sample",
         "release": "alfresco-benchmark-bm-sample-2.0-SNAPSHOT",
         "schema": 1
     }
     ]
    */
    
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    completionHandler(nil, nil);
}

- (void)retrievePropertiesOfBenchmarkObject:(BenchmarkObject *)object completionHandler:(ArrayCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:object argumentName:@"object"];
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    completionHandler(nil, nil);
}

- (void)retrieveRunsForTest:(Test *)test completionHandler:(ArrayCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:test argumentName:@"test"];
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    completionHandler(nil, nil);
}

- (void)retrieveStatusForRun:(Run *)run completionHandler:(RunStatusCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:run argumentName:@"run"];
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    completionHandler(nil, nil);
}

- (void)createTestWithName:(NSString *)name summary:(NSString *)summary completionHandler:(TestCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:name argumentName:@"name"];
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    completionHandler(nil, nil);
}

- (void)createRunForTest:(Test *)test name:(NSString *)name summary:(NSString *)summary completionHandler:(RunCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:name argumentName:@"test"];
    [Utils assertArgumentNotNil:name argumentName:@"name"];
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    completionHandler(nil, nil);
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

#pragma mark - Generation methods

- (Property *)generatePropertyFromProperties:(NSDictionary *)json
{
    NSData *data = nil;
    NSError *error = nil;
    id jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    return nil;
}

@end
