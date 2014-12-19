//
//  AlfrescoFormField.h
//  DynamicFormPrototype
//
//  Created by Gavin Cornwell on 14/05/2014.
//  Copyright (c) 2014 Gavin Cornwell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlfrescoFormConstraint.h"

extern NSString * const kAlfrescoFormControlParameterCustomClassName;
extern NSString * const kAlfrescoFormControlParameterAllowReset;
extern NSString * const kAlfrescoFormControlParameterAllowDecimals;
extern NSString * const kAlfrescoFormControlParameterShowBorder;
extern NSString * const kAlfrescoFormControlParameterTextAlignment;
extern NSString * const kAlfrescoFormControlParameterSecret;

typedef NS_ENUM(NSInteger, AlfrescoFormFieldType)
{
    AlfrescoFormFieldTypeString = 0,
    AlfrescoFormFieldTypeBoolean,
    AlfrescoFormFieldTypeNumber,
    AlfrescoFormFieldTypeDate,
    AlfrescoFormFieldTypeDateTime,
    AlfrescoFormFieldTypeEmail,
    AlfrescoFormFieldTypeURL,
    AlfrescoFormFieldTypeHidden,
    AlfrescoFormFieldTypeCustom,
    AlfrescoFormFieldTypeUnknown
};

@interface AlfrescoFormField : NSObject

@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, assign, readonly) AlfrescoFormFieldType type;
@property (nonatomic, strong, readonly) id originalValue;
@property (nonatomic, strong, readonly) NSArray *constraints;
@property (nonatomic, assign, readonly, getter = isRequired) BOOL required;

@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *placeholderText;
@property (nonatomic, strong) id value;
@property (nonatomic, assign, getter = isReadOnly) BOOL readOnly;
@property (nonatomic, strong) NSDictionary *controlParameters;

- (instancetype)initWithIdentifier:(NSString *)identifier type:(AlfrescoFormFieldType)type value:(id)value label:(NSString *)label;

- (void)addConstraint:(AlfrescoFormConstraint *)constraint;
- (AlfrescoFormConstraint *)constraintWithIdentifier:(NSString *)identifier;

+ (NSString *)stringForFieldType:(AlfrescoFormFieldType)type;
+ (AlfrescoFormFieldType)enumForTypeString:(NSString *)typeString;

@end
