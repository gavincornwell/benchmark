//
//  Utils.m
//  Benchmark
//
//  Created by Gavin Cornwell on 15/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "Utils.h"
#import "Constants.h"

@implementation Utils

+ (void)assertArgumentNotNil:(id)argument argumentName:(NSString *)argumentName
{
    if (nil == argument)
    {
        NSString * message = [NSString stringWithFormat:@"%@ must not be nil", argumentName];
        NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException reason:message userInfo:nil];
        @throw exception;
    }
}

+ (BOOL)retrieveBoolFromDictionary:(NSDictionary *)dictionary withKey:(NSString *)key
{
    BOOL result = NO;
    
    id obj = [dictionary objectForKey:key];
    if (obj != nil)
    {
        if ([obj isKindOfClass:[NSString class]])
        {
            NSString *secretStr = (NSString *)obj;            
            if ([[secretStr lowercaseString] isEqualToString:@"true"])
            {
                result = YES;
            }
        }
        else
        {
            result = [obj boolValue];
        }
    }
    
    return result;
}

+ (NSDate *)retrieveDateFromDictionary:(NSDictionary *)dictionary withKey:(NSString *)key
{
    NSDate *date;
    
    id obj = [dictionary objectForKey:key];
    if (obj != nil)
    {
        if ([obj isKindOfClass:[NSNumber class]])
        {
            NSNumber *seconds = (NSNumber *)obj;
            if ([seconds doubleValue] != -1)
            {
                NSTimeInterval timeInterval = [seconds doubleValue];
                date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            }
        }
    }
    
    return date;
}

+ (NSError *)createErrorWithMessage:(NSString *)message
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:kErrorBenchmarkDomain code:1000 userInfo:userInfo];
}

+ (void)displayErrorMessage:(NSString *)message
{
    [Utils displayError:[Utils createErrorWithMessage:message]];
}

+ (void)displayError:(NSError *)error
{
    NSString *message = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
    
    if (message == nil)
    {
        message = error.localizedDescription;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    [alert show];
}

+ (void)displayInfoMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
