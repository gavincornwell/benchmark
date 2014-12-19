//
//  AlfrescoForm.m
//  DynamicFormPrototype
//
//  Created by Gavin Cornwell on 14/05/2014.
//  Copyright (c) 2014 Gavin Cornwell. All rights reserved.
//

#import "AlfrescoForm.h"

@interface AlfrescoForm ()
@property (nonatomic, strong, readwrite) NSArray *groups;
@property (nonatomic, strong, readwrite) NSArray *outcomes;
@end

@implementation AlfrescoForm

- (instancetype)initWithGroups:(NSArray *)groups title:(NSString *)title
{
    return [self initWithGroups:groups title:title outcomes:nil];
}

- (instancetype)initWithGroups:(NSArray *)groups title:(NSString *)title outcomes:(NSArray *)outcomes
{
    self = [super init];
    if (self)
    {
        NSAssert(groups, @"groups parameter must be provided.");
        
        self.groups = groups;
        self.title = title;
        self.outcomes = outcomes;
    }
    
    return self;
}

- (NSArray *)fields
{
    NSMutableArray *fields = [NSMutableArray array];
    
    for (AlfrescoFormFieldGroup *group in self.groups)
    {
        [fields addObjectsFromArray:group.fields];
    }
    
    return fields;
}

- (AlfrescoFormFieldGroup *)groupWithIdentifier:(NSString *)identifier
{
    // TODO: store groups in a dictionary to avoid loop below.
    
    for (AlfrescoFormFieldGroup *group in self.groups)
    {
        if ([group.identifier isEqualToString:identifier])
        {
            return group;
        }
    }
    
    return nil;
}

- (AlfrescoFormField *)fieldWithIdentifier:(NSString *)identifier
{
    // TODO: store fields in a dictionary to avoid loop below.
    
    for (AlfrescoFormField *field in self.fields)
    {
        if ([field.identifier isEqualToString:identifier])
        {
            return field;
        }
    }
    
    return nil;
}

@end
