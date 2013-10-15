//
//  Property.h
//  Benchmark
//
//  Created by Gavin Cornwell on 16/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    PropertyTypeString = 0,
    PropertyTypeInteger,
    PropertyTypeDecimal
    
} PropertyType;

@interface Property : NSObject

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSString *description;
@property (strong, nonatomic, readonly) NSString *originalValue;
@property (strong, nonatomic, readonly) NSString *group;
@property (assign, nonatomic, readonly) PropertyType type;
@property (assign, nonatomic, readonly) BOOL isVisible;
@property (assign, nonatomic, readonly) BOOL isSecret;
@property (strong, nonatomic, readwrite) NSString *currentValue;

- (id)initWithName:(NSString *)name
             title:(NSString *)title
     originalValue:(NSString *)originalValue
              type:(PropertyType)type;

- (id)initWithDictionary:(NSDictionary *)properties;

@end
