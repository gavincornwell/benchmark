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
@property (strong, nonatomic, readwrite) id defaultValue;
@property (assign, nonatomic, readwrite) PropertyType type;
@property (assign, nonatomic, readwrite) BOOL hasValueChanged;
@end

@implementation Property

- (id)initWithName:(NSString *)name
             value:(id)value
      defaultValue:(NSString *)defaultValue
              type:(PropertyType)type
{
    self = [super init];
    if (self)
    {
        self.name = name;
        self.value = value;
        self.defaultValue = defaultValue;
        self.type = type;
        self.hasValueChanged = false;
    }
    return self;
}

@end
