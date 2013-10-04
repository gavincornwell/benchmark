//
//  Run.h
//  Benchmark
//
//  Created by Gavin Cornwell on 14/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BenchmarkObject.h"

@interface Run : BenchmarkObject

@property (nonatomic, assign, readonly) BOOL hasStarted;
@property (nonatomic, assign, readonly) BOOL hasCompleted;

- (id)initWithName:(NSString *)name
             notes:(NSString *)notes
        properties:(NSArray *)properties
        hasStarted:(BOOL)hasStarted
      hasCompleted:(BOOL)hasCompleted;

@end
