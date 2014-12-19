//
//  AlfrescoFormListOfValuesCell.m
//  DynamicFormPrototype
//
//  Created by Gavin Cornwell on 22/05/2014.
//  Copyright (c) 2014 Gavin Cornwell. All rights reserved.
//

#import "AlfrescoFormListOfValuesCell.h"
#import "AlfrescoFormListOfValuesConstraint.h"

@interface AlfrescoFormListOfValuesCell ()
@property (nonatomic, weak) UINavigationController *navigationController;
@end

@implementation AlfrescoFormListOfValuesCell

- (void)didSelectCellWithNavigationController:(UINavigationController *)navigationController
{
    // find the list of values constraint
    AlfrescoFormListOfValuesConstraint *constraint = (AlfrescoFormListOfValuesConstraint *)[self.field constraintWithIdentifier:kAlfrescoFormConstraintListOfValues];
    AlfrescoListOfValuesPickerViewController *listOfValuesVC = [[AlfrescoListOfValuesPickerViewController alloc] initWithListOfValues:constraint.values
                                                                                                                               labels:constraint.labels
                                                                                                                        selectedValue:self.field.value];
    listOfValuesVC.delegate = self;
    self.navigationController = navigationController;
    [self.navigationController pushViewController:listOfValuesVC animated:YES];
}

- (void)listOfValuesPicker:(AlfrescoListOfValuesPickerViewController *)listOfValuesPicker didSelectValue:(id)value label:(NSString *)label
{
    self.field.value = value;
    
    // update the cell to display new value
    self.detailTextLabel.text = label;
    
    NSLog(@"List of values field %@ was edited, value changed to %@", self.field.identifier, self.field.value);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAlfrescoFormFieldChangedNotification object:self.field];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
