//
//  Utils.h
//  Benchmark
//
//  Created by Gavin Cornwell on 15/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (void)assertArgumentNotNil:(id)argument argumentName:(NSString *)argumentName;
+ (BOOL)retrieveBoolFromDictionary:(NSDictionary *)dictionary withKey:(NSString *)key;
+ (NSDate *)retrieveDateFromDictionary:(NSDictionary *)dictionary withKey:(NSString *)key;
+ (NSError *)createErrorWithMessage:(NSString *)message;
+ (void)displayErrorMessage:(NSString *)message;
+ (void)displayError:(NSError *)error;
+ (void)displayInfoMessage:(NSString *)message;


@end
