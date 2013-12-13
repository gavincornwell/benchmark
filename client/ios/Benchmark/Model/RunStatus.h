//
//  RunStatus.h
//  Benchmark
//
//  Created by Gavin Cornwell on 16/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunStatus : NSObject

@property (strong, nonatomic, readonly) NSDate *scheduledStartTime;
@property (strong, nonatomic, readonly) NSDate *timeStarted;
@property (assign, nonatomic, readwrite) long long duration;
@property (assign, nonatomic, readwrite) NSInteger successRate;
@property (assign, nonatomic, readwrite) NSInteger progess;
@property (assign, nonatomic, readwrite) NSInteger resultsTotalCount;
@property (assign, nonatomic, readwrite) NSInteger resultsSuccessCount;
@property (assign, nonatomic, readwrite) NSInteger resultsFailCount;

- (id)initWithScheduledStartTime:(NSDate *)scheduledStartTime
        timeStarted:(NSDate *)timeStarted
           duration:(long long)duration
        successRate:(NSInteger)successRate
           progress:(NSInteger)progress
  resultsTotalCount:(NSInteger)resultsTotalCount
resultsSuccessCount:(NSInteger)resultsSuccessCount
   resultsFailCount:(NSInteger)resultsFailCount;

@end
