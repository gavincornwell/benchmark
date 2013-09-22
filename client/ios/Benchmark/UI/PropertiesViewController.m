//
//  PropertiesViewController.m
//  Benchmark
//
//  Created by Gavin Cornwell on 18/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "PropertiesViewController.h"
#import "Property.h"

@interface PropertiesViewController ()
@property (nonatomic, strong, readwrite) id<BenchmarkService> benchmarkService;
@property (nonatomic, strong, readwrite) Test *test;
@property (nonatomic, strong, readwrite) Run *run;
@property (nonatomic, strong, readwrite) NSArray *properties;
@end

@implementation PropertiesViewController

///
// TODO: Create a common base class and pass that in instead
///

- (id)initWithTest:(Test *)test benchmarkService:(id<BenchmarkService>)service;
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.test = test;
        self.properties = test.properties;
        self.benchmarkService = service;
    }
    
    return self;
}

- (id)initWithRun:(Run *)run benchmarkService:(id<BenchmarkService>)service;
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.run = run;
        self.properties = run.properties;
        self.benchmarkService = service;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Properties";
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
    return self.properties.count;
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
    Property *property = [self.properties objectAtIndex:indexPath.row];
    cell.textLabel.text = property.name;
    cell.detailTextLabel.text = [property.defaultValue description];
    
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
