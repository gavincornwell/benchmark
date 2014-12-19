//
//  AlfrescoFormPickerCell.m
//  DynamicFormPrototype
//
//  Created by Gavin Cornwell on 17/11/2014.
//  Copyright (c) 2014 Gavin Cornwell. All rights reserved.
//

#import "AlfrescoFormPickerCell.h"

@implementation AlfrescoFormPickerCell

- (void)configureCell
{
    [super configureCell];
    
    // allow the cell to be selected, if the field is not read only
    if (!self.field.readOnly)
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectable = YES;
    }
}

@end
