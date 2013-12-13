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
 Preference constants
 */
NSString * const kPreferenceVersion = @"preference_version";
NSString * const kPreferenceUrl = @"preference_url";

/**
 URL constants
 */
NSString * const kUrlPathApiV1 = @"/api/v1";
NSString * const kUrlPathTests = @"/tests";
NSString * const kUrlPathRuns = @"/runs";
NSString * const kUrlPathState = @"/state";
NSString * const kUrlPathSchedule = @"/schedule";

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
NSString * const kJSONVersion = @"version";
NSString * const kJSONValue = @"value";
NSString * const kJSONScheduled = @"scheduled";
NSString * const kJSONStarted = @"started";
NSString * const kJSONDuration = @"duration";
NSString * const kJSONResultsTotal = @"resultsTotal";
NSString * const kJSONResultsSuccess = @"resultsSuccess";
NSString * const kJSONResultsFail = @"resultsFail";
NSString * const kJSONSuccessRate = @"successRate";
NSString * const kJSONProgress = @"progress";
NSString * const kJSONCompleted = @"completed";
NSString * const kJSONStopped = @"stopped";
NSString * const kJSONState = @"state";
NSString * const kJSONStateNotScheduled = @"state.not_scheduled";
NSString * const kJSONStateScheduled = @"state.scheduled";
NSString * const kJSONStateStarted = @"state.started";
NSString * const kJSONStateStopped = @"state.stopped";
NSString * const kJSONStateCompleted = @"state.completed";

/**
 Error constants
 */
NSString * const kErrorBenchmarkDomain = @"BenchmarkLabErrorDomain";
NSString * const kErrorInvalidJSONReceived = @"Invalid JSON response received";

@end
