//
//  AlfrescoFormListOfValuesConstraint.m
//  DynamicFormPrototype
//
//  Created by Gavin Cornwell on 22/05/2014.
//  Copyright (c) 2014 Gavin Cornwell. All rights reserved.
//

#import "AlfrescoFormListOfValuesConstraint.h"

NSString * const kAlfrescoFormConstraintListOfValues = @"listOfValues";

@interface AlfrescoFormListOfValuesConstraint ()
@property (nonatomic, strong, readwrite) NSArray *values;
@property (nonatomic, strong, readwrite) NSArray *labels;
@end

@implementation AlfrescoFormListOfValuesConstraint

- (instancetype)initWithValues:(NSArray *)values labels:(NSArray *)labels;
{
    self = [self initWithIdentifier:kAlfrescoFormConstraintListOfValues];
    if (self)
    {
        NSAssert(values, @"values parameter must be provided");
        NSAssert(labels, @"labels parameter must be provided");
        
        self.values = values;
        self.labels = labels;
        
        self.errorMessage = [NSString stringWithFormat:@"The value must match one of the following values: %@", values];
    }
    return self;
}

- (BOOL)evaluate:(id)value
{
    // return immediately if value is nil
    if (value == nil) return NO;
    
    BOOL valid = NO;
    
    // TODO: make this checking more rigorous
    for (NSObject *allowableValue in self.values)
    {
        if ([[allowableValue description] isEqualToString:[value description]])
        {
            valid = YES;
            break;
        }
    }
    
    return valid;
}

@end
