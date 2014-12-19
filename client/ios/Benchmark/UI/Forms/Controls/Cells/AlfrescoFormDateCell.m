//
//  AlfrescoFormDateCell.m
//  DynamicFormPrototype
//
//  Created by Gavin Cornwell on 14/05/2014.
//  Copyright (c) 2014 Gavin Cornwell. All rights reserved.
//

#import "AlfrescoFormDateCell.h"

@interface AlfrescoFormDateCell ()
@property (nonatomic, weak) UINavigationController *navigationController;
@end

@implementation AlfrescoFormDateCell

- (void)configureCellValue
{
    [self renderValue];
}

- (void)didSelectCellWithNavigationController:(UINavigationController *)navigationController
{
    AlfrescoDatePickerViewController *datePickerVC = [[AlfrescoDatePickerViewController alloc] initWithDate:self.field.value];
    datePickerVC.delegate = self;
    datePickerVC.showTime = self.showTime;
    
    self.navigationController = navigationController;
    [self.navigationController pushViewController:datePickerVC animated:YES];
}

- (void)datePicker:(AlfrescoDatePickerViewController *)datePicker didSelectDate:(NSDate *)date
{
    self.field.value = date;
    
    NSLog(@"Date field %@ was edited, value changed to %@", self.field.identifier, self.field.value);
    
    // update the cell to display new date
    [self renderValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAlfrescoFormFieldChangedNotification object:self.field];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)renderValue
{
    NSDate *date = self.field.value;
    if (date != nil)
    {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        
        if (self.showTime)
        {
            dateFormatter.timeStyle = NSDateFormatterMediumStyle;
        }
        
        self.detailTextLabel.text = [dateFormatter stringFromDate:date];
    }
}

@end
