//
//  BenchmarksViewController.h
//  Benchmark
//
//  Created by Gavin Cornwell on 14/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BenchmarkService.h"

@interface TestsViewController : UITableViewController

- (id)initWithBenchmarkService:(id<BenchmarkService>)service;

@end
