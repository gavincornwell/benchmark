//
//  AddRunFormViewController.m
//  Benchmark
//
//  Created by Gavin Cornwell on 19/12/2014.
//  Copyright (c) 2014 Alfresco. All rights reserved.
//

#import "AddRunFormViewController.h"
#import "Constants.h"
#import "Utils.h"
#import "AlfrescoFormMandatoryConstraint.h"

@interface AddRunFormViewController ()
@property (nonatomic, strong) Test *test;
@property (nonatomic, strong) id<BenchmarkService> benchmarkService;
@end

@implementation AddRunFormViewController

- (instancetype)initWithTest:(Test *)test benchmarkService:(id<BenchmarkService>)service;
{
    self = [super init];
    if (self)
    {
        self.test = test;
        self.benchmarkService = service;
    }
    
    return self;
}

#pragma mark - Form view data source

- (AlfrescoForm *)formForFormViewController:(AlfrescoFormViewController *)formViewController
{
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
                                                                                fields:@[nameField, descriptionField]
                                                                                 label:nil];
    
    return [[AlfrescoForm alloc] initWithGroups:@[group] title:kUITitleAddRun];
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
    
    NSString *name = nameField.value;
    NSString *description = descriptionField.value;
    
    if (name)
    {
        __weak AddRunFormViewController *weakSelf = self;
        [self.benchmarkService addRunToTest:self.test name:name summary:description completionHandler:^(Run *run, NSError *error) {
            if (run)
            {
                // post notification that a run has been added
                [[NSNotificationCenter defaultCenter] postNotificationName:kRunAddedNotification object:run];
                
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
