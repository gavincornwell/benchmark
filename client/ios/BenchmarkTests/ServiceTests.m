//
//  ServiceTests.m
//  Benchmark
//
//  Created by Gavin Cornwell on 12/12/2014.
//  Copyright (c) 2014 Alfresco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BenchmarkLabService.h"
#import "TestDefinition.h"

@interface ServiceTests : XCTestCase
@property (nonatomic, strong) BenchmarkLabService *service;
@property (nonatomic, assign) NSTimeInterval testTimeout;
@end

@implementation ServiceTests

- (void)setUp
{
    [super setUp];
    
    self.testTimeout = 60.0;
    self.service = [[BenchmarkLabService alloc] initWithURL:[NSURL URLWithString:@"http://localhost:9080/alfresco-benchmark-server"]];
}

- (void)testRetrievalOfTestDefinitions
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test definition expectation"];
    
    [self.service retrieveTestDefinitionsWithCompletionBlock:^(NSArray *testDefinitions, NSError *error) {
        [expectation fulfill];
        
        XCTAssertNil(error, @"Did not expect error: %@", [self failureMessageFromError:error]);
        XCTAssertNotNil(testDefinitions, @"Expected to receive an array of test definitions");
        XCTAssertTrue(testDefinitions.count > 0, @"Expected there to be at least one test definition");
        
        TestDefinition *testDefinition = testDefinitions.firstObject;
        XCTAssertNotNil(testDefinition.identifier, @"Expected the identifier to be set");
        XCTAssertNotNil(testDefinition.name, @"Expected the name to be set");
        XCTAssertNotNil(testDefinition.schema, @"Expected the schema to be set");
    }];
    
    // wait for the tests to finish
    [self waitForExpectationsWithTimeout:self.testTimeout handler:nil];
}

- (void)testRetrievalOfTests
{
    XCTestExpectation *testDefExpectation = [self expectationWithDescription:@"Test definition expectation"];
    XCTestExpectation *addExpectation = [self expectationWithDescription:@"Add test expectation"];
    XCTestExpectation *testsExpectation = [self expectationWithDescription:@"Tests retrieval expectation"];
    XCTestExpectation *deleteExpectation = [self expectationWithDescription:@"Delete test expectation"];
    
    __weak BenchmarkLabService *weakService = self.service;
    
    // retrieve a test definition
    [weakService retrieveTestDefinitionsWithCompletionBlock:^(NSArray *testDefinitions, NSError *testDefsError) {
        [testDefExpectation fulfill];
        
        XCTAssertNil(testDefsError, @"Did not expect error: %@", [self failureMessageFromError:testDefsError]);
        XCTAssertNotNil(testDefinitions, @"Expected to receive an array of test definitions");
        XCTAssertTrue(testDefinitions.count > 0, @"Expected there to be at least one test definition");
        
        TestDefinition *testDefinition = testDefinitions.firstObject;
        if (testDefinition)
        {
            // add a test
            NSString *testName = [self generateTestName];
            [weakService addTestWithDefinition:testDefinition name:testName summary:testName completionHandler:^(Test *newTest, NSError *addError) {
                [addExpectation fulfill];
                
                XCTAssertNil(addError, @"Did not expect error: %@", [self failureMessageFromError:addError]);
                XCTAssertNotNil(newTest, @"Expected to receive a Test object");
                XCTAssertNotNil(newTest.identifier, @"Expected the identifier to be set");
                XCTAssertTrue([newTest.name isEqualToString:testName],
                              @"Expected name to be '%@' but it was: %@", testName, newTest.name);
                XCTAssertTrue([newTest.summary isEqualToString:testName],
                              @"Expected summary to be '%@' but it was: %@", testName, newTest.summary);
                XCTAssertTrue([newTest.version intValue] == 0,
                              @"Expected version to be '0' but it was: %@", newTest.version);
                
                // retrieve tests
                [weakService retrieveTestsWithCompletionBlock:^(NSArray *tests, NSError *testsError) {
                    [testsExpectation fulfill];
                    
                    XCTAssertNil(testsError, @"Did not expect error: %@", [self failureMessageFromError:testsError]);
                    XCTAssertNotNil(tests, @"Expected to receive an array of tests");
                    XCTAssertTrue(tests.count > 0, @"Expected there to be at least one test");
                    
                    // find the test we just created
                    BOOL createdTestFound = NO;
                    for (Test *test in tests)
                    {
                        if ([test.name isEqualToString:testName])
                        {
                            createdTestFound = YES;
                            break;
                        }
                    }
                    
                    XCTAssertTrue(createdTestFound, @"Expected to fing the test just created");
                    
                    // delete the test
                    [weakService deleteTest:newTest completionHandler:^(BOOL succeeded, NSError *deleteError) {
                        [deleteExpectation fulfill];
                        
                        XCTAssertNil(deleteError, @"Did not expect error: %@", [self failureMessageFromError:deleteError]);
                        XCTAssertTrue(succeeded, @"Expected the test to be deleted");
                    }];
                }];
            }];
        }
    }];
    
    // wait for the tests to finish
    [self waitForExpectationsWithTimeout:self.testTimeout handler:nil];
}

- (void)disabledtestRetrievalOfTestRuns
{
    XCTestExpectation *testDefExpectation = [self expectationWithDescription:@"Test definition expectation"];
    XCTestExpectation *addTestExpectation = [self expectationWithDescription:@"Add test expectation"];
    XCTestExpectation *addRunExpectation = [self expectationWithDescription:@"Add run expectation"];
    XCTestExpectation *runsExpectation = [self expectationWithDescription:@"Runs retrieval expectation"];
    XCTestExpectation *deleteRunExpectation = [self expectationWithDescription:@"Delete run expectation"];
    XCTestExpectation *deleteTestExpectation = [self expectationWithDescription:@"Delete test expectation"];
    
    __weak BenchmarkLabService *weakService = self.service;
    
    // retrieve a test definition
    [weakService retrieveTestDefinitionsWithCompletionBlock:^(NSArray *testDefinitions, NSError *testDefsError) {
        [testDefExpectation fulfill];
        
        TestDefinition *testDefinition = testDefinitions.firstObject;
        if (testDefinition)
        {
            // add a test
            NSString *testName = [self generateTestName];
            [weakService addTestWithDefinition:testDefinition name:testName summary:testName
                             completionHandler:^(Test *newTest, NSError *addTestError) {
                [addTestExpectation fulfill];
                
                if (newTest)
                {
                    // add a run to the test
                    NSString *runName = [self generateRunName];
                    [weakService addRunToTest:newTest name:runName summary:runName completionHandler:^(Run *newRun, NSError *addRunError) {
                        [addRunExpectation fulfill];
                    
                        XCTAssertNil(addRunError, @"Did not expect error: %@", [self failureMessageFromError:addRunError]);
                        XCTAssertNotNil(newRun, @"Expected to receive a Run object");
                        XCTAssertNotNil(newRun.identifier, @"Expected the identifier to be set");
                        XCTAssertTrue([newRun.name isEqualToString:runName],
                                      @"Expected name to be '%@' but it was: %@", runName, newRun.name);
                        XCTAssertTrue([newRun.summary isEqualToString:runName],
                                      @"Expected summary to be '%@' but it was: %@", runName, newRun.summary);
                        XCTAssertTrue([newRun.version intValue] == 0,
                                      @"Expected version to be '0' but it was: %@", newRun.version);
                        XCTAssertEqualObjects(newRun.test, newTest, @"Expected the Test objects to be the same");
                        XCTAssertTrue(newRun.state == RunStateNotScheduled, @"Expected state to be 'Not Scheduled' but it was: %u", newRun.state);
                        XCTAssertNil(newRun.scheduledStartTime, @"Expected scheduled start time to be nil but it was: %@", newRun.scheduledStartTime);
                        XCTAssertNil(newRun.timeStarted, @"Expected time started to be nil but it was: %@", newRun.timeStarted);
                        XCTAssertNil(newRun.timeCompleted, @"Expected time completed to be nil but it was: %@", newRun.timeCompleted);
                        XCTAssertNil(newRun.timeStopped, @"Expected time stopped to be nil but it was: %@", newRun.timeStopped);
                        
                        // retrieve runs for the test
                        [weakService retrieveRunsForTest:newTest completionHandler:^(NSArray *runs, NSError *runsError) {
                            [runsExpectation fulfill];
                            
                            // find the run we just created
                            BOOL createdRunFound = NO;
                            for (Run *run in runs)
                            {
                                if ([run.name isEqualToString:runName])
                                {
                                    createdRunFound = YES;
                                    break;
                                }
                            }
                            
                            XCTAssertTrue(createdRunFound, @"Expected to fing the run just created");
                            
                            // delete the run
                            [weakService deleteRun:newRun completionHandler:^(BOOL deleteRunSucceeded, NSError *deleteRunError) {
                                [deleteRunExpectation fulfill];
                                
                                XCTAssertNil(deleteRunError, @"Did not expect error: %@", [self failureMessageFromError:deleteRunError]);
                                XCTAssertTrue(deleteRunSucceeded, @"Expected the run to be deleted");
                                
                                // delete the test
                                [weakService deleteTest:newTest completionHandler:^(BOOL deleteTestSuccessful, NSError *deleteTestError) {
                                    [deleteTestExpectation fulfill];
                                    
                                    XCTAssertNil(deleteTestError, @"Did not expect error: %@", [self failureMessageFromError:deleteTestError]);
                                    XCTAssertTrue(deleteTestSuccessful, @"Expected the test to be deleted");
                                }];
                            }];
                        }];
                    }];
                }
            }];
        }
    }];
    
    // wait for the tests to finish
    [self waitForExpectationsWithTimeout:self.testTimeout handler:nil];
}

- (void)testPropertyEditing
{
    XCTestExpectation *testDefExpectation = [self expectationWithDescription:@"Get test definitions"];
    XCTestExpectation *addTestExpectation = [self expectationWithDescription:@"Add test"];
    XCTestExpectation *addRunExpectation = [self expectationWithDescription:@"Add run"];
    XCTestExpectation *testPropertiesExpectation = [self expectationWithDescription:@"Get test properties"];
    XCTestExpectation *updateTestPropertiesExpectation = [self expectationWithDescription:@"Update test property"];
    XCTestExpectation *runPropertiesExpectation = [self expectationWithDescription:@"Get run properties"];
    XCTestExpectation *deleteTestExpectation = [self expectationWithDescription:@"Delete test"];
    
    __weak BenchmarkLabService *weakService = self.service;
    
    // retrieve a test definition
    [weakService retrieveTestDefinitionsWithCompletionBlock:^(NSArray *testDefinitions, NSError *testDefsError) {
        [testDefExpectation fulfill];
        
        TestDefinition *testDefinition = testDefinitions.firstObject;
        if (testDefinition)
        {
            // add a test
            NSString *testName = [self generateTestName];
            [weakService addTestWithDefinition:testDefinition name:testName summary:testName
                             completionHandler:^(Test *newTest, NSError *addTestError) {
                [addTestExpectation fulfill];
             
                if (newTest)
                {
                    // get the test properties
                    [weakService retrievePropertiesOfBenchmarkObject:newTest completionHandler:^(NSArray *testProperties, NSError *testPropertiesError) {
                        [testPropertiesExpectation fulfill];
                        
                        XCTAssertNil(testPropertiesError, @"Did not expect error: %@", [self failureMessageFromError:testPropertiesError]);
                        XCTAssertNotNil(testProperties, @"Expected to receive an array of properties");
                        XCTAssertTrue(testProperties.count > 0, @"Expected there to be at least one property");
                        
                        // find the mongo host property
                        Property *mongoHostProperty = nil;
                        for (Property *property in testProperties)
                        {
                            if ([property.name isEqualToString:@"mongo.test.host"])
                            {
                                mongoHostProperty = property;
                                break;
                            }
                        }
                        
                        XCTAssertNotNil(mongoHostProperty, @"Expected to fing the 'mongo.test.host' property");
                        XCTAssertNil(mongoHostProperty.currentValue, @"Expected currentValue to be nil");
                        XCTAssertFalse(mongoHostProperty.isSecret, @"Expected isSecret to be false");
                        XCTAssertFalse(mongoHostProperty.isHidden, @"Expected isHidden to be false");
                        XCTAssertTrue([mongoHostProperty.title isEqualToString:@"mongo.test.host"],
                                      @"Expected title to be 'mongo.test.host' but it was: %@", mongoHostProperty.title);
                        XCTAssertTrue([mongoHostProperty.summary isEqualToString:@"The MongoDB server and port to connect to e.g. 127.0.0.1:27017"],
                                      @"Expected summary to be 'The MongoDB server and port to connect to e.g. 127.0.0.1:27017' but it was: %@", mongoHostProperty.summary);
                        XCTAssertTrue([mongoHostProperty.defaultValue isEqualToString:@"---:27017"],
                                      @"Expected defaultValue to be '---:27017' but it was: %@", mongoHostProperty.defaultValue);
                        XCTAssertTrue([mongoHostProperty.group isEqualToString:@"MongoDB Connection"],
                                      @"Expected group to be 'MongoDB Connection' but it was: %@", mongoHostProperty.group);
                        XCTAssertTrue(mongoHostProperty.type == PropertyTypeString,
                                      @"Expected type to be a string but it was: %u", mongoHostProperty.type);
                        XCTAssertTrue([mongoHostProperty.version intValue] == 0,
                                      @"Expected version to be '0' but it was: %@", mongoHostProperty.version);
                        
                        // set the property to 'localhost'
                        mongoHostProperty.currentValue = @"localhost";
                        [weakService updateProperty:mongoHostProperty ofBenchmarkObject:newTest completionHandler:^(BOOL succeeded, NSError *testPropertyUpdateError) {
                            [updateTestPropertiesExpectation fulfill];
                            
                            XCTAssertNil(testPropertyUpdateError, @"Did not expect error: %@", [self failureMessageFromError:testPropertyUpdateError]);
                            XCTAssertTrue(succeeded, @"Expected the property update operation to be successful");
                            
                            if (succeeded)
                            {
                                // add a run to the test
                                NSString *runName = [self generateRunName];
                                [weakService addRunToTest:newTest name:runName summary:runName completionHandler:^(Run *newRun, NSError *addRunError) {
                                    [addRunExpectation fulfill];
                                    
                                    if (newRun)
                                    {
                                        // get the run properties
                                        [weakService retrievePropertiesOfBenchmarkObject:newTest completionHandler:^(NSArray *runProperties, NSError *runPropertiesError) {
                                            [runPropertiesExpectation fulfill];
                                            
                                            XCTAssertNil(runPropertiesError, @"Did not expect error: %@", [self failureMessageFromError:runPropertiesError]);
                                            XCTAssertNotNil(runProperties, @"Expected to receive an array of properties");
                                            XCTAssertTrue(runProperties.count > 0, @"Expected there to be at least one property");
                                                                           
                                            // find the mongo host property
                                            Property *mongoHostProperty = nil;
                                            for (Property *property in testProperties)
                                            {
                                                if ([property.name isEqualToString:@"mongo.test.host"])
                                                {
                                                    mongoHostProperty = property;
                                                    break;
                                                }
                                            }
                                            
                                            XCTAssertNotNil(mongoHostProperty, @"Expected to fing the 'mongo.test.host' property");
                                            XCTAssertTrue([mongoHostProperty.currentValue isEqualToString:@"localhost"],
                                                          @"Expected 'mongo.test.host' property to be 'localhost' but it was: %@", mongoHostProperty.currentValue);
                                            
                                            // delete the test
                                            [weakService deleteTest:newTest completionHandler:^(BOOL succeeded, NSError *error) {
                                                [deleteTestExpectation fulfill];
                                            }];
                                        }];
                                    }
                                }];
                            }
                        }];
                    }];
                }
            }];
        }
    }];
    
    // wait for the tests to finish
    [self waitForExpectationsWithTimeout:self.testTimeout handler:nil];
}

- (void)testRunStartStop
{
    XCTestExpectation *testDefExpectation = [self expectationWithDescription:@"Get test definitions"];
    XCTestExpectation *addTestExpectation = [self expectationWithDescription:@"Add test"];
    XCTestExpectation *addRunExpectation = [self expectationWithDescription:@"Add run"];
    XCTestExpectation *updatePropertyExpectation = [self expectationWithDescription:@"Update property"];
    XCTestExpectation *startRunExpectation = [self expectationWithDescription:@"Start run"];
    XCTestExpectation *runStatusAfterScheduleExpectation = [self expectationWithDescription:@"Run status after schedule"];
    XCTestExpectation *runStatusAfterStopExpectation = [self expectationWithDescription:@"Run status after stop"];
    XCTestExpectation *stopRunExpectation = [self expectationWithDescription:@"Stop run"];
    XCTestExpectation *retrieveRunsExpectation = [self expectationWithDescription:@"Retrieve runs"];
    XCTestExpectation *deleteTestExpectation = [self expectationWithDescription:@"Delete test"];
    
    __weak BenchmarkLabService *weakService = self.service;
    
    // retrieve a test definition
    [weakService retrieveTestDefinitionsWithCompletionBlock:^(NSArray *testDefinitions, NSError *testDefsError) {
        [testDefExpectation fulfill];
        
        TestDefinition *testDefinition = testDefinitions.firstObject;
        if (testDefinition)
        {
            // add a test
            NSString *testName = [self generateTestName];
            [weakService addTestWithDefinition:testDefinition name:testName summary:testName completionHandler:^(Test *newTest, NSError *addTestError) {
                [addTestExpectation fulfill];
                                 
                if (newTest)
                {
                    // add a run to the test
                    NSString *runName = [self generateRunName];
                    [weakService addRunToTest:newTest name:runName summary:runName completionHandler:^(Run *newRun, NSError *addRunError) {
                        [addRunExpectation fulfill];
                                                     
                        if (newRun)
                        {
                            // update the mongo host property so the test run will execute
                            Property *mongoHostProperty = [[Property alloc] initWithName:@"mongo.test.host" defaultValue:nil type:PropertyTypeString];
                            mongoHostProperty.version = @(0);
                            mongoHostProperty.currentValue = @"localhost";
                            [weakService updateProperty:mongoHostProperty ofBenchmarkObject:newRun completionHandler:^(BOOL updatePropertySucceeded, NSError *updatePropertyError) {
                                [updatePropertyExpectation fulfill];
                                
                                XCTAssertNil(updatePropertyError, @"Did not expect error: %@", [self failureMessageFromError:updatePropertyError]);
                                XCTAssertTrue(updatePropertySucceeded, @"Expected the update property operation to be successful");
                            
                                if (updatePropertySucceeded)
                                {
                                    // start the run
                                    [weakService scheduleRun:newRun completionHandler:^(BOOL scheduleSucceeded, NSError *scheduleError) {
                                        [startRunExpectation fulfill];
                                        
                                        XCTAssertNil(scheduleError, @"Did not expect error: %@", [self failureMessageFromError:scheduleError]);
                                        XCTAssertTrue(scheduleSucceeded, @"Expected the schedule run operation to be successful");
                                        
                                        if (scheduleSucceeded)
                                        {
                                            // wait for 5 seconds for the run to start
                                            NSLog(@"Waiting 5 seconds for run to start...");
                                            [NSThread sleepForTimeInterval:5];
                                            
                                            // retrieve status
                                            [weakService retrieveStatusForRun:newRun completionHandler:^(RunStatus *status, NSError *statusError) {
                                                [runStatusAfterScheduleExpectation fulfill];
                                                
                                                XCTAssertNil(statusError, @"Did not expect error: %@", [self failureMessageFromError:statusError]);
                                                XCTAssertNotNil(status, @"Expected to receive a RunStatus object");
                                                XCTAssertNotNil(status.scheduledStartTime, @"Expected scheduledStartTime to be populated");
                                                XCTAssertNotNil(status.timeStarted, @"Expected timeStarted to be populated");
                                                
                                                // stop run
                                                [weakService stopRun:newRun completionHandler:^(BOOL stopSucceeded, NSError *stopError) {
                                                    [stopRunExpectation fulfill];
                                                    
                                                    XCTAssertNil(stopError, @"Did not expect error: %@", [self failureMessageFromError:stopError]);
                                                    XCTAssertTrue(stopSucceeded, @"Expected the stop run operation to be successful");
                                                    
                                                    // retrieve status again
                                                    [weakService retrieveStatusForRun:newRun completionHandler:^(RunStatus *status, NSError *error) {
                                                        [runStatusAfterStopExpectation fulfill];
                                                        
                                                        XCTAssertNil(statusError, @"Did not expect error: %@", [self failureMessageFromError:statusError]);
                                                        XCTAssertNotNil(status, @"Expected to receive a RunStatus object");
                                                        XCTAssertNotNil(status.scheduledStartTime, @"Expected scheduledStartTime to be populated");
                                                        XCTAssertNotNil(status.timeStarted, @"Expected timeStarted to be populated");
                                                        XCTAssertTrue(status.duration > 0, @"Expected duration to be more than 0");
                                                        
                                                        // retrieve runs and check status
                                                        [weakService retrieveRunsForTest:newTest completionHandler:^(NSArray *runs, NSError *runsError) {
                                                            [retrieveRunsExpectation fulfill];
                                                            
                                                            XCTAssertNil(runsError, @"Did not expect error: %@", [self failureMessageFromError:runsError]);
                                                            XCTAssertTrue(runs.count > 0, @"Expected there to be at least one run");
                                                            
                                                            // there's only one run so get first one in array
                                                            Run *retrievedRun = runs.firstObject;
                                                            XCTAssertNotNil(retrievedRun, @"Expected to find a run object");
                                                            XCTAssertNotNil(retrievedRun.timeStarted, @"Expected timeStarted to be populated");
                                                            XCTAssertNotNil(retrievedRun.timeStopped, @"Expected timeStopped to be populated");
                                                            XCTAssertNotNil(retrievedRun.scheduledStartTime, @"Expected scheduledStartTime to be populated");
                                                            XCTAssertNil(retrievedRun.timeCompleted, @"Expected timeCompleted to be nil");
                                                            XCTAssertTrue(retrievedRun.state == RunStateStopped,
                                                                          @"Expected run state to be stopped but it was %u", retrievedRun.state);
                                                            
                                                            // delete the test
                                                            [weakService deleteTest:newTest completionHandler:^(BOOL succeeded, NSError *error) {
                                                                [deleteTestExpectation fulfill];
                                                            }];
                                                        }];
                                                    }];
                                                }];
                                            }];
                                        }
                                    }];
                                }
                            }];
                        }
                    }];
                }
            }];
        }
    }];
    
    // wait for the tests to finish
    [self waitForExpectationsWithTimeout:self.testTimeout handler:nil];
}

- (NSString *)generateTestName
{
    NSString *name = [NSString stringWithFormat:@"TEST_%@", [[NSUUID UUID] UUIDString]];
    return [name stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
}

- (NSString *)generateRunName
{
    NSString *name = [NSString stringWithFormat:@"RUN_%@", [[NSUUID UUID] UUIDString]];
    return [name stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
}

- (NSString *)failureMessageFromError:(NSError *)error
{
    // just return if error has not been provided
    if (error == nil)
    {
        return nil;
    }
    
    NSString *message = error.localizedDescription;
    
    // add the failure reason, if there is one!
    if (error.localizedFailureReason != nil)
    {
        message = [message stringByAppendingFormat:@" - %@", error.localizedFailureReason];
    }
    else
    {
        // try looking for an underlying error and output the whole error object
        NSError *underlyingError = error.userInfo[NSUnderlyingErrorKey];
        if (underlyingError != nil)
        {
            message = [message stringByAppendingFormat:@" - %@", underlyingError];
        }
    }
    
    return message;
}

@end
