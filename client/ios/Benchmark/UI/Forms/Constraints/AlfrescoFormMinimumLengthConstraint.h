//
//  AlfrescoFormMinimumLengthConstraint.h
//  DynamicFormPrototype
//
//  Created by Gavin Cornwell on 18/11/2014.
//  Copyright (c) 2014 Gavin Cornwell. All rights reserved.
//

#import "AlfrescoFormConstraint.h"

extern NSString * const kAlfrescoFormConstraintMinimumLength;

@interface AlfrescoFormMinimumLengthConstraint : AlfrescoFormConstraint

@property (nonatomic, strong, readonly) NSNumber *minimumLength;

- (instancetype)initWithMinimumLength:(NSNumber *)minimumLength;

@end
