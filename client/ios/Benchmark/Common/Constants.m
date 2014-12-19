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
 UI constants
 */
NSString * const kUITitleTests = @"Tests";
NSString * const kUITitleGeneral = @"General";
NSString * const kUITitleProperties = @"Properties";
NSString * const kUITitleEditProperty = @"Edit Property";
NSString * const kUITitleError = @"Error";

NSString * const kUILabelOK = @"OK";
NSString * const kUILabelCancel = @"Cancel";
NSString * const kUILabelSave = @"Save";
NSString * const kUILabelSaving = @"Saving";
NSString * const kUILabelDelete = @"Delete";
NSString * const kUILabelDeleting = @"Deleting";
NSString * const kUILabelLoading = @"Loading";
NSString * const kUILabelScheduled = @"Scheduled";
NSString * const kUILabelStatus = @"Status";
NSString * const kUILabelStarted = @"Started";
NSString * const kUILabelStopped = @"Stopped";
NSString * const kUILabelCompleted = @"Completed";
NSString * const kUILabelRunningTime = @"Running Time";
NSString * const kUILabelProgress = @"Progress";
NSString * const kUILabelSuccessRate = @"Success Rate";
NSString * const kUILabelResultCount = @"Result Count";
NSString * const kUILabelSuccessCount = @"Success Count";
NSString * const kUILabelFailCount = @"Fail Count";
NSString * const kUILabelScheduling = @"Scheduling";
NSString * const kUILabelStopping = @"Stopping";
NSString * const kUILabelNoValue = @"-";

NSString * const kUIPasswordMask = @"*****";
NSString * const kUIConfigureUrl = @"Please configure a Benchmark Server URL in Settings and then re-launch the app.";
NSString * const kUIRunningTimeFormat = @"%lld seconds";

/**
 Preference constants
 */
NSString * const kPreferenceVersion = @"preference_version";
NSString * const kPreferenceUrl = @"preference_url";

/**
 URL constants
 */
NSString * const kUrlPathApiV1 = @"/api/v1";
NSString * const kUrlPathTestDefinitions = @"/test-defs?activeOnly=false";
NSString * const kUrlPathTests = @"/tests";
NSString * const kUrlPathRuns = @"/runs";
NSString * const kUrlPathSummary = @"/summary";
NSString * const kUrlPathSchedule = @"/schedule";
NSString * const kUrlPathTerminate = @"/terminate";

/**
 JSON constants
 */
NSString * const kJSONId = @"_id";
NSString * const kJSONOId = @"$oid";
NSString * const kJSONRelease = @"release";
NSString * const kJSONSchema = @"schema";
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
NSString * const kJSONStateNotScheduled = @"NOT_SCHEDULED";
NSString * const kJSONStateScheduled = @"SCHEDULED";
NSString * const kJSONStateStarted = @"STARTED";
NSString * const kJSONStateStopped = @"STOPPED";
NSString * const kJSONStateCompleted = @"COMPLETED";
NSString * const kJSONTypeString = @"STRING";
NSString * const kJSONTypeDecimal = @"DECIMAL";
NSString * const kJSONTypeInt = @"INT";
NSString * const kJSONTypeBoolean = @"BOOL";
NSString * const kJSONError = @"error";

NSString * const kRunStatusChangedNotification = @"RunStatusChangedNotification";

/**
 Error constants
 */
NSString * const kErrorBenchmarkDomain = @"BenchmarkLabErrorDomain";
NSString * const kErrorInvalidJSONReceived = @"Invalid JSON response received";
NSString * const kErrorConflict = @"The item has changed on the server, please refresh to get the latest version.";

@end
