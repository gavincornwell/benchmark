//
//  RunViewController.m
//  Benchmark
//
//  Created by Gavin Cornwell on 18/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "RunViewController.h"
#import "PropertiesViewController.h"
#import "Utils.h"
#import "MBProgressHUD.h"

@interface RunViewController ()
@property (nonatomic, strong, readwrite) id<BenchmarkService> benchmarkService;
@property (nonatomic, strong, readwrite) Run *run;
@property (nonatomic, strong, readwrite) RunStatus *runStatus;
@end

@implementation RunViewController

- (id)initWithRun:(Run *)run benchmarkService:(id<BenchmarkService>)service;
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.run = run;
        self.benchmarkService = service;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.run.name;
    
    if (self.run.state == RunStateNotScheduled)
    {
        // show not scheduled controls
        [self showNotScheduledControls];
    }
    else if (self.run.state == RunStateScheduled || self.run.state == RunStateStarted)
    {
        // show in progress controls
        [self showInProgressControls];
    }
    
    if (self.run.state >= RunStateScheduled)
    {
        [self fetchRunStatus];
    }
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
    if (self.runStatus == nil)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
    {
        return 2;
    }
    else
    {
        return 8;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        return 70.0;
    }
    else
    {
        return 50.0;
    }
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
            
            cell.textLabel.text = self.run.name;
            cell.detailTextLabel.text = self.run.summary;
            UIImage *img = [UIImage imageNamed:@"samples.png"];
            cell.imageView.image = img;

            NSString *iconName = nil;
            if (self.run.state == RunStateNotScheduled)
            {
                iconName = @"not-scheduled.png";
            }
            else if (self.run.state == RunStateScheduled)
            {
                iconName = @"pending.png";
            }
            else if (self.run.state == RunStateStarted)
            {
                iconName = @"in-progress.png";
            }
            else if (self.run.state == RunStateStopped)
            {
                iconName = @"stopped.png";
            }
            else
            {
                iconName = @"completed.png";
            }
            
            UIImage *statusImg = [UIImage imageNamed:iconName];
            UIImageView *statusImgView = [[UIImageView alloc] initWithImage:statusImg];
            cell.accessoryView = statusImgView;
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
        static NSString *StatusIdentifier = @"Status";
        cell = [tableView dequeueReusableCellWithIdentifier:StatusIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:StatusIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        if (self.runStatus != nil)
        {
            if (indexPath.row == 0)
            {
                cell.textLabel.text = kUILabelScheduled;
                if (self.runStatus.scheduledStartTime == nil)
                {
                    cell.detailTextLabel.text = kUILabelNoValue;
                }
                else
                {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
                    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
                    cell.detailTextLabel.text = [dateFormatter stringFromDate:self.runStatus.scheduledStartTime];
                }
            }
            if (indexPath.row == 1)
            {
                NSDate *date;
                if (self.run.state == RunStateCompleted)
                {
                    date = self.run.timeCompleted;
                    cell.textLabel.text = kUILabelCompleted;
                }
                else
                {
                    date = self.runStatus.timeStarted;
                    cell.textLabel.text = kUILabelStarted;
                }
                
                if (date == nil)
                {
                    cell.detailTextLabel.text = kUILabelNoValue;
                }
                else
                {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
                    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
                    cell.detailTextLabel.text = [dateFormatter stringFromDate:date];
                }
            }
            else if (indexPath.row == 2)
            {
                cell.textLabel.text = kUILabelRunningTime;
                cell.detailTextLabel.text = [NSString stringWithFormat:kUIRunningTimeFormat, self.runStatus.duration];
            }
            else if (indexPath.row == 3)
            {
                cell.textLabel.text = kUILabelProgress;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld%%", (long)self.runStatus.progess];
            }
            else if (indexPath.row == 4)
            {
                cell.textLabel.text = kUILabelSuccessRate;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld%%", (long)self.runStatus.successRate];
            }
            else if (indexPath.row == 5)
            {
                cell.textLabel.text = kUILabelResultCount;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)self.runStatus.resultsTotalCount];
            }
            else if (indexPath.row == 6)
            {
                cell.textLabel.text = kUILabelSuccessCount;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)self.runStatus.resultsSuccessCount];
            }
            else if (indexPath.row == 7)
            {
                cell.textLabel.text = kUILabelFailCount;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)self.runStatus.resultsFailCount];
            }
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1)
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
    PropertiesViewController *propsVC = [[PropertiesViewController alloc] initWithBenchmarkObject:self.run
                                                                                         editable:self.run.state == RunStateNotScheduled
                                                                                 benchmarkService:self.benchmarkService];
    [self.navigationController pushViewController:propsVC animated:YES];
}

#pragma mark - Button handlers

- (IBAction)schedule:(id)sender
{
    NSLog(@"scheduling run...");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = kUILabelScheduling;
    
    [self.benchmarkService scheduleRun:self.run completionHandler:^(BOOL succeeded, NSError *error) {
        [hud hide:YES];
        if (succeeded)
        {
            NSLog(@"run successfully scheduled");
            
            // show in progress controls
            [self showInProgressControls];
            
            // fetch the latest status
            [self fetchRunStatus];
        }
        else
        {
            [Utils displayError:error];
        }
    }];
}

- (IBAction)stop:(id)sender
{
    NSLog(@"stopping run...");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = kUILabelStopping;
    
    [self.benchmarkService stopRun:self.run completionHandler:^(BOOL succeeded, NSError *error) {
        [hud hide:YES];
        if (succeeded)
        {
            NSLog(@"run successfully stopped");
            
            // show completed controls
            [self showCompletedControls];
            
            // fetch the latest status
            [self fetchRunStatus];
        }
        else
        {
            [Utils displayError:error];
        }
    }];
}

- (IBAction)refresh:(id)sender
{
    [self fetchRunStatus];
}

#pragma mark - Helper methods

- (void)fetchRunStatus
{
    NSLog(@"fetching run status...");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = kUILabelLoading;
    
    [self.benchmarkService retrieveStatusForRun:self.run completionHandler:^(RunStatus *status, NSError *error) {
        [hud hide:YES];
        if (nil == status)
        {
            [Utils displayError:error];
        }
        else
        {
            NSLog(@"run status successfully retrieved");
            
            self.runStatus = status;
            
            // show completed controls when appropriate
            if (self.run.state == RunStateCompleted)
            {
                [self showCompletedControls];
            }
            
            [self.tableView reloadData];
        }
    }];
}

- (void)showNotScheduledControls
{
    // show a start button before the run has been scheduled
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                                           target:self
                                                                                           action:@selector(schedule:)];
}

- (void)showInProgressControls
{
    // show a refresh button whilst the run is in progress
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                   target:self
                                                                                   action:@selector(refresh:)];
    
    // show a refresh button whilst the run is in progress
    UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                target:self
                                                                                action:@selector(stop:)];
    
    // add the 2 buttons
    self.navigationItem.rightBarButtonItems = @[refreshButton, stopButton];
}

- (void)showCompletedControls
{
    // don't show any buttons once the run is complete (or stopped)
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

@end
