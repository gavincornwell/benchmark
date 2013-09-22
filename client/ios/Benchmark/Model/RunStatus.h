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

@property (assign, nonatomic, readonly) RunState state;
@property (strong, nonatomic, readonly) NSDate *startTime;
@property (assign, nonatomic, readonly) NSInteger duration;
@property (assign, nonatomic, readonly) NSInteger successRate;
@property (assign, nonatomic, readonly) NSInteger resultCount;
@property (assign, nonatomic, readonly) NSInteger eventQueue;

- (id)initWithState:(RunState)state
          startTime:(NSDate *)startTime
           duration:(NSInteger)duration
        successRate:(NSInteger)successRate
        resultCount:(NSInteger)resultCount
         eventQueue:(NSInteger)eventQueue;


@end
