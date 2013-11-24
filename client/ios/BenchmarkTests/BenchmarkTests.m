//
//  BenchmarkTests.m
//  BenchmarkTests
//
//  Created by Gavin Cornwell on 14/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "BenchmarkTests.h"
#import "BenchmarkService.h"
#import "Utils.h"
#import "Property.h"

@implementation BenchmarkTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testBooleanRetrieval
{
    NSString *yesKey = @"testYes";
    NSString *noKey = @"testNo";
    
    NSDictionary *yesBoolDict = [NSDictionary dictionaryWithObject:@YES forKey:yesKey];
    STAssertTrue([Utils retrieveBoolFromDictionary:yesBoolDict withKey:yesKey], @"Expected to retrieve YES from dictionary");
    
    NSDictionary *noBoolDict = @{noKey: @NO};
    STAssertFalse([Utils retrieveBoolFromDictionary:noBoolDict withKey:noKey], @"Expected to retrieve NO from dictionary");
    
    NSDictionary *yesStringLowercaseDict = @{yesKey: @"true"};
    STAssertTrue([Utils retrieveBoolFromDictionary:yesStringLowercaseDict withKey:yesKey], @"Expected to retrieve YES from dictionary");
    
    NSDictionary *yesStringUppercaseDict = @{yesKey: @"TRUE"};
    STAssertTrue([Utils retrieveBoolFromDictionary:yesStringUppercaseDict withKey:yesKey], @"Expected to retrieve YES from dictionary");
    
    NSDictionary *yesStringMixedcaseDict = @{yesKey: @"True"};
    STAssertTrue([Utils retrieveBoolFromDictionary:yesStringMixedcaseDict withKey:yesKey], @"Expected to retrieve YES from dictionary");
    
    NSDictionary *noStringLowercaseDict = @{noKey: @"false"};
    STAssertFalse([Utils retrieveBoolFromDictionary:noStringLowercaseDict withKey:noKey], @"Expected to retrieve NO from dictionary");
    
    NSDictionary *noStringUppercaseDict = @{noKey: @"FALSE"};
    STAssertFalse([Utils retrieveBoolFromDictionary:noStringUppercaseDict withKey:noKey], @"Expected to retrieve NO from dictionary");
    
    NSDictionary *noStringMixedcaseDict = @{noKey: @"False"};
    STAssertFalse([Utils retrieveBoolFromDictionary:noStringMixedcaseDict withKey:noKey], @"Expected to retrieve NO from dictionary");
}

- (void)testPropertyInitialisation
{
    Property *property1 = [[Property alloc] initWithName:@"test" defaultValue:@"default" type:PropertyTypeInteger];
    STAssertTrue([property1.name isEqualToString:@"test"], @"Expected name property to be 'test'");
    STAssertTrue([property1.defaultValue isEqualToString:@"default"], @"Expected defaultValue property to be 'default'");
    STAssertTrue(property1.type == PropertyTypeInteger, @"Expected type property to be of type Integer");
    STAssertTrue(property1.version == 0, @"Expected version property to be 0");
    STAssertFalse(property1.isHidden, @"Expected isHidden property to be NO");
    STAssertFalse(property1.isSecret, @"Expected isSecret property to be NO");
    STAssertNil(property1.summary, @"Expected summary property to be nil");
    STAssertNil(property1.currentValue, @"Expected currentValue property to be nil");
}

@end
