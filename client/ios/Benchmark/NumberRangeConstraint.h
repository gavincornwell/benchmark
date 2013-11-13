//
//  NumberRangeConstraint.h
//  Benchmark
//
//  Created by Gavin Cornwell on 12/11/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constraint.h"

@interface NumberRangeConstraint : NSObject <Constraint>

- (id)initWithMin:(NSNumber *)min max:(NSNumber *)max;

@end
