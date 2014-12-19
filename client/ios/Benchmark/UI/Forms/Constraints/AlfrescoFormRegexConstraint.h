//
//  AlfrescoFormRegexConstraint.h
//  DynamicFormPrototype
//
//  Created by Gavin Cornwell on 18/11/2014.
//  Copyright (c) 2014 Gavin Cornwell. All rights reserved.
//

#import "AlfrescoFormConstraint.h"

extern NSString * const kAlfrescoFormConstraintRegex;

@interface AlfrescoFormRegexConstraint : AlfrescoFormConstraint

@property (nonatomic, strong, readonly) NSRegularExpression *regex;

- (instancetype)initWithRegex:(NSRegularExpression *)regex;

@end
