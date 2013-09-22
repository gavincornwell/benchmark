//
//  Utils.m
//  Benchmark
//
//  Created by Gavin Cornwell on 15/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "Utils.h"

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

@end
