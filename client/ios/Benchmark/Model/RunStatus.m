//
//  RunStatus.m
//  Benchmark
//
//  Created by Gavin Cornwell on 16/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "RunStatus.h"

@interface RunStatus ()
@property (strong, nonatomic, readwrite) NSDate *scheduledStartTime;
@property (strong, nonatomic, readwrite) NSDate *timeStarted;
@end

@implementation RunStatus

- (id)initWithState:(RunState)state
 scheduledStartTime:(NSDate *)scheduledStartTime
        timeStarted:(NSDate *)timeStarted
           duration:(NSInteger)duration
        successRate:(NSInteger)successRate
           progress:(NSInteger)progress
  resultsTotalCount:(NSInteger)resultsTotalCount
   resultsFailCount:(NSInteger)resultsFailCount
{
    self = [super init];
    if (self)
    {
        self.state = state;
        self.scheduledStartTime = scheduledStartTime;
        self.timeStarted = timeStarted;
        self.duration = duration;
        self.successRate = successRate;
        self.resultsTotalCount = resultsTotalCount;
        self.resultsFailCount = resultsFailCount;
        self.progess = progress;
    }
    return self;
}

@end
