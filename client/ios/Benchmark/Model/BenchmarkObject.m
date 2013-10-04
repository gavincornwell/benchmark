//
//  BenchmarkObject.m
//  Benchmark
//
//  Created by Gavin Cornwell on 04/10/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "BenchmarkObject.h"

@interface BenchmarkObject()
@property (strong, nonatomic, readwrite) NSString *name;
@property (strong, nonatomic, readwrite) NSString *notes;
@property (strong, nonatomic, readwrite) NSArray *properties;
@end

@implementation BenchmarkObject

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
