//
//  AlfrescoFormViewController.h
//  DynamicFormPrototype
//
//  Created by Gavin Cornwell on 12/11/2014.
//  Copyright (c) 2014 Gavin Cornwell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlfrescoForm.h"

@class AlfrescoFormViewController;

@protocol AlfrescoFormViewControllerDelegate <NSObject>

@optional

// Informs the delegate that the user pressed an outcome button
- (BOOL)formViewController:(AlfrescoFormViewController *)formViewController willEndEditingWithOutcome:(NSString *)outcome;

// Informs the delegate that the form has finished being edited
- (void)formViewController:(AlfrescoFormViewController *)formViewController didEndEditingWithOutcome:(NSString *)outcome;

// Informs the delegate that the user pressed the cancel button
- (BOOL)willCancelEditingOfFormViewController:(AlfrescoFormViewController *)formViewController;

// Informs the delegate that form editing has been cancelled
- (void)didCancelEditingOfFormViewController:(AlfrescoFormViewController *)formViewController;

// Determines whether the cancel button should be displayed
- (BOOL)shouldShowCancelButtonForFormViewContoller:(AlfrescoFormViewController *)formViewController;

@end

// completion block definition used to return a form to a form view controller
typedef void (^AlfrescoFormCompletionBlock)(AlfrescoForm *form, NSError *error);

@protocol AlfrescoFormViewControllerDataSource <NSObject>

@optional

// Requests the form object from the delegate
- (AlfrescoForm *)formForFormViewController:(AlfrescoFormViewController *)formViewController;

// Asynchronously requests the form object from the delegate
- (void)formViewController:(AlfrescoFormViewController *)formViewController loadFormWithCompletionBlock:(AlfrescoFormCompletionBlock)completionBlock;

@end


// NOTE: This extends UITableViewController for now but in the future to support more than
//       one column this will extend UIViewController and the appropriate view controller
//       implementation will be determined internally.

@interface AlfrescoFormViewController : UITableViewController <AlfrescoFormViewControllerDelegate, AlfrescoFormViewControllerDataSource>

@property (nonatomic, weak) id<AlfrescoFormViewControllerDelegate> delegate;
@property (nonatomic, weak) id<AlfrescoFormViewControllerDataSource> dataSource;

@property (nonatomic, strong, readonly) AlfrescoForm *form;

@end

