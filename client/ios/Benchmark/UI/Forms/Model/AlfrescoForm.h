//
//  AlfrescoForm.h
//  DynamicFormPrototype
//
//  Created by Gavin Cornwell on 14/05/2014.
//  Copyright (c) 2014 Gavin Cornwell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlfrescoFormField.h"
#import "AlfrescoFormFieldGroup.h"

@interface AlfrescoForm : NSObject

/**
 Title of the form
 */
@property (nonatomic, strong) NSString *title;

/**
 List of AlfrescoFormFieldGroup objects
 */
@property (nonatomic, strong, readonly) NSArray *groups;

/**
 List of AlfrescoFormField objects
 */
@property (nonatomic, strong, readonly) NSArray *fields;

/**
 List of outcomes
 */
@property (nonatomic, strong, readonly) NSArray *outcomes;

/**
 Creates an AlfrescoForm object with the given groups and title
 */
- (instancetype)initWithGroups:(NSArray *)groups title:(NSString *)title;

/**
 Creates an AlfrescoForm object with the given groups, title and outcomes
 */
- (instancetype)initWithGroups:(NSArray *)groups title:(NSString *)title outcomes:(NSArray *)outcomes;

/**
 Returns the field group with the given identifier, nil if it doesn't exist
 */
- (AlfrescoFormFieldGroup *)groupWithIdentifier:(NSString *)identifier;

/**
 Returns the field with the given identifier, nil if it doesn't exist
 */
- (AlfrescoFormField *)fieldWithIdentifier:(NSString *)identifier;

@end
