//
//  AddTestFormViewController.m
//  Benchmark
//
//  Created by Gavin Cornwell on 19/12/2014.
//  Copyright (c) 2014 Alfresco. All rights reserved.
//

#import "AddTestFormViewController.h"
#import "Constants.h"
#import "TestDefinition.h"
#import "Utils.h"
#import "AlfrescoFormMandatoryConstraint.h"
#import "AlfrescoFormListOfValuesConstraint.h"

@interface AddTestFormViewController ()
@property (nonatomic, strong) NSArray *testDefinitions;
@property (nonatomic, strong) id<BenchmarkService> benchmarkService;
@end

@implementation AddTestFormViewController

- (instancetype)initWithTestDefinitons:(NSArray *)testDefinitions benchmarkService:(id<BenchmarkService>)service
{
    self = [super init];
    if (self)
    {
        self.testDefinitions = testDefinitions;
        self.benchmarkService = service;
    }
    
    return self;
}

#pragma mark - Form view data source

- (AlfrescoForm *)formForFormViewController:(AlfrescoFormViewController *)formViewController
{
    // define test definitions field
    AlfrescoFormField *definitionField = [[AlfrescoFormField alloc] initWithIdentifier:kFieldIdentifierDefinition
                                                                                  type:AlfrescoFormFieldTypeString
                                                                                 value:nil
                                                                                 label:kUILabelDefinition];
    NSMutableArray *values = [NSMutableArray array];
    NSMutableArray *labels = [NSMutableArray array];
    for (TestDefinition *definition  in self.testDefinitions)
    {
        [values addObject:definition.identifier];
        [labels addObject:definition.name];
    }
    AlfrescoFormListOfValuesConstraint *constraint = [[AlfrescoFormListOfValuesConstraint alloc] initWithValues:values labels:labels];
    [definitionField addConstraint:constraint];
    [definitionField addConstraint:[AlfrescoFormMandatoryConstraint new]];
    
    // define name field
    AlfrescoFormField *nameField = [[AlfrescoFormField alloc] initWithIdentifier:kFieldIdentifierName
                                                                            type:AlfrescoFormFieldTypeString
                                                                           value:nil
                                                                           label:kUILabelName];
    [nameField addConstraint:[AlfrescoFormMandatoryConstraint new]];
    nameField.placeholderText = kUILabelName;
    
    // define description field
    AlfrescoFormField *descriptionField = [[AlfrescoFormField alloc] initWithIdentifier:kFieldIdentifierDescription
                                                                                   type:AlfrescoFormFieldTypeString
                                                                                  value:nil
                                                                                  label:kUILabelDescription];
    descriptionField.placeholderText = kUILabelDescription;
    
    // create group and form
    AlfrescoFormFieldGroup *group = [[AlfrescoFormFieldGroup alloc] initWithIdentifier:@"default"
                                                                                fields:@[definitionField, nameField, descriptionField]
                                                                                 label:nil];
    
    return [[AlfrescoForm alloc] initWithGroups:@[group] title:kUITitleAddTest];
}

#pragma mark - Form view delegate

- (BOOL)shouldShowCancelButtonForFormViewContoller:(AlfrescoFormViewController *)formViewController
{
    return YES;
}

- (void)didCancelEditingOfFormViewController:(AlfrescoFormViewController *)formViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)formViewController:(AlfrescoFormViewController *)formViewController didEndEditingWithOutcome:(NSString *)outcome
{
    AlfrescoFormField *nameField = [formViewController.form fieldWithIdentifier:kFieldIdentifierName];
    AlfrescoFormField *descriptionField = [formViewController.form fieldWithIdentifier:kFieldIdentifierDescription];
    AlfrescoFormField *definitionField = [formViewController.form fieldWithIdentifier:kFieldIdentifierDefinition];
    
    NSString *name = nameField.value;
    NSString *description = descriptionField.value;
    NSString *definitionId = definitionField.value;
    
    TestDefinition *testDefinition = nil;
    for (TestDefinition *definition in self.testDefinitions)
    {
        if ([definition.identifier isEqualToString:definitionId])
        {
            testDefinition = definition;
            break;
        }
    }
    
    if (testDefinition && name)
    {
        __weak AddTestFormViewController *weakSelf = self;
        [self.benchmarkService addTestWithDefinition:testDefinition name:name summary:description completionHandler:^(Test *test, NSError *error) {
            if (test)
            {
                // post notification that a test has been added
                [[NSNotificationCenter defaultCenter] postNotificationName:kTestAddedNotification object:test];
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [Utils displayError:error];
            }
        }];
    }
}

@end
