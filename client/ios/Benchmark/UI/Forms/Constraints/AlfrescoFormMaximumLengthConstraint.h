//
//  AlfrescoFormMaximumLengthConstraint.h
//  DynamicFormPrototype
//
//  Created by Gavin Cornwell on 18/11/2014.
//  Copyright (c) 2014 Gavin Cornwell. All rights reserved.
//

#import "AlfrescoFormConstraint.h"

extern NSString * const kAlfrescoFormConstraintMaximumLength;

@interface AlfrescoFormMaximumLengthConstraint : AlfrescoFormConstraint

@property (nonatomic, strong, readonly) NSNumber *maximumLength;

- (instancetype)initWithMaximumLength:(NSNumber *)maximumLength;

@end
