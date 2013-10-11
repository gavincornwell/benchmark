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
    
    // create test1
    Test *test1 = [[Test alloc] initWithName:@"BM-01" notes:@"Test signup rate of new users" properties:[self initialiseProperties]];
    Run *run1ForTest1 = [[Run alloc] initWithName:@"Completed Run" notes:@"1000 users" properties:[self initialiseProperties] hasStarted:YES hasCompleted:YES];
    Run *run2ForTest1 = [[Run alloc] initWithName:@"In Progress Run" notes:@"10000 users" properties:[self initialiseProperties] hasStarted:YES hasCompleted:NO];
    NSMutableArray *runsForTest1 = [NSMutableArray arrayWithObjects:run1ForTest1, run2ForTest1, nil];
    [self.tests setObject:test1 forKey:test1.name];
    [self.runs setObject:runsForTest1 forKey:test1.name];
    
    // create test2
    Test *test2 = [[Test alloc] initWithName:@"BM-15" notes:@"Test performance of public API" properties:[self initialiseProperties]];
    Run *run1ForTest2 = [[Run alloc] initWithName:@"Not Started Run" notes:@"50000 users" properties:[self initialiseProperties] hasStarted:NO hasCompleted:NO];
    NSMutableArray *runsForTest2 = [NSMutableArray arrayWithObjects:run1ForTest2, nil];
    [self.tests setObject:test2 forKey:test2.name];
    [self.runs setObject:runsForTest2 forKey:test2.name];
    
    // create test3
    Test *test3 = [[Test alloc] initWithName:@"Soak" notes:@"Cloud soak tests" properties:[self initialiseProperties]];
    NSMutableArray *runsForTest3 = [NSMutableArray array];
    [self.tests setObject:test3 forKey:test3.name];
    [self.runs setObject:runsForTest3 forKey:test3.name];
}

- (NSArray *)initialiseProperties
{
    Property *prop1 = [[Property alloc] initWithName:@"share.protocol" originalValue:@"http" type:PropertyTypeString];
    Property *prop2 = [[Property alloc] initWithName:@"share.host" originalValue:@"lab.alfresco.me" type:PropertyTypeString];
    Property *prop3 = [[Property alloc] initWithName:@"share.port" originalValue:@"8080" type:PropertyTypeInteger];
    Property *prop4 = [[Property alloc] initWithName:@"number.users" originalValue:@"20" type:PropertyTypeInteger];
    Property *prop5 = [[Property alloc] initWithName:@"frequency" originalValue:@"2.5" type:PropertyTypeDecimal];
    
    return [NSArray arrayWithObjects:prop1, prop2, prop3, prop4, prop5, nil];
}

#pragma mark - Protocol methods

- (void)retrieveTestsWithCompletionBlock:(ArrayCompletionBlock)completionBlock
{
    [Utils assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    NSArray *results = [self.tests allValues];
    completionBlock(results, nil);
}

- (void)retrieveRunsForTest:(Test *)test completionBlock:(ArrayCompletionBlock)completionBlock
{
    [Utils assertArgumentNotNil:test argumentName:@"test"];
    [Utils assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    
    // return runs as an array
    NSArray *results = [self.runs objectForKey:test.name];
    completionBlock(results, nil);
}

- (void)retrieveStatusForRun:(Run *)run completionBlock:(RunStatusCompletionBlock)completionBlock
{
    [Utils assertArgumentNotNil:run argumentName:@"run"];
    [Utils assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    
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
    completionBlock(status, nil);
}

- (void)createTestWithName:(NSString *)name notes:(NSString *)notes completionBlock:(TestCompletionBlock)completionBlock
{
    [Utils assertArgumentNotNil:name argumentName:@"name"];
    [Utils assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    
    // create the test
    Test *test = [[Test alloc] initWithName:name notes:notes properties:nil];
    
    // add to internal dictionary
    [self.tests setObject:test forKey:test.name];
    
    // call the completion handler
    completionBlock(test, nil);
}

- (void)createRunForTest:(Test *)test name:(NSString *)name notes:(NSString *)notes completionBlock:(RunCompletionBlock)completionBlock
{
    [Utils assertArgumentNotNil:name argumentName:@"test"];
    [Utils assertArgumentNotNil:name argumentName:@"name"];
    [Utils assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    
    // create the test run
    Run *run = [[Run alloc] initWithName:name notes:notes properties:nil hasStarted:NO hasCompleted:NO];
    
    // add to the internal dictionary
    NSMutableArray *runs = [self.runs objectForKey:test.name];
    [runs addObject:run];
    
    // call the completion handler
    completionBlock(run, nil);
}

- (void)updateProperty:(Property *)property ofBenchmarkObject:(BenchmarkObject *)object completionBlock:(BOOLCompletionBlock)completionBlock
{
    [Utils assertArgumentNotNil:property argumentName:@"property"];
    [Utils assertArgumentNotNil:object argumentName:@"object"];
    [Utils assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    completionBlock(YES, nil);
}

- (void)startRun:(Run *)run completionHandler:(BOOLCompletionBlock)completionHandler
{
    [Utils assertArgumentNotNil:run argumentName:@"run"];
    [Utils assertArgumentNotNil:completionHandler argumentName:@"completionHandler"];
    completionHandler(YES, nil);
}

@end
