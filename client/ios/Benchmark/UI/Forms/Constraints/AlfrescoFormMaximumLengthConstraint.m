//
//  AlfrescoFormMaximumLengthConstraint.m
//  DynamicFormPrototype
//
//  Created by Gavin Cornwell on 18/11/2014.
//  Copyright (c) 2014 Gavin Cornwell. All rights reserved.
//

#import "AlfrescoFormMaximumLengthConstraint.h"

NSString * const kAlfrescoFormConstraintMaximumLength = @"maximumLength";

@interface AlfrescoFormMaximumLengthConstraint ()
@property (nonatomic, strong, readwrite) NSNumber *maximumLength;
@end

@implementation AlfrescoFormMaximumLengthConstraint

- (instancetype)initWithMaximumLength:(NSNumber *)maximumLength
{
    self = [self initWithIdentifier:kAlfrescoFormConstraintMaximumLength];
    if (self)
    {
        NSAssert(maximumLength, @"maximumLength parameter must be provided");
        
        self.maximumLength = maximumLength;
        
        self.errorMessage = [NSString stringWithFormat:@"The value must not have a length that exceeds %@", maximumLength];
    }
    return self;
}

- (BOOL)evaluate:(id)value
{
    // return immediately if value is nil
    if (value == nil) return YES;
    
    BOOL valid = NO;
    
    if ([value isKindOfClass:[NSString class]])
    {
        valid = (((NSString *)value).length <= [self.maximumLength unsignedLongValue]);
    }
    else if ([value isKindOfClass:[NSNumber class]])
    {
        NSString *stringValue = ((NSNumber *)value).stringValue;
        valid = (stringValue.length <= [self.maximumLength unsignedLongValue]);
    }
    
    return valid;
}

@end
