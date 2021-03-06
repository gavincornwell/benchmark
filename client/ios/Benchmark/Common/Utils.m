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
    
    id obj = dictionary[key];
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
    
    id obj = dictionary[key];
    if (obj != nil)
    {
        if ([obj isKindOfClass:[NSNumber class]])
        {
            NSNumber *milliSeconds = (NSNumber *)obj;
            if ([milliSeconds unsignedLongLongValue] != -1)
            {
                unsigned long long seconds = [milliSeconds unsignedLongLongValue] / 1000;
                date = [NSDate dateWithTimeIntervalSince1970:seconds];
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
    NSString *message = error.userInfo[NSLocalizedDescriptionKey];
    
    if (message == nil)
    {
        message = error.localizedDescription;
    }
    
    if ([message rangeOfString:@"conflict (409)"].location != NSNotFound)
    {
        message = kErrorConflict;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kUITitleError
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:kUILabelCancel
                                          otherButtonTitles:nil];
    [alert show];
}

+ (void)displayInfoMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:kUILabelOK
                                          otherButtonTitles:nil];
    [alert show];
}

@end
