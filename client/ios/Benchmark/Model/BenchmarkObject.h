//
//  BenchmarkObject.h
//  Benchmark
//
//  Created by Gavin Cornwell on 04/10/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BenchmarkObject : NSObject

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *notes;
@property (strong, nonatomic, readonly) NSArray *properties;

- (id)initWithName:(NSString *)name
             notes:(NSString *)notes
        properties:(NSArray *)properties;

@end
