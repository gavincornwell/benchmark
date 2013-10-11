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

@interface TestViewController ()
@property (nonatomic, strong, readwrite) id<BenchmarkService> benchmarkService;
@property (nonatomic, strong, readwrite) Test *test;
@property (nonatomic, strong, readwrite) NSArray *runs;
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
    
    self.runs = [NSArray array];
    self.navigationItem.title = self.test.name;
    
    NSLog(@"fetching runs...");
    [self.benchmarkService retrieveRunsForTest:self.test completionBlock:^(NSArray *runs, NSError *error){
        if (nil == runs)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Failed to retrieve runs"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            NSLog(@"runs successfully retrieved");
            self.runs = [NSArray arrayWithArray:runs];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
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
            cell.detailTextLabel.text = self.test.notes;
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
            
            cell.textLabel.text = @"Properties";
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
        cell.detailTextLabel.text = run.notes;
        
        // set appropriate icon
        NSString *iconName = nil;
        if (run.hasStarted && run.hasCompleted)
        {
            iconName = @"completed.png";
        }
        else if (run.hasStarted && !run.hasCompleted)
        {
            iconName = @"in-progress.png";
        }
        else
        {
            iconName = @"pending.png";
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

@end
