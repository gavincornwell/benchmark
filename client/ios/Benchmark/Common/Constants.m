//
//  Constants.m
//  Benchmark
//
//  Created by Gavin Cornwell on 14/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "Constants.h"

@implementation Constants

/**
 String constants
 */
NSString * const kUrlPreference = @"url_preference";
NSString * const kTestDataPreference = @"test_data_preference";

/**
 URL constants
 */
NSString * const kUrlPathApiV1 = @"/api/v1";
NSString * const kUrlPathTests = @"/tests";
NSString * const kUrlPathRuns = @"/runs";

/**
 JSON constants
 */
NSString * const kJSONId = @"_id";
NSString * const kJSONOId = @"$oid";
NSString * const kJSONName = @"name";
NSString * const kJSONTitle = @"title";
NSString * const kJSONDescription = @"description";
NSString * const kJSONProperties = @"properties";
NSString * const kJSONGroup = @"group";
NSString * const kJSONType = @"type";
NSString * const kJSONDefault = @"default";
NSString * const kJSONHide = @"hide";
NSString * const kJSONMask = @"mask";

/**
 Error constants
 */
NSString * const kErrorBenchmarkDomain = @"BenchmarkLabErrorDomain";
NSString * const kErrorInvalidJSONReceived = @"Invalid JSON response received";

@end
