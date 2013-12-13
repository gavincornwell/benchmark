//
//  BenchmarkObject.m
//  Benchmark
//
//  Created by Gavin Cornwell on 04/10/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "BenchmarkObject.h"

@interface BenchmarkObject()
@property (strong, nonatomic, readwrite) NSString *identifier;
@property (strong, nonatomic, readwrite) NSString *name;
@property (strong, nonatomic, readwrite) NSString *summary;
@end

@implementation BenchmarkObject

- (id)initWithName:(NSString *)name
           summary:(NSString *)summary
        identifier:(NSString *)identifier
           version:(NSNumber *)version
{
    self = [super init];
    if (self)
    {
        self.name = name;
        self.summary = summary;
        self.identifier = identifier;
        self.version = version;
        
        if (self.summary == (id)[NSNull null])
        {
            self.summary = nil;
        }
        
        if (self.version == nil)
        {
            self.version = 0;
        }
    }
    return self;
}

@end
