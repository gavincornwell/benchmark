//
//  Run.m
//  Benchmark
//
//  Created by Gavin Cornwell on 14/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "Run.h"

@interface Run ()
@property (nonatomic, assign, readwrite) Test *test;
@end

@implementation Run

- (id)initWithName:(NSString *)name
           summary:(NSString *)summary
        identifier:(NSString *)identifier
           version:(NSNumber *)version
              test:(Test *)test
             state:(RunState)state
scheduledStartTime:(NSDate *)scheduledStartTime
       timeStarted:(NSDate *)timeStarted
     timeCompleted:(NSDate *)timeCompleted
       timeStopped:(NSDate *)timeStopped
{
    self = [super initWithName:name summary:summary identifier:identifier version:version];
    if (self)
    {
        self.test = test;
        self.state = state;
        self.scheduledStartTime = scheduledStartTime;
        self.timeStarted = timeStarted;
        self.timeCompleted = timeCompleted;
        self.timeStopped = timeStopped;
    }
    return self;
}

@end
