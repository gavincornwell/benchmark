//
//  Property.m
//  Benchmark
//
//  Created by Gavin Cornwell on 16/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "Property.h"
#import "Constants.h"
#import "Utils.h"

@interface Property ()
@property (strong, nonatomic, readwrite) NSString *name;
@property (strong, nonatomic, readwrite) NSString *title;
@property (strong, nonatomic, readwrite) NSString *originalValue;
@property (assign, nonatomic, readwrite) PropertyType type;
@property (strong, nonatomic, readwrite) NSString *summary;
@property (strong, nonatomic, readwrite) NSString *group;
@property (assign, nonatomic, readwrite) BOOL isVisible;
@property (assign, nonatomic, readwrite) BOOL isSecret;

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
        self.isVisible = YES;
        self.isSecret = NO;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)properties
{
    self = [super init];
    if (self)
    {
        self.currentValue = nil;
        self.isVisible = YES;
        self.isSecret = NO;
        
        // pull out the values from the dictionary (typically from JSON)
        self.name = [properties objectForKey:kJSONName];
        self.title = [properties objectForKey:kJSONTitle];
        self.summary = [properties objectForKey:kJSONDescription];
        self.originalValue = [properties objectForKey:kJSONDefault];
        self.group = [properties objectForKey:kJSONGroup];
        
        // determine type
        NSString *type = [properties objectForKey:kJSONType];
        if ([@"INT" isEqualToString:type])
        {
            self.type = PropertyTypeInteger;
        }
        else if ([@"DECIMAL" isEqualToString:type])
        {
            self.type = PropertyTypeDecimal;
        }
        else
        {
            // default to string
            self.type = PropertyTypeString;
        }
        
        // handle string and boolean objects
        if ([properties objectForKey:kJSONHide] != nil)
        {
            self.isVisible = [Utils retrieveBoolFromDictionary:properties withKey:kJSONHide];
        }
        
        if ([properties objectForKey:kJSONMask] != nil)
        {
            self.isSecret = [Utils retrieveBoolFromDictionary:properties withKey:kJSONMask];
        }
    }
    return self;
}

@end
