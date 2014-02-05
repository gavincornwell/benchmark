//
//  EditPropertyViewController.m
//  Benchmark
//
//  Created by Gavin Cornwell on 25/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "EditPropertyViewController.h"
#import "Utils.h"
#import "MBProgressHUD.h"

@interface EditPropertyViewController ()
@property (nonatomic, strong, readwrite) id<BenchmarkService> benchmarkService;
@property (nonatomic, strong, readwrite) BenchmarkObject *benchmarkObject;
@property (nonatomic, strong, readwrite) Property *property;
@property (nonatomic, strong, readwrite) UITextField *textField;
@end

@implementation EditPropertyViewController

- (id)initWithProperty:(Property *)property ofBenchmarkObject:(BenchmarkObject *)object benchmarkService:(id<BenchmarkService>)service
{
    self = [super init];
    if (self)
    {
        self.property = property;
        self.benchmarkObject = object;
        self.benchmarkService = service;
    }
    
    return self;
}

#pragma mark - Utilities

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = kUITitleEditProperty;
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    
    // Please ignore the following hack! This will be replaced with in-place editing in 1.1
    CGRect frame;
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        if (UIInterfaceOrientationIsLandscape(deviceOrientation))
        {
            frame = CGRectMake(20, 100, 980, 40);
        }
        else
        {
            frame = CGRectMake(20, 100, 720, 40);
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(deviceOrientation))
        {
            frame = CGRectMake(20, 100, 440, 40);
        }
        else
        {
            frame = CGRectMake(20, 100, 280, 40);
        }
    }
    
    self.textField = [[UITextField alloc] initWithFrame:frame];
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    if (self.property.type == PropertyTypeInteger)
    {
        [self.textField setKeyboardType:UIKeyboardTypeNumberPad];
    }
    else if (self.property.type == PropertyTypeDecimal)
    {
        [self.textField setKeyboardType:UIKeyboardTypeDecimalPad];
    }
    
    if (self.property.isSecret)
    {
        self.textField.secureTextEntry = YES;
    }
    else
    {
        self.textField.placeholder = self.property.defaultValue;
        
        if (self.property.currentValue != nil)
        {
            self.textField.text = self.property.currentValue;
        }
    }
    
    [self.view addSubview:self.textField];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kUILabelSave
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(savePressed:)];
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:kUILabelCancel
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(cancelPressed:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)savePressed:(id)sender
{
    self.property.currentValue = self.textField.text;
    
    NSLog(@"saving property %@...", self.property.name);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = kUILabelSaving;
    
    [self.benchmarkService updateProperty:self.property
                        ofBenchmarkObject:self.benchmarkObject
                          completionHandler:^(BOOL succeeded, NSError *error) {
        [hud hide:YES];
        if (succeeded)
        {
            NSLog(@"property successfully saved");
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [Utils displayError:error];
        }
    }];
}

@end
