//
//  NumberRangeConstraint.m
//  Benchmark
//
//  Created by Gavin Cornwell on 12/11/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "NumberRangeConstraint.h"

@interface NumberRangeConstraint()
@property (strong, nonatomic, readwrite) NSNumber *min;
@property (strong, nonatomic, readwrite) NSNumber *max;
@end

@implementation NumberRangeConstraint

- (id)initWithMin:(NSNumber *)min max:(NSNumber *)max
{
    self = [super init];
    if (self)
    {
        self.min = min;
        self.max = max;
    }
    return self;
}

- (BOOL)isValidString:(NSString *)value
{
    BOOL isValid = NO;
    
    NSNumber *num = [[[NSNumberFormatter alloc] init] numberFromString:value];
    
    if (num != nil)
    {
        // if the provided value is the same as the min or max value it's valid
        // if the provided value is greater than the min and less than the max it's valid
        if([num compare:self.min] == NSOrderedSame ||
           [num compare:self.max] == NSOrderedSame ||
           ([num compare:self.min] == NSOrderedDescending && [num compare:self.max] == NSOrderedAscending))
        {
            isValid = YES;
        }
    }
    
    return isValid;
}

@end
