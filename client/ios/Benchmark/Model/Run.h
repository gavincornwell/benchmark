//
//  Run.h
//  Benchmark
//
//  Created by Gavin Cornwell on 14/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BenchmarkObject.h"
#import "Test.h"

typedef enum
{
    RunStateNotScheduled = 0,
    RunStateScheduled,
    RunStateStarted,
    RunStateStopped,
    RunStateCompleted
    
} RunState;

@interface Run : BenchmarkObject

@property (nonatomic, assign, readwrite) RunState state;
@property (nonatomic, strong, readwrite) NSDate *scheduledStartTime;
@property (nonatomic, strong, readwrite) NSDate *timeStarted;
@property (nonatomic, strong, readwrite) NSDate *timeCompleted;
@property (nonatomic, strong, readwrite) NSDate *timeStopped;
@property (nonatomic, assign, readonly) Test *test;

- (id)initWithName:(NSString *)name
             summary:(NSString *)summary
        identifier:(NSString *)identifier
           version:(NSNumber *)version
              test:(Test *)test
             state:(RunState)state
scheduledStartTime:(NSDate *)scheduledStartTime
       timeStarted:(NSDate *)timeStarted
     timeCompleted:(NSDate *)timeCompleted
       timeStopped:(NSDate *)timeStopped;

@end
