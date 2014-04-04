//
//  TestViewController.m
//  Benchmark
//
//  Created by Gavin Cornwell on 18/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "TestViewController.h"
#import "PropertiesViewController.h"
#import "RunViewController.h"
#import "Utils.h"
#import "MBProgressHUD.h"

@interface TestViewController ()
@property (nonatomic, strong, readwrite) id<BenchmarkService> benchmarkService;
@property (nonatomic, strong, readwrite) Test *test;
@property (nonatomic, strong, readwrite) NSMutableArray *runs;
@end

@implementation TestViewController

- (id)initWithTest:(Test *)test benchmarkService:(id<BenchmarkService>)service;
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.test = test;
        self.benchmarkService = service;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.runs = [NSMutableArray array];
    self.navigationItem.title = self.test.name;
    
    [self fetchRuns];
    
    // enable edit button so we can delete tests
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // setup the bottom toolbar
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    NSArray *items = [NSArray arrayWithObjects:flexibleItem, item2, nil];
    self.toolbarItems = items;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else
    {
        // Return the number of rows in the section.
        return self.runs.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            static NSString *DetailsIdentifier = @"Details";
            cell = [tableView dequeueReusableCellWithIdentifier:DetailsIdentifier];
            
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:DetailsIdentifier];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            cell.textLabel.text = self.test.name;
            cell.detailTextLabel.text = self.test.summary;
            UIImage *img = [UIImage imageNamed:@"learn-more.png"];
            cell.imageView.image = img;
        }
        else
        {
            static NSString *PropertiesIdentifier = @"Properties";
            cell = [tableView dequeueReusableCellWithIdentifier:PropertiesIdentifier];
            
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PropertiesIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.textLabel.text = kUITitleProperties;
        }
    }
    else
    {
        static NSString *RunIdentifier = @"Run";
        cell = [tableView dequeueReusableCellWithIdentifier:RunIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:RunIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        // set cell text
        Run *run = [self.runs objectAtIndex:indexPath.row];
        cell.textLabel.text = run.name;
        cell.detailTextLabel.text = run.summary;
        
        // set appropriate icon
        NSString *iconName = nil;
        if (run.state == RunStateNotScheduled)
        {
            iconName = @"not-scheduled.png";
        }
        else if (run.state == RunStateScheduled)
        {
            iconName = @"pending.png";
        }
        else if (run.state == RunStateStarted)
        {
            iconName = @"in-progress.png";
        }
        else if (run.state == RunStateStopped)
        {
            iconName = @"stopped.png";
        }
        else
        {
            iconName = @"completed.png";
        }
        
        UIImage *img = [UIImage imageNamed:iconName];
        cell.imageView.image = img;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        return nil;
    }
    else
    {
        return indexPath;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        PropertiesViewController *propsVC = [[PropertiesViewController alloc] initWithBenchmarkObject:self.test
                                                                                             editable:YES
                                                                                     benchmarkService:self.benchmarkService];
        [self.navigationController pushViewController:propsVC animated:YES];
    }
    else
    {
        Run *run = [self.runs objectAtIndex:indexPath.row];
        RunViewController *runVC = [[RunViewController alloc] initWithRun:run benchmarkService:self.benchmarkService];
        [self.navigationController pushViewController:runVC animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        // do not allow deletion of runs that have started
        Run *run = [self.runs objectAtIndex:indexPath.row];
        return run.state != RunStateStarted;
    }
    else
    {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog(@"deleting run...");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = kUILabelDeleting;
     
        // request deletion of the run
        [self.benchmarkService deleteRun:[self.runs objectAtIndex:indexPath.row] completionHandler:^(BOOL succeeded, NSError *error) {
            [hud hide:YES];
            if (succeeded)
            {
                NSLog(@"run successfully deleted");
                [self.runs removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            else
            {
                [Utils displayError:error];
            }
        }];
    }
}

#pragma mark - Button handlers

- (IBAction)refresh:(id)sender
{
    [self fetchRuns];
}

- (void)fetchRuns
{
    NSLog(@"fetching runs...");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = kUILabelLoading;
    
    [self.benchmarkService retrieveRunsForTest:self.test completionHandler:^(NSArray *runs, NSError *error){
        [hud hide:YES];
        if (nil == runs)
        {
            [Utils displayError:error];
        }
        else
        {
            NSLog(@"runs successfully retrieved");
            self.runs = [NSMutableArray arrayWithArray:runs];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

@end
