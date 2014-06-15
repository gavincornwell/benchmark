//
//  TestDefinition.m
//  Benchmark
//
//  Created by Gavin Cornwell on 23/05/2014.
//  Copyright (c) 2014 Alfresco. All rights reserved.
//

#import "TestDefinition.h"

@interface TestDefinition ()
@property (strong, nonatomic, readwrite) NSString *identifier;
@property (strong, nonatomic, readwrite) NSString *name;
@property (strong, nonatomic, readwrite) NSNumber *schema;
@end

@implementation TestDefinition

- (id)initWithIdentifier:(NSString *)identifier
                    name:(NSString *)name
                  schema:(NSNumber *)schema
{
    self = [super init];
    if (self)
    {
        self.identifier = identifier;
        self.name = name;
        self.schema = schema;
    }
    return self;
}

@end
