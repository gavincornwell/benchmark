//
//  PropertiesViewController.h
//  Benchmark
//
//  Created by Gavin Cornwell on 18/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BenchmarkService.h"

@interface PropertiesViewController : UITableViewController

- (id)initWithBenchmarkObject:(BenchmarkObject *)object editable:(BOOL)editable benchmarkService:(id<BenchmarkService>)service;

@end
