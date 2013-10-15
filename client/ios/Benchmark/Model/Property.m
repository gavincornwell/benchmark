//
//  Property.m
//  Benchmark
//
//  Created by Gavin Cornwell on 16/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "Property.h"

@interface Property ()
@property (strong, nonatomic, readwrite) NSString *name;
@property (strong, nonatomic, readwrite) NSString *title;
@property (strong, nonatomic, readwrite) NSString *originalValue;
@property (assign, nonatomic, readwrite) PropertyType type;
@end

@implementation Property

- (id)initWithName:(NSString *)name
             title:(NSString *)title
     originalValue:(NSString *)originalValue
              type:(PropertyType)type;
{
    self = [super init];
    if (self)
    {
        self.name = name;
        self.title = title;
        self.originalValue = originalValue;
        self.type = type;
        self.currentValue = nil;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)properties
{
    self = [super init];
    if (self)
    {
        // TODO: pull out the values from the dictionary (usually from JSON)
    }
    return self;
}

@end
