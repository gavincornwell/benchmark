//
//  Constants.h
//  Benchmark
//
//  Created by Gavin Cornwell on 14/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

/**---------------------------------------------------------------------------------------
 * @name Preference constants
 --------------------------------------------------------------------------------------- */
extern NSString * const kPreferenceVersion;
extern NSString * const kPreferenceUrl;

/**---------------------------------------------------------------------------------------
 * @name URL constants
 --------------------------------------------------------------------------------------- */
extern NSString * const kUrlPathApiV1;
extern NSString * const kUrlPathTests;
extern NSString * const kUrlPathRuns;
extern NSString * const kUrlPathState;
extern NSString * const kUrlPathSchedule;

/**---------------------------------------------------------------------------------------
 * @name JSON constants
 --------------------------------------------------------------------------------------- */
extern NSString * const kJSONId;
extern NSString * const kJSONOId;
extern NSString * const kJSONName;
extern NSString * const kJSONTitle;
extern NSString * const kJSONDescription;
extern NSString * const kJSONProperties;
extern NSString * const kJSONGroup;
extern NSString * const kJSONType;
extern NSString * const kJSONDefault;
extern NSString * const kJSONHide;
extern NSString * const kJSONMask;
extern NSString * const kJSONVersion;
extern NSString * const kJSONValue;
extern NSString * const kJSONStarted;
extern NSString * const kJSONCompleted;
extern NSString * const kJSONScheduled;
extern NSString * const kJSONStarted;
extern NSString * const kJSONDuration;
extern NSString * const kJSONResultsTotal;
extern NSString * const kJSONResultsSuccess;
extern NSString * const kJSONResultsFail;
extern NSString * const kJSONSuccessRate;
extern NSString * const kJSONProgress;
extern NSString * const kJSONStopped;
extern NSString * const kJSONState;
extern NSString * const kJSONStateNotScheduled;
extern NSString * const kJSONStateScheduled;
extern NSString * const kJSONStateStarted;
extern NSString * const kJSONStateStopped;
extern NSString * const kJSONStateCompleted;

/**---------------------------------------------------------------------------------------
 * @name Error constants
 --------------------------------------------------------------------------------------- */
extern NSString * const kErrorBenchmarkDomain;
extern NSString * const kErrorInvalidJSONReceived;


@end
