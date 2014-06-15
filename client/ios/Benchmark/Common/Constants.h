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
 * @name UI constants - These will be localised in the future
 --------------------------------------------------------------------------------------- */
extern NSString * const kUITitleTests;
extern NSString * const kUITitleGeneral;
extern NSString * const kUITitleProperties;
extern NSString * const kUITitleEditProperty;
extern NSString * const kUITitleError;

extern NSString * const kUILabelOK;
extern NSString * const kUILabelCancel;
extern NSString * const kUILabelSave;
extern NSString * const kUILabelSaving;
extern NSString * const kUILabelDelete;
extern NSString * const kUILabelDeleting;
extern NSString * const kUILabelLoading;
extern NSString * const kUILabelScheduled;
extern NSString * const kUILabelStatus;
extern NSString * const kUILabelStarted;
extern NSString * const kUILabelCompleted;
extern NSString * const kUILabelRunningTime;
extern NSString * const kUILabelProgress;
extern NSString * const kUILabelSuccessRate;
extern NSString * const kUILabelResultCount;
extern NSString * const kUILabelSuccessCount;
extern NSString * const kUILabelFailCount;
extern NSString * const kUILabelScheduling;
extern NSString * const kUILabelStopping;
extern NSString * const kUILabelNoValue;

extern NSString * const kUIPasswordMask;
extern NSString * const kUIConfigureUrl;
extern NSString * const kUIRunningTimeFormat;

/**---------------------------------------------------------------------------------------
 * @name Preference constants
 --------------------------------------------------------------------------------------- */
extern NSString * const kPreferenceVersion;
extern NSString * const kPreferenceUrl;

/**---------------------------------------------------------------------------------------
 * @name URL constants
 --------------------------------------------------------------------------------------- */
extern NSString * const kUrlPathApiV1;
extern NSString * const kUrlPathTestDefinitions;
extern NSString * const kUrlPathTests;
extern NSString * const kUrlPathRuns;
extern NSString * const kUrlPathSummary;
extern NSString * const kUrlPathSchedule;
extern NSString * const kUrlPathTerminate;

/**---------------------------------------------------------------------------------------
 * @name JSON constants
 --------------------------------------------------------------------------------------- */
extern NSString * const kJSONId;
extern NSString * const kJSONOId;
extern NSString * const kJSONRelease;
extern NSString * const kJSONSchema;
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
extern NSString * const kJSONTypeString;
extern NSString * const kJSONTypeDecimal;
extern NSString * const kJSONTypeInt;
extern NSString * const kJSONTypeBoolean;

/**---------------------------------------------------------------------------------------
 * @name Error constants
 --------------------------------------------------------------------------------------- */
extern NSString * const kErrorBenchmarkDomain;
extern NSString * const kErrorInvalidJSONReceived;


@end
