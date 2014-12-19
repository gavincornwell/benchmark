//
//  AlfrescoFormRegexConstraint.m
//  DynamicFormPrototype
//
//  Created by Gavin Cornwell on 18/11/2014.
//  Copyright (c) 2014 Gavin Cornwell. All rights reserved.
//

#import "AlfrescoFormRegexConstraint.h"

NSString * const kAlfrescoFormConstraintRegex = @"regex";

@interface AlfrescoFormRegexConstraint ()
@property (nonatomic, strong, readwrite) NSRegularExpression *regex;
@end

@implementation AlfrescoFormRegexConstraint

- (instancetype)initWithRegex:(NSRegularExpression *)regex
{
    self = [self initWithIdentifier:kAlfrescoFormConstraintRegex];
    if (self)
    {
        NSAssert(regex, @"regex parameter must be provided");
        
        self.regex = regex;
        
        self.errorMessage = [NSString stringWithFormat:@"The value must match the pattern %@", regex.pattern];
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
        NSString *stringValue = (NSString *)value;
        
        NSRange textRange = NSMakeRange(0, stringValue.length);
        NSRange matchRange = [self.regex rangeOfFirstMatchInString:stringValue
                                                           options:NSMatchingReportProgress
                                                             range:textRange];
        if (matchRange.location != NSNotFound)
        {
            valid = YES;
        }
    }
    
    return valid;
}

@end
