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
@property (strong, nonatomic, readwrite) NSString *defaultValue;
@property (assign, nonatomic, readwrite) PropertyType type;
@property (strong, nonatomic, readwrite) NSString *summary;
@property (strong, nonatomic, readwrite) NSString *group;
@property (assign, nonatomic, readwrite) BOOL isHidden;
@property (assign, nonatomic, readwrite) BOOL isSecret;
@property (assign, nonatomic, readwrite) NSArray *constraints;

@end

@implementation Property

- (id)initWithName:(NSString *)name
      defaultValue:(NSString *)defaultValue
              type:(PropertyType)type;

{
    return [self initWithName:name title:nil summary:nil defaultValue:defaultValue currentValue:nil
                        group:nil type:type version:nil isHidden:NO isSecret:NO constraints:nil];
}

- (id)initWithName:(NSString *)name
             title:(NSString *)title
           summary:(NSString *)summary
      defaultValue:(NSString *)defaultValue
      currentValue:(NSString *)currentValue
             group:(NSString *)group
              type:(PropertyType)type
           version:(NSString *)version
          isHidden:(BOOL)isHidden
          isSecret:(BOOL)isSecret
       constraints:(NSArray *)constraints;
{
    self = [super init];
    if (self)
    {
        self.name = name;
        self.title = title;
        self.summary = summary;
        self.defaultValue = defaultValue;
        self.currentValue = currentValue;
        self.group = group;
        self.version = version;
        self.type = type;
        self.isHidden = isHidden;
        self.isSecret = isSecret;
        self.constraints = constraints;
        
        if (self.title == nil)
        {
            self.title = self.name;
        }
        if (self.version == nil)
        {
            self.version = @"0";
        }
    }
    return self;
}

@end
