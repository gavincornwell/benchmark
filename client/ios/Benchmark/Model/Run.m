//
//  Run.m
//  Benchmark
//
//  Created by Gavin Cornwell on 14/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "Run.h"

@interface Run ()
@property (nonatomic, assign, readwrite) BOOL hasStarted;
@property (nonatomic, assign, readwrite) BOOL hasCompleted;
@end

@implementation Run

- (id)initWithName:(NSString *)name
             notes:(NSString *)notes
        properties:(NSArray *)properties
        hasStarted:(BOOL)hasStarted
      hasCompleted:(BOOL)hasCompleted
{
    self = [super initWithName:name notes:notes properties:properties];
    if (self)
    {
        self.hasStarted = hasStarted;
        self.hasCompleted = hasCompleted;
    }
    return self;
}

@end
