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

/*! Returns the major version of iOS, (i.e. for iOS 6.1.3 it returns 6)
 */
NSUInteger DeviceSystemMajorVersion()
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    
    return _deviceSystemMajorVersion;
}

#define IOS7_OR_ABOVE (DeviceSystemMajorVersion() >= 7)

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Edit Property";
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    
    CGRect frame;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        if (IOS7_OR_ABOVE)
        {
            frame = CGRectMake(20, 100, 720, 40);
        }
        else
        {
            frame = CGRectMake(20, 30, 720, 40);
        }
    }
    else
    {
        if (IOS7_OR_ABOVE)
        {
            frame = CGRectMake(20, 100, 280, 40);
        }
        else
        {
            frame = CGRectMake(20, 30, 280, 40);
        }
    }
    
    self.textField = [[UITextField alloc] initWithFrame:frame];
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
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
        self.textField.placeholder = self.property.originalValue;
    }
    
    [self.view addSubview:self.textField];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(savePressed:)];
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
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
    
    NSLog(@"saving property...");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    
    [self.benchmarkService updateProperty:self.property
                        ofBenchmarkObject:self.benchmarkObject
                          completionHandler:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            NSLog(@"property successfully saved");
            [hud hide:YES];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [Utils displayError:error];
        }
    }];
}

@end
