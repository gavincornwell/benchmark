//
//  AddRunFormViewController.h
//  Benchmark
//
//  Created by Gavin Cornwell on 19/12/2014.
//  Copyright (c) 2014 Alfresco. All rights reserved.
//

#import "AlfrescoFormViewController.h"
#import "BenchmarkService.h"

@interface AddRunFormViewController : AlfrescoFormViewController

- (instancetype)initWithTest:(Test *)test benchmarkService:(id<BenchmarkService>)service;

@end
