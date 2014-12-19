//
//  AlfrescoFormDateCell.h
//  DynamicFormPrototype
//
//  Created by Gavin Cornwell on 14/05/2014.
//  Copyright (c) 2014 Gavin Cornwell. All rights reserved.
//

#import "AlfrescoFormPickerCell.h"
#import "AlfrescoDatePickerViewController.h"

@interface AlfrescoFormDateCell : AlfrescoFormPickerCell <AlfrescoDatePickerDelegate>

@property (nonatomic, assign) BOOL showTime;

@end
