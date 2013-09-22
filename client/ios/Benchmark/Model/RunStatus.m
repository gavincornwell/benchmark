//
//  RunStatus.m
//  Benchmark
//
//  Created by Gavin Cornwell on 16/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "RunStatus.h"

@interface RunStatus ()
@property (assign, nonatomic, readwrite) RunState state;
@property (strong, nonatomic, readwrite) NSDate *startTime;
@property (assign, nonatomic, readwrite) NSInteger duration;
@property (assign, nonatomic, readwrite) NSInteger successRate;
@property (assign, nonatomic, readwrite) NSInteger resultCount;
@property (assign, nonatomic, readwrite) NSInteger eventQueue;
@end

@implementation RunStatus

- (id)initWithState:(RunState)state
          startTime:(NSDate *)startTime
           duration:(NSInteger)duration
        successRate:(NSInteger)successRate
        resultCount:(NSInteger)resultCount
         eventQueue:(NSInteger)eventQueue
{
    self = [super init];
    if (self)
    {
        self.state = state;
        self.startTime = startTime;
        self.duration = duration;
        self.successRate = successRate;
        self.resultCount = resultCount;
        self.eventQueue = eventQueue;
    }
    return self;
}

@end
