//
//  PropertiesViewController.m
//  Benchmark
//
//  Created by Gavin Cornwell on 18/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "EditPropertyViewController.h"
#import "PropertiesViewController.h"
#import "Property.h"

@interface PropertiesViewController ()
@property (nonatomic, strong, readwrite) id<BenchmarkService> benchmarkService;
@property (nonatomic, strong, readwrite) BenchmarkObject *benchmarkObject;
@property (nonatomic, strong, readwrite) NSArray *properties;
@property (nonatomic, assign, readwrite) BOOL editingAllowed;
@property (nonatomic, assign, readwrite) BOOL loadingForFirstTime;
@end

@implementation PropertiesViewController

- (id)initWithBenchmarkObject:(BenchmarkObject *)object editable:(BOOL)editable benchmarkService:(id<BenchmarkService>)service
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.benchmarkObject = object;
        self.editingAllowed = editable;
        self.benchmarkService = service;
        self.loadingForFirstTime = YES;
        
        // TODO: process properties i.e. don't include hidden properties and group
        self.properties = object.properties;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Properties";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.loadingForFirstTime)
    {
        [self.tableView reloadData];
    }
    
    self.loadingForFirstTime = NO;
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
        if (self.editingAllowed)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    // set cell text
    Property *property = [self.properties objectAtIndex:indexPath.row];
    cell.textLabel.text = property.title;
    if (property.currentValue != nil)
    {
        cell.detailTextLabel.text = property.currentValue;
    }
    else
    {
        cell.detailTextLabel.text = property.originalValue;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editingAllowed)
    {
        return indexPath;
    }
    else
    {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Property *property = [self.properties objectAtIndex:indexPath.row];
    EditPropertyViewController *editPropVC = [[EditPropertyViewController alloc] initWithProperty:property
                                                                                ofBenchmarkObject:self.benchmarkObject
                                                                                 benchmarkService:self.benchmarkService];
    [self.navigationController pushViewController:editPropVC animated:YES];
}

@end
