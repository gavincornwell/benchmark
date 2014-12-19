//
//  AlfrescoFormHiddenCell.m
//  DynamicFormPrototype
//
//  Created by Gavin Cornwell on 17/11/2014.
//  Copyright (c) 2014 Gavin Cornwell. All rights reserved.
//

#import "AlfrescoFormHiddenCell.h"

@implementation AlfrescoFormHiddenCell

- (instancetype)init
{
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}

- (void)configureCell
{
    self.hidden = YES;
}

@end
