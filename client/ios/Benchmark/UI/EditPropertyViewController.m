//
//  EditPropertyViewController.m
//  Benchmark
//
//  Created by Gavin Cornwell on 25/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "EditPropertyViewController.h"

@interface EditPropertyViewController ()
@property (nonatomic, strong, readwrite) id<BenchmarkService> benchmarkService;
@property (nonatomic, strong, readwrite) Property *property;
@property (nonatomic, strong, readwrite) UITextField *textField;
@end

@implementation EditPropertyViewController

- (id)initWithProperty:(Property *)property benchmarkService:(id<BenchmarkService>)service;
{
    self = [super init];
    if (self)
    {
        self.property = property;
        self.benchmarkService = service;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Edit Property";
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    
    CGRect frame;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        frame = CGRectMake(20, 30, 720, 40);
    }
    else
    {
        frame = CGRectMake(20, 30, 280, 40);
    }
    
    self.textField = [[UITextField alloc] initWithFrame:frame];
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField.placeholder = [self.property.defaultValue description];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    if (self.property.type == PropertyTypeInteger)
    {
        [self.textField setKeyboardType:UIKeyboardTypeNumberPad];
    }
    else if (self.property.type == PropertyTypeDecimal)
    {
        [self.textField setKeyboardType:UIKeyboardTypeDecimalPad];
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
    self.property.value = self.textField.text;
    
    // TODO: call the benchmarkService to persist the property change
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
