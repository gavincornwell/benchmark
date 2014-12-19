//
//  AlfrescoFormViewController.m
//  DynamicFormPrototype
//
//  Created by Gavin Cornwell on 12/11/2014.
//  Copyright (c) 2014 Gavin Cornwell. All rights reserved.
//

#import "AlfrescoFormViewController.h"
#import "AlfrescoFormFieldGroup.h"
#import "AlfrescoFormCell.h"
#import "AlfrescoFormDateCell.h"
#import "AlfrescoFormListOfValuesCell.h"
#import "AlfrescoFormInformationCell.h"
#import "AlfrescoFormBooleanCell.h"
#import "AlfrescoFormTextCell.h"
#import "AlfrescoformHiddenCell.h"
#import "AlfrescoFormListOfValuesConstraint.h"

@interface AlfrescoFormViewController ()
@property (nonatomic, strong, readwrite) AlfrescoForm *form;
@property (nonatomic, strong) NSMutableDictionary *cells;
@end

@implementation AlfrescoFormViewController

#pragma mark - Initialisation

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(evaluateFormState)
                                                 name:kAlfrescoFormFieldChangedNotification
                                               object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // determine whether to attempt to load the form asynchronously
    if ([self.dataSource respondsToSelector:@selector(formViewController:loadFormWithCompletionBlock:)])
    {
        [self.dataSource formViewController:self loadFormWithCompletionBlock:^(AlfrescoForm *form, NSError *error) {
            if (form)
            {
                self.form = form;
                [self configureForm];
                [self.tableView reloadData];
            }
            else
            {
                // create an error alert
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Form Load Failed"
                                                                          message:[error localizedDescription]
                                                                         delegate:nil
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil, nil];
                
                // show error alert on the main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    [errorAlert show];
                });
            }
        }];
    }
    else if ([self.dataSource respondsToSelector:@selector(formForFormViewController:)])
    {
        self.form = [self.dataSource formForFormViewController:self];
        [self configureForm];
    }
}

- (void)configureForm
{
    // add the required outcome buttons
    if (self.form.outcomes.count > 0)
    {
        NSMutableArray *buttons = [NSMutableArray array];
        
        // add a button for each outcome
        for (int x = 0; x < self.form.outcomes.count; x++)
        {
            NSString *outcome = [self.form.outcomes objectAtIndex:x];
            
            UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:outcome
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(outcomeButtonTapped:)];
            
            // tag the button so we can identify which one got tapped later on
            button.tag = x;
            
            // add button to array
            [buttons addObject:button];
        }
        
        // add all the buttons
        self.navigationItem.rightBarButtonItems = buttons;
    }
    else
    {
        // add a single done button
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                               target:self
                                                                                               action:@selector(outcomeButtonTapped:)];
    }
    
    // add a cancel button, if required
    if ([self.delegate respondsToSelector:@selector(shouldShowCancelButtonForFormViewContoller:)])
    {
        if ([self.delegate shouldShowCancelButtonForFormViewContoller:self])
        {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                                  target:self
                                                                                                  action:@selector(cancelButtonTapped:)];
        }
    }
    
    // set form title
    self.title = self.form.title;
    
    self.cells = [NSMutableDictionary dictionary];
    
    // create a cell for each field in the form
    for (AlfrescoFormFieldGroup *group in self.form.groups)
    {
        for (AlfrescoFormField *field in group.fields)
        {
            AlfrescoFormCell *formCell = nil;
            
            if (field.type == AlfrescoFormFieldTypeString || field.type == AlfrescoFormFieldTypeNumber ||
                field.type == AlfrescoFormFieldTypeEmail || field.type == AlfrescoFormFieldTypeURL)
            {
                if (field.readOnly)
                {
                    formCell = [AlfrescoFormInformationCell new];
                }
                else
                {
                    AlfrescoFormConstraint *constraint = [field constraintWithIdentifier:kAlfrescoFormConstraintListOfValues];
                    if (constraint != nil)
                    {
                        formCell = [AlfrescoFormListOfValuesCell new];
                    }
                    else
                    {
                        formCell = [AlfrescoFormTextCell new];
                    }
                }
            }
            else if (field.type == AlfrescoFormFieldTypeBoolean)
            {
                formCell = [AlfrescoFormBooleanCell new];
            }
            else if (field.type == AlfrescoFormFieldTypeDate)
            {
                formCell = [AlfrescoFormDateCell new];
            }
            else if (field.type == AlfrescoFormFieldTypeDateTime)
            {
                formCell = [AlfrescoFormDateCell new];
                ((AlfrescoFormDateCell *)formCell).showTime = YES;
            }
            else if (field.type == AlfrescoFormFieldTypeCustom)
            {
                // temporarily create an information cell for custom fields
                formCell = [AlfrescoFormInformationCell new];
            }
            else if (field.type == AlfrescoFormFieldTypeHidden)
            {
                formCell = [AlfrescoFormHiddenCell new];
            }
            else
            {
                // throw exeception if we can't handle the field
                @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                               reason:[NSString stringWithFormat:@"%@ field has an unrecognised type", field.identifier] userInfo:nil];
            }
            
            // finish common configuration of the cell and store it
            formCell.field = field;
            self.cells[field.identifier] = formCell;
        }
    }
    
    // set the state of the form
    [self evaluateFormState];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
}

#pragma mark - Form view data source

- (AlfrescoForm *)formForFormViewController:(AlfrescoFormViewController *)formViewController
{
    // return an empty form by default
    return [AlfrescoForm new];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.form)
    {
        // Return the number of groups
        return self.form.groups.count;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.form)
    {
        // Return the number of fields in the group.
        AlfrescoFormFieldGroup *group = self.form.groups[section];
        return group.fields.count;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.form)
    {
        return [self formCellForIndexPath:indexPath];
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadingCell"];
        cell.textLabel.text = @"Loading Form...";
        return cell;
    }
}

#pragma mark - Table view delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.form)
    {
        AlfrescoFormFieldGroup *group = self.form.groups[section];
        return group.label;
    }
    else
    {
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (self.form)
    {
        AlfrescoFormFieldGroup *group = self.form.groups[section];
        return group.summary;
    }
    else
    {
        return nil;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.form)
    {
        AlfrescoFormCell *formCell = [self formCellForIndexPath:indexPath];
        
        if (formCell.isSelectable)
        {
            return indexPath;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlfrescoFormCell *formCell = [self formCellForIndexPath:indexPath];
    [formCell didSelectCellWithNavigationController:self.navigationController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlfrescoFormCell *formCell = [self formCellForIndexPath:indexPath];
    
    if ([formCell isKindOfClass:[AlfrescoFormHiddenCell class]])
    {
        return 0;
    }
    else
    {
        return 44;
    }
}

#pragma mark - Event handlers

- (void)outcomeButtonTapped:(id)sender
{
    NSString *outcomeTapped = nil;
    BOOL allowEditingToEnd = YES;
    
    if (self.form.outcomes.count > 0)
    {
        // outcomes are present so determine which button was tapped
        outcomeTapped = [self.form.outcomes objectAtIndex:((UIBarButtonItem *)sender).tag];
    }
    
    if ([self.delegate respondsToSelector:@selector(formViewController:willEndEditingWithOutcome:)])
    {
        allowEditingToEnd = [self.delegate formViewController:self willEndEditingWithOutcome:outcomeTapped];
    }
    
    if (allowEditingToEnd && [self.delegate respondsToSelector:@selector(formViewController:didEndEditingWithOutcome:)])
    {
        [self.delegate formViewController:self didEndEditingWithOutcome:outcomeTapped];
    }
}

- (void)cancelButtonTapped:(id)sender
{
    BOOL allowCancel = YES;
    
    if ([self.delegate respondsToSelector:@selector(willCancelEditingOfFormViewController:)])
    {
        allowCancel = [self.delegate willCancelEditingOfFormViewController:self];
    }
    
    if (allowCancel && [self.delegate respondsToSelector:@selector(didCancelEditingOfFormViewController:)])
    {
        [self.delegate didCancelEditingOfFormViewController:self];
    }
}

- (void)evaluateFormState
{
    BOOL isFormValid = YES;
    
    UIImage *image = [UIImage imageNamed:@"validation-error"];
    
    // iterate round all fields and check their constraints, if they all pass the form is valid.
    for (AlfrescoFormField *field in self.form.fields)
    {
        // evaluate all constraints for the field
        for (AlfrescoFormConstraint *constraint in field.constraints)
        {
            // retrieve the cell for the current field
            AlfrescoFormCell *cell = self.cells[field.identifier];
            
            if ([constraint evaluate:field.value])
            {
                NSLog(@"%@ constraint for field %@ passed", constraint.identifier, field.identifier);
                
                if (!cell.selectable)
                {
                    cell.accessoryView = nil;
                }
            }
            else
            {
                NSLog(@"%@ constraint for field %@ failed", constraint.identifier, field.identifier);
                
                isFormValid = NO;
                
                if (!cell.selectable)
                {
                    // show validation error marker
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                    cell.accessoryView = imageView;
                    cell.detailTextLabel.text = @"Validation error";
                }
                
                break;
            }
        }
    }
    
    // if form is not valid disable the outcome button(s)
    if (self.form.outcomes.count > 0)
    {
        for (UIBarButtonItem *button in self.navigationItem.rightBarButtonItems)
        {
            button.enabled = isFormValid;
        }
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = isFormValid;
    }
}

#pragma mark - Helper methods

- (AlfrescoFormCell *)formCellForIndexPath:(NSIndexPath *)indexPath
{
    AlfrescoFormFieldGroup *group = self.form.groups[indexPath.section];
    AlfrescoFormField *field = group.fields[indexPath.row];
    return self.cells[field.identifier];
}

@end
