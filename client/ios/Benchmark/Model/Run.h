//
//  Run.h
//  Benchmark
//
//  Created by Gavin Cornwell on 14/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Run : NSObject

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *notes;
@property (strong, nonatomic, readonly) NSArray *properties;
@property (nonatomic, assign, readonly) BOOL hasStarted;
@property (nonatomic, assign, readonly) BOOL hasCompleted;

- (id)initWithName:(NSString *)name
             notes:(NSString *)notes
        properties:(NSArray *)properties
        hasStarted:(BOOL)hasStarted
      hasCompleted:(BOOL)hasCompleted;

@end
