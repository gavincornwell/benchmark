//
//  BenchmarkService.h
//  Benchmark
//
//  Created by Gavin Cornwell on 17/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BenchmarkObject.h"
#import "Constants.h"
#import "Test.h"
#import "Property.h"
#import "Run.h"
#import "RunStatus.h"

/**---------------------------------------------------------------------------------------
 * @name Block definitions
 --------------------------------------------------------------------------------------- */
typedef void (^ArrayCompletionBlock)(NSArray *array, NSError *error);
typedef void (^BOOLCompletionBlock)(BOOL succeeded, NSError *error);

typedef void (^TestCompletionBlock)(Test *test, NSError *error);
typedef void (^RunCompletionBlock)(Run *run, NSError *error);
typedef void (^RunStatusCompletionBlock)(RunStatus *status, NSError *error);

@protocol BenchmarkService <NSObject>

- (void)createTestWithName:(NSString *)name notes:(NSString *)notes completionBlock:(TestCompletionBlock)completionBlock;

- (void)createRunWithName:(NSString *)name notes:(NSString *)notes completionBlock:(RunCompletionBlock)completionBlock;

- (void)updateProperty:(Property *)property ofBenchmarkObject:(BenchmarkObject *)object completionBlock:(BOOLCompletionBlock)completionBlock;

- (void)retrieveTestsWithCompletionBlock:(ArrayCompletionBlock)completionBlock;

- (void)retrieveRunsForTest:(Test *)test completionBlock:(ArrayCompletionBlock)completionBlock;

- (void)retrieveStatusForRun:(Run *)run completionBlock:(RunStatusCompletionBlock)completionBlock;

@end
