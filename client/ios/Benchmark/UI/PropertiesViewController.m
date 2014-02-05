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
#import "Utils.h"
#import "MBProgressHUD.h"

@interface PropertiesViewController ()
@property (nonatomic, strong, readwrite) id<BenchmarkService> benchmarkService;
@property (nonatomic, strong, readwrite) BenchmarkObject *benchmarkObject;
@property (nonatomic, strong, readwrite) NSArray *properties;
@property (nonatomic, strong, readwrite) NSMutableArray *groupNames;
@property (nonatomic, strong, readwrite) NSMutableDictionary *groupedProperties;
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
        self.properties = [NSArray array];
        self.groupNames = [NSMutableArray array];
        self.groupedProperties = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = kUITitleProperties;
    
    [self fetchAndProcessProperties];
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
    return self.groupNames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *groupName = [self.groupNames objectAtIndex:section];
    NSArray *props = [self.groupedProperties objectForKey:groupName];
    return props.count;
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
    
    // retrieve appropriate property object
    NSString *groupName = [self.groupNames objectAtIndex:indexPath.section];
    NSArray *props = [self.groupedProperties objectForKey:groupName];
    Property *property = [props objectAtIndex:indexPath.row];
    
    // set cell text
    cell.textLabel.text = property.title;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    if (property.isSecret)
    {
        cell.detailTextLabel.text = kUIPasswordMask;
    }
    else
    {
        if (property.currentValue != nil)
        {
            cell.detailTextLabel.text = property.currentValue;
            
            if (property.currentValue != property.defaultValue)
            {
                cell.detailTextLabel.textColor = [UIColor blackColor];
            }
        }
        else
        {
            cell.detailTextLabel.text = property.defaultValue;
        }
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
    // retrieve appropriate property object
    NSString *groupName = [self.groupNames objectAtIndex:indexPath.section];
    NSArray *props = [self.groupedProperties objectForKey:groupName];
    Property *property = [props objectAtIndex:indexPath.row];
    
    EditPropertyViewController *editPropVC = [[EditPropertyViewController alloc] initWithProperty:property
                                                                                ofBenchmarkObject:self.benchmarkObject
                                                                                 benchmarkService:self.benchmarkService];
    [self.navigationController pushViewController:editPropVC animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *groupTitle = [self.groupNames objectAtIndex:section];
    
    // for the default group use a title of "General"
    if ([groupTitle isEqualToString:@""])
    {
        groupTitle = kUITitleGeneral;
    }
    
    return groupTitle;
}

#pragma mark - Property handling

- (void)fetchAndProcessProperties
{
    NSLog(@"fetching properties...");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = kUILabelLoading;
    
    [self.benchmarkService retrievePropertiesOfBenchmarkObject:self.benchmarkObject completionHandler:^(NSArray *array, NSError *error) {
        if (nil == array)
        {
            [hud hide:YES];
            [Utils displayError:error];
        }
        else
        {
            NSLog(@"properties successfully retrieved, processing...");
            
            self.properties = array;
            
            // process properties, group them and ignore hidden properties
            for (Property *prop in self.properties)
            {
                if (!prop.isHidden)
                {
                    NSString *group = prop.group;
                    if (group == nil)
                    {
                        group = @"";
                    }
                    
                    NSMutableArray *propsForGroup = [self.groupedProperties objectForKey:group];
                    if (propsForGroup == nil)
                    {
                        propsForGroup = [NSMutableArray arrayWithObject:prop];
                        [self.groupNames addObject:group];
                        [self.groupedProperties setObject:propsForGroup forKey:group];
                    }
                    else
                    {
                        [propsForGroup addObject:prop];
                    }
                }
            }
            
            NSLog(@"properties processed");
            [hud hide:YES];
            
            [self.tableView reloadData];
        }
    }];
}

@end
