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
@end

@implementation EditPropertyViewController

- (id)initWithProperty:(Property *)property benchmarkService:(id<BenchmarkService>)service;
{
    self = [super initWithStyle:UITableViewStyleGrouped];
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
}

- (void) showFailureAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // set cell text
    cell.textLabel.text = self.property.name;
    cell.detailTextLabel.text = [self.property.defaultValue description];
    
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
