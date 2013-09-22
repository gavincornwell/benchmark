//
//  Test.h
//  Benchmark
//
//  Created by Gavin Cornwell on 14/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Test : NSObject

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *notes;
@property (strong, nonatomic, readonly) NSArray *properties;

- (id)initWithName:(NSString *)name
             notes:(NSString *)notes
        properties:(NSArray *)properties;

@end
