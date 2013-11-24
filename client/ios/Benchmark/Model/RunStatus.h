//
//  RunStatus.h
//  Benchmark
//
//  Created by Gavin Cornwell on 16/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    RunStateNotStarted = 0,
    RunStateInProgress,
    RunStateComplete
    
} RunState;


@interface RunStatus : NSObject

@property (assign, nonatomic, readwrite) RunState state;
@property (strong, nonatomic, readonly) NSDate *scheduledStartTime;
@property (strong, nonatomic, readonly) NSDate *timeStarted;
@property (assign, nonatomic, readwrite) NSInteger duration;
@property (assign, nonatomic, readwrite) NSInteger successRate;
@property (assign, nonatomic, readwrite) NSInteger progess;
@property (assign, nonatomic, readwrite) NSInteger resultsTotalCount;
@property (assign, nonatomic, readwrite) NSInteger resultsFailCount;

- (id)initWithState:(RunState)state
 scheduledStartTime:(NSDate *)scheduledStartTime
        timeStarted:(NSDate *)timeStarted
           duration:(NSInteger)duration
        successRate:(NSInteger)successRate
           progress:(NSInteger)progress
  resultsTotalCount:(NSInteger)resultsTotalCount
   resultsFailCount:(NSInteger)resultsFailCount;

@end
