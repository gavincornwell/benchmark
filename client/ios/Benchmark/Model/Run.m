//
//  Run.m
//  Benchmark
//
//  Created by Gavin Cornwell on 14/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "Run.h"

@interface Run ()
@property (strong, nonatomic, readwrite) NSString *name;
@property (strong, nonatomic, readwrite) NSString *notes;
@property (strong, nonatomic, readwrite) NSArray *properties;
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
    self = [super init];
    if (self)
    {
        self.name = name;
        self.notes = notes;
        self.properties = properties;
        self.hasStarted = hasStarted;
        self.hasCompleted = hasCompleted;
    }
    return self;
}

@end
