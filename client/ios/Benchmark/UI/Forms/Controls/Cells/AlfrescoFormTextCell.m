//
//  AlfrescoFormTextCell.m
//  DynamicFormPrototype
//
//  Created by Gavin Cornwell on 09/04/2014.
//  Copyright (c) 2014 Gavin Cornwell. All rights reserved.
//

#import "AlfrescoFormTextCell.h"

@implementation AlfrescoFormTextCell

- (instancetype)init
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    return [nib lastObject];
}

- (void)configureCell
{
    [super configureCell];
    
    // set text field value
    if (self.field.type == AlfrescoFormFieldTypeNumber)
    {
        self.textField.text = [self.field.value stringValue];
    }
    else
    {
        self.textField.text = self.field.value;
    }
    
    // set text alignment
    self.textField.textAlignment = NSTextAlignmentLeft;
    if (self.field.controlParameters[kAlfrescoFormControlParameterTextAlignment])
    {
        NSString *alignment = self.field.controlParameters[kAlfrescoFormControlParameterTextAlignment];
        if ([alignment isEqualToString:@"right"])
        {
            self.textField.textAlignment = NSTextAlignmentRight;
        }
    }
    
    // set placeholder text
    if (self.field.placeholderText != nil)
    {
        self.textField.placeholder = self.field.placeholderText;
    }
    
    // set border style
    if (self.field.controlParameters[kAlfrescoFormControlParameterShowBorder])
    {
        self.textField.borderStyle = UITextBorderStyleRoundedRect;
    }
    
    // disable if the field is readonly
    if (self.field.readOnly)
    {
        self.textField.enabled = NO;
    }
    else
    {
        // setup keyboard type, if necessary
        if (self.field.type == AlfrescoFormFieldTypeNumber)
        {
            if (self.field.controlParameters[kAlfrescoFormControlParameterAllowDecimals])
            {
                [self.textField setKeyboardType:UIKeyboardTypeDecimalPad];
            }
            else
            {
                [self.textField setKeyboardType:UIKeyboardTypeNumberPad];
            }
        }
        else if (self.field.type == AlfrescoFormFieldTypeEmail)
        {
            [self.textField setKeyboardType:UIKeyboardTypeEmailAddress];
        }
        else if (self.field.type == AlfrescoFormFieldTypeURL)
        {
            [self.textField setKeyboardType:UIKeyboardTypeURL];
        }
        
        // set other text field options
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        
        if (self.field.controlParameters[kAlfrescoFormControlParameterSecret])
        {
            self.textField.secureTextEntry = YES;
        }
        
        if (self.field.controlParameters[kAlfrescoFormControlParameterAllowReset])
        {
            self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }
        
        // setup event handler
        [self.textField addTarget:self action:@selector(fieldEdited:) forControlEvents:UIControlEventEditingChanged];
    }
}

- (void)fieldEdited:(id)sender
{
    if (self.textField.text.length == 0)
    {
        self.field.value = nil;
    }
    else
    {
        if (self.field.type == AlfrescoFormFieldTypeNumber)
        {
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterNoStyle];
            self.field.value = [formatter numberFromString:self.textField.text];
        }
        else
        {
            self.field.value = self.textField.text;
        }
    }
    
    NSLog(@"Text field %@ was edited, value changed to %@", self.field.identifier, self.field.value);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAlfrescoFormFieldChangedNotification object:self.field];
}

@end
