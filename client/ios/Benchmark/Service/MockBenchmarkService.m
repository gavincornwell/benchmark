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

@implementation MockBenchmarkService

- (void)retrieveTestsWithCompletionBlock:(ArrayCompletionBlock)completionBlock
{
    [Utils assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    
    // create properties
    Property *prop1 = [[Property alloc] initWithName:@"share.protocol" value:nil defaultValue:@"http" type:PropertyTypeString];
    Property *prop2 = [[Property alloc] initWithName:@"share.host" value:nil defaultValue:@"lab.alfresco.me" type:PropertyTypeString];
    Property *prop3 = [[Property alloc] initWithName:@"share.port" value:nil defaultValue:[NSNumber numberWithInt:8080] type:PropertyTypeInteger];
    Property *prop4 = [[Property alloc] initWithName:@"number.users" value:nil defaultValue:[NSNumber numberWithInt:20] type:PropertyTypeInteger];
    Property *prop5 = [[Property alloc] initWithName:@"frequency" value:nil defaultValue:[NSNumber numberWithFloat:2.5] type:PropertyTypeDecimal];
    NSArray *properties = [NSArray arrayWithObjects:prop1, prop2, prop3, prop4, prop5, nil];
    
    // create some tests
    Test *test1 = [[Test alloc] initWithName:@"BM-01" notes:@"Test signup rate of new users" properties:properties];
    Test *test2 = [[Test alloc] initWithName:@"BM-15" notes:@"Test performance of public API" properties:properties];
    
    // return tests as an array
    NSArray *results = [NSArray arrayWithObjects:test1, test2, nil];
    completionBlock(results, nil);
}

- (void)retrieveRunsForTest:(Test *)test completionBlock:(ArrayCompletionBlock)completionBlock
{
    [Utils assertArgumentNotNil:test argumentName:@"test"];
    [Utils assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    
    // create properties
    Property *prop1 = [[Property alloc] initWithName:@"share.protocol" value:nil defaultValue:@"http" type:PropertyTypeString];
    Property *prop2 = [[Property alloc] initWithName:@"share.host" value:nil defaultValue:@"lab.alfresco.me" type:PropertyTypeString];
    Property *prop3 = [[Property alloc] initWithName:@"share.port" value:nil defaultValue:[NSNumber numberWithInt:8080] type:PropertyTypeInteger];
    Property *prop4 = [[Property alloc] initWithName:@"number.users" value:nil defaultValue:[NSNumber numberWithInt:20] type:PropertyTypeInteger];
    NSArray *properties = [NSArray arrayWithObjects:prop1, prop2, prop3, prop4, nil];
    
    // create some test runs
    Run *run1 = [[Run alloc] initWithName:@"Run01" notes:@"1000 users" properties:properties hasStarted:YES hasCompleted:YES];
    Run *run2 = [[Run alloc] initWithName:@"Run02" notes:@"10000 users" properties:properties hasStarted:NO hasCompleted:NO];
    Run *run3 = [[Run alloc] initWithName:@"Run03" notes:@"50000 users" properties:properties hasStarted:YES hasCompleted:NO];
    
    // return runs as an array
    NSArray *results = [NSArray arrayWithObjects:run1, run2, run3, nil];
    completionBlock(results, nil);
}

- (void)retrieveStatusForRun:(Run *)run completionBlock:(RunStatusCompletionBlock)completionBlock
{
    [Utils assertArgumentNotNil:run argumentName:@"run"];
    [Utils assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    
    RunStatus *status = nil;
    
    if ([run.name isEqualToString:@"Run01"])
    {
        status = [[RunStatus alloc] initWithState:RunStateComplete
                                        startTime:[NSDate date]
                                         duration:500
                                      successRate:100
                                      resultCount:98
                                       eventQueue:0];
    }
    else if ([run.name isEqualToString:@"Run02"])
    {
        status = [[RunStatus alloc] initWithState:RunStateNotStarted
                                        startTime:nil
                                         duration:0
                                      successRate:0
                                      resultCount:0
                                       eventQueue:0];
    }
    else
    {
        status = [[RunStatus alloc] initWithState:RunStateInProgress
                                        startTime:[NSDate date]
                                         duration:6783
                                      successRate:90
                                      resultCount:45000
                                       eventQueue:2];
    }
    
    // return the status
    completionBlock(status, nil);
}

- (void)createTestWithName:(NSString *)name notes:(NSString *)notes completionBlock:(TestCompletionBlock)completionBlock
{
    [Utils assertArgumentNotNil:name argumentName:@"name"];
    [Utils assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    completionBlock(nil, nil);
}

- (void)createRunWithName:(NSString *)name notes:(NSString *)notes completionBlock:(RunCompletionBlock)completionBlock
{
    [Utils assertArgumentNotNil:name argumentName:@"name"];
    [Utils assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    completionBlock(nil, nil);
}

- (void)updateProperties:(NSDictionary *)properties forTest:(Test *)test completionBlock:(BOOLCompletionBlock)completionBlock
{
    [Utils assertArgumentNotNil:test argumentName:@"test"];
    [Utils assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    completionBlock(YES, nil);
}

- (void)updateProperties:(NSDictionary *)properties forRun:(Run *)run completionBlock:(BOOLCompletionBlock)completionBlock
{
    [Utils assertArgumentNotNil:run argumentName:@"run"];
    [Utils assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    completionBlock(YES, nil);
}


@end
