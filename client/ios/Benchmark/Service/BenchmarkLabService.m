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

- (void)retrieveTestsWithCompletionBlock:(ArrayCompletionBlock)completionBlock
{
    [Utils assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    completionBlock(nil, nil);
}

- (void)retrieveRunsForTest:(Test *)test completionBlock:(ArrayCompletionBlock)completionBlock
{
    [Utils assertArgumentNotNil:test argumentName:@"test"];
    [Utils assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    completionBlock(nil, nil);
}

- (void)retrieveStatusForRun:(Run *)run completionBlock:(RunStatusCompletionBlock)completionBlock
{
    [Utils assertArgumentNotNil:run argumentName:@"run"];
    [Utils assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    completionBlock(nil, nil);
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

- (void)updateProperty:(Property *)property ofBenchmarkObject:(BenchmarkObject *)object completionBlock:(BOOLCompletionBlock)completionBlock
{
    [Utils assertArgumentNotNil:property argumentName:@"property"];
    [Utils assertArgumentNotNil:object argumentName:@"object"];
    [Utils assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    completionBlock(YES, nil);
}

@end
