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
@property (assign, nonatomic, readonly) PropertyType type;
@property (strong, nonatomic, readwrite) id value;
@property (strong, nonatomic, readonly) id defaultValue;
@property (assign, nonatomic, readonly) BOOL hasValueChanged;

- (id)initWithName:(NSString *)name
             value:(id)value
      defaultValue:(id)defaultValue
              type:(PropertyType)type;

@end
