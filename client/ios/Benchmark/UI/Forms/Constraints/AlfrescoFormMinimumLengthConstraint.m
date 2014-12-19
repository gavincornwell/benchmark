//
//  AlfrescoFormMinimumLengthConstraint.m
//  DynamicFormPrototype
//
//  Created by Gavin Cornwell on 18/11/2014.
//  Copyright (c) 2014 Gavin Cornwell. All rights reserved.
//

#import "AlfrescoFormMinimumLengthConstraint.h"

NSString * const kAlfrescoFormConstraintMinimumLength = @"minimumLength";

@interface AlfrescoFormMinimumLengthConstraint ()
@property (nonatomic, strong, readwrite) NSNumber *minimumLength;
@end

@implementation AlfrescoFormMinimumLengthConstraint

- (instancetype)initWithMinimumLength:(NSNumber *)minimumLength;
{
    self = [self initWithIdentifier:kAlfrescoFormConstraintMinimumLength];
    if (self)
    {
        NSAssert(minimumLength, @"minimumLength parameter must be provided");
        
        self.minimumLength = minimumLength;
        
        self.errorMessage = [NSString stringWithFormat:@"The value must have a length of at least %@", minimumLength];
    }
    return self;
}

- (BOOL)evaluate:(id)value
{
    // return immediately if value is nil
    if (value == nil) return NO;
    
    BOOL valid = NO;
    
    if ([value isKindOfClass:[NSString class]])
    {
        valid = (((NSString *)value).length >= [self.minimumLength unsignedLongValue]);
    }
    else if ([value isKindOfClass:[NSNumber class]])
    {
        NSString *stringValue = ((NSNumber *)value).stringValue;
        valid = (stringValue.length >= [self.minimumLength unsignedLongValue]);
    }
    
    return valid;
}

@end
