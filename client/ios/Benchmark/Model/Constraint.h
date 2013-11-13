//
//  Constraint.h
//  Benchmark
//
//  Created by Gavin Cornwell on 12/11/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Constraint <NSObject>

- (BOOL)isValidString:(NSString *)value;

@end
