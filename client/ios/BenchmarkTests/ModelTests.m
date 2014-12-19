//
//  ModelTests.m
//  Benchmark
//
//  Created by Gavin Cornwell on 12/12/2014.
//  Copyright (c) 2014 Alfresco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Utils.h"
#import "Property.h"

@interface ModelTests : XCTestCase

@end

@implementation ModelTests

- (void)testBooleanRetrieval
{
    NSString *yesKey = @"testYes";
    NSString *noKey = @"testNo";
    
    NSDictionary *yesBoolDict = [NSDictionary dictionaryWithObject:@YES forKey:yesKey];
    XCTAssertTrue([Utils retrieveBoolFromDictionary:yesBoolDict withKey:yesKey], @"Expected to retrieve YES from dictionary");
    
    NSDictionary *noBoolDict = @{noKey: @NO};
    XCTAssertFalse([Utils retrieveBoolFromDictionary:noBoolDict withKey:noKey], @"Expected to retrieve NO from dictionary");
    
    NSDictionary *yesStringLowercaseDict = @{yesKey: @"true"};
    XCTAssertTrue([Utils retrieveBoolFromDictionary:yesStringLowercaseDict withKey:yesKey], @"Expected to retrieve YES from dictionary");
    
    NSDictionary *yesStringUppercaseDict = @{yesKey: @"TRUE"};
    XCTAssertTrue([Utils retrieveBoolFromDictionary:yesStringUppercaseDict withKey:yesKey], @"Expected to retrieve YES from dictionary");
    
    NSDictionary *yesStringMixedcaseDict = @{yesKey: @"True"};
    XCTAssertTrue([Utils retrieveBoolFromDictionary:yesStringMixedcaseDict withKey:yesKey], @"Expected to retrieve YES from dictionary");
    
    NSDictionary *noStringLowercaseDict = @{noKey: @"false"};
    XCTAssertFalse([Utils retrieveBoolFromDictionary:noStringLowercaseDict withKey:noKey], @"Expected to retrieve NO from dictionary");
    
    NSDictionary *noStringUppercaseDict = @{noKey: @"FALSE"};
    XCTAssertFalse([Utils retrieveBoolFromDictionary:noStringUppercaseDict withKey:noKey], @"Expected to retrieve NO from dictionary");
    
    NSDictionary *noStringMixedcaseDict = @{noKey: @"False"};
    XCTAssertFalse([Utils retrieveBoolFromDictionary:noStringMixedcaseDict withKey:noKey], @"Expected to retrieve NO from dictionary");
}

- (void)testPropertyInitialisation
{
    Property *property1 = [[Property alloc] initWithName:@"test" defaultValue:@"default" type:PropertyTypeInteger];
    XCTAssertTrue([property1.name isEqualToString:@"test"], @"Expected name property to be 'test'");
    XCTAssertTrue([property1.defaultValue isEqualToString:@"default"], @"Expected defaultValue property to be 'default'");
    XCTAssertTrue(property1.type == PropertyTypeInteger, @"Expected type property to be of type Integer");
    XCTAssertTrue(property1.version == 0, @"Expected version property to be 0");
    XCTAssertFalse(property1.isHidden, @"Expected isHidden property to be NO");
    XCTAssertFalse(property1.isSecret, @"Expected isSecret property to be NO");
    XCTAssertNil(property1.summary, @"Expected summary property to be nil");
    XCTAssertNil(property1.currentValue, @"Expected currentValue property to be nil");
}

@end
