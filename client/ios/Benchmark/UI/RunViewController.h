//
//  RunViewController.h
//  Benchmark
//
//  Created by Gavin Cornwell on 18/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BenchmarkService.h"

@interface RunViewController : UITableViewController

- (id)initWithRun:(Run *)run benchmarkService:(id<BenchmarkService>)service;

@end
