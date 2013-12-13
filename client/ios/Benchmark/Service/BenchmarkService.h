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
typedef void (^ArrayCompletionHandler)(NSArray *array, NSError *error);
typedef void (^BOOLCompletionHandler)(BOOL succeeded, NSError *error);

typedef void (^TestCompletionHandler)(Test *test, NSError *error);
typedef void (^RunCompletionHandler)(Run *run, NSError *error);
typedef void (^RunStatusCompletionHandler)(RunStatus *status, NSError *error);

@protocol BenchmarkService <NSObject>

- (void)retrieveTestsWithCompletionBlock:(ArrayCompletionHandler)completionHandler;

- (void)retrievePropertiesOfBenchmarkObject:(BenchmarkObject *)object completionHandler:(ArrayCompletionHandler)completionHandler;

- (void)retrieveRunsForTest:(Test *)test completionHandler:(ArrayCompletionHandler)completionHandler;

- (void)retrieveStatusForRun:(Run *)run completionHandler:(RunStatusCompletionHandler)completionHandler;

- (void)updateProperty:(Property *)property ofBenchmarkObject:(BenchmarkObject *)object completionHandler:(BOOLCompletionHandler)completionHandler;

- (void)scheduleRun:(Run *)run completionHandler:(BOOLCompletionHandler)completionHandler;

@end
