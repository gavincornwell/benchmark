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
extern NSString * const kPreferenceTestData;

/**---------------------------------------------------------------------------------------
 * @name URL constants
 --------------------------------------------------------------------------------------- */
extern NSString * const kUrlPathApiV1;
extern NSString * const kUrlPathTests;
extern NSString * const kUrlPathRuns;

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

/**---------------------------------------------------------------------------------------
 * @name Error constants
 --------------------------------------------------------------------------------------- */
extern NSString * const kErrorBenchmarkDomain;
extern NSString * const kErrorInvalidJSONReceived;


@end
