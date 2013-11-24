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
@property (strong, nonatomic, readonly) NSString *summary;
@property (strong, nonatomic, readonly) NSString *defaultValue;
@property (strong, nonatomic, readonly) NSString *group;
@property (assign, nonatomic, readonly) PropertyType type;
@property (assign, nonatomic, readonly) BOOL isHidden;
@property (assign, nonatomic, readonly) BOOL isSecret;
@property (strong, nonatomic, readwrite) NSString *currentValue;
@property (strong, nonatomic, readwrite) NSNumber *version;

- (id)initWithName:(NSString *)name
      defaultValue:(NSString *)defaultValue
              type:(PropertyType)type;

- (id)initWithName:(NSString *)name
             title:(NSString *)title
           summary:(NSString *)summary
      defaultValue:(NSString *)defaultValue
      currentValue:(NSString *)currentValue
             group:(NSString *)group
              type:(PropertyType)type
           version:(NSNumber *)version
          isHidden:(BOOL)isHidden
          isSecret:(BOOL)isSecret;

@end
