//
//  MockBenchmarkService.m
//  Benchmark
//
//  Created by Gavin Cornwell on 17/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "MockBenchmarkService.h"
#import "Property.h"
#import "Run.h"
#import "RunStatus.h"
#import "Test.h"
#import "Utils.h"

@interface MockBenchmarkService ()
@property (nonatomic, strong, readwrite) NSMutableDictionary *tests;
@property (nonatomic, strong, readwrite) NSMutableDictionary *runs;
@property (nonatomic, strong, readwrite) NSMutableDictionary *properties;
@end


@implementation MockBenchmarkService

#pragma mark - Initialisation

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initialiseTestData];
    }
    return self;
}

- (void)initialiseTestData
{
    // create dictionaries
    self.tests = [NSMutableDictionary dictionary];
    self.runs = [NSMutableDictionary dictionary];
    self.properties = [NSMutableDictionary dictionary];
    
    // create test1
    Test *test1 = [[Test alloc] initWithName:@"BM-01" summary:@"Test signup rate of new users" identifier:@"526041740364a60bea599f71"];
    Run *run1ForTest1 = [[Run alloc] initWithName:@"Completed Run" summary:@"1000 users" identifier:@"526041740364a60bea599f71" hasStarted:YES hasCompleted:YES];
    Run *run2ForTest1 = [[Run alloc] initWithName:@"In Progress Run" summary:@"10000 users" identifier:@"526041740364a60bea599f71" hasStarted:YES hasCompleted:NO];
    NSMutableArray *runsForTest1 = [NSMutableArray arrayWithObjects:run1ForTest1, run2ForTest1, nil];
    [self.tests setObject:test1 forKey:test1.name];
    [self.runs setObject:runsForTest1 forKey:test1.name];
    [self.properties setObject:[self initialiseProperties] forKey:test1.name];
    [self.properties setObject:[self initialiseProperties] forKey:run1ForTest1.name];
    [self.properties setObject:[self initialiseProperties] forKey:run2ForTest1.name];
    
    // create test2
    Test *test2 = [[Test alloc] initWithName:@"BM-15" summary:@"Test performance of public API" identifier:@"526041740364a60bea599f71"];
    Run *run1ForTest2 = [[Run alloc] initWithName:@"Not Started Run" summary:@"50000 users" identifier:@"526041740364a60bea599f71" hasStarted:NO hasCompleted:NO];
    NSMutableArray *runsForTest2 = [NSMutableArray arrayWithObjects:run1ForTest2, nil];
    [self.tests setObject:test2 forKey:test2.name];
    [self.runs setObject:runsForTest2 forKey:test2.name];
    [self.properties setObject:[self initialiseProperties] forKey:test2.name];
    [self.properties setObject:[self initialiseProperties] forKey:run1ForTest2.name];
    
    // create test3
    Test *test3 = [[Test alloc] initWithName:@"Soak" summary:@"Cloud soak tests" identifier:@"526041740364a60bea599f71"];
    NSMutableArray *runsForTest3 = [NSMutableArray array];
    [self.tests setObject:test3 forKey:test3.name];
    [self.runs setObject:runsForTest3 forKey:test3.name];
    [self.properties setObject:[self initialiseProperties] forKey:test3.name];
}

- (NSArray *)initialiseProperties
{
    Property *prop1 = [[Property alloc] initWithName:@"share.protocol" title:@"Share Protocol"
                                       originalValue:@"http" type:PropertyTypeString];
    Property *prop2 = [[Property alloc] initWithName:@"share.host" title:@"Share Host"
                                       originalValue:@"lab.alfresco.me" type:PropertyTypeString];
    Property *prop3 = [[Property alloc] initWithName:@"share.port" title:@"Share Port"
                                       originalValue:@"8080" type:PropertyTypeInteger];
    Property *prop4 = [[Property alloc] initWithName:@"number.users" title:@"Number of Users"
                                       originalValue:@"20" type:PropertyTypeInteger];
    Property *prop5 = [[Property alloc] initWithName:@"frequency" title:@"Frequency"
                                       originalValue:@"2.5" type:PropertyTypeDecimal];
    
    // create with dictionary initialiser to set the secret property
    NSDictionary *prop6Dict = @{kJSONName: @"password", kJSONTitle: @"Password", kJSONDescription: @"Password to login to repository",
                                kJSONType: @"STRING", kJSONDefault: @"admin", kJSONMask: @YES};
    Property *prop6 = [[Property alloc] initWithDictionary:prop6Dict];
    
    return [NSArray arrayWithObjects:prop1, prop2, prop3, prop4, prop5, prop6, nil];
}

#pragma mark - Protocol methods

- (void)retrieveTestsWithCompletionBlock:(ArrayCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    NSArray *results = [self.tests allValues];
    completionHandler(results, nil);
}

- (void)retrievePropertiesOfBenchmarkObject:(BenchmarkObject *)object completionHandler:(ArrayCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:object argumentName:@"object"];
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    
    NSArray *properties = [self.properties objectForKey:object.name];
    if (properties == nil)
    {
        properties = [NSArray array];
    }
    
    completionHandler(properties, nil);
}

- (void)retrieveRunsForTest:(Test *)test completionHandler:(ArrayCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:test argumentName:@"test"];
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    
    // return runs as an array
    NSArray *results = [self.runs objectForKey:test.name];
    completionHandler(results, nil);
}

- (void)retrieveStatusForRun:(Run *)run completionHandler:(RunStatusCompletionHandler)completionHandler
{
    [Utils assertArgumentNotNil:run argumentName:@"run"];
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    
    RunStatus *status = nil;
    
    if ([run.name isEqualToString:@"Completed Run"])
    {
        status = [[RunStatus alloc] initWithState:RunStateComplete
                                        startTime:[NSDate date]
                                         duration:500
                                      successRate:100
                                      resultCount:98
                                       eventQueue:0];
    }
    else if ([run.name isEqualToString:@"In Progress Run"])
    {
        status = [[RunStatus alloc] initWithState:RunStateInProgress
                                        startTime:[NSDate date]
                                         duration:6783
                                      successRate:90
                                      resultCount:45000
                                       eventQueue:2];
    }
    else
    {
        status = [[RunStatus alloc] initWithState:RunStateNotStarted
                                        startTime:nil
                                         duration:0
                                      successRate:0
                                      resultCount:0
                                       eventQueue:0];
    }
    
    // return the status
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

@end
