//
//  Test.m
//  Benchmark
//
//  Created by Gavin Cornwell on 14/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "Test.h"

@interface Test ()
@property (strong, nonatomic, readwrite) NSString *name;
@property (strong, nonatomic, readwrite) NSString *notes;
@property (strong, nonatomic, readwrite) NSArray *properties;
@end

@implementation Test

- (id)initWithName:(NSString *)name
             notes:(NSString *)notes
        properties:(NSArray *)properties
{
    self = [super init];
    if (self)
    {
        self.name = name;
        self.notes = notes;
        self.properties = properties;
    }
    return self;
}

@end
