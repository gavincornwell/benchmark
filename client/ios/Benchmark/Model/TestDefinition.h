//
//  TestDefinition.h
//  Benchmark
//
//  Created by Gavin Cornwell on 23/05/2014.
//  Copyright (c) 2014 Alfresco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestDefinition : NSObject

@property (strong, nonatomic, readonly) NSString *identifier;
@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSNumber *schema;

- (id)initWithIdentifier:(NSString *)identifier
                    name:(NSString *)name
                  schema:(NSNumber *)schema;

@end
