//
//  BenchmarkLabService.h
//  Benchmark
//
//  Created by Gavin Cornwell on 14/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BenchmarkService.h"

@interface BenchmarkLabService : NSObject <BenchmarkService>

- (id)initWithURL:(NSURL *)url;

@end
