//
//  RunViewController.m
//  Benchmark
//
//  Created by Gavin Cornwell on 18/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "RunViewController.h"
#import "PropertiesViewController.h"

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
    
    if (!self.run.hasStarted)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                                               target:self
                                                                                               action:@selector(start:)];
    }
    else if (self.run.hasStarted && !self.run.hasCompleted)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                               target:self
                                                                                               action:@selector(refresh:)];
    }
    
    [self.benchmarkService retrieveStatusForRun:self.run completionBlock:^(RunStatus *status, NSError *error) {
        if (nil == status)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Failed to retrieve run status"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            self.runStatus = status;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
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
    // Return the number of rows in the section.
    if (section == 0)
    {
        return 2;
    }
    else
    {
        return 4;
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
            cell.detailTextLabel.text = self.run.notes;
            UIImage *img = [UIImage imageNamed:@"samples.png"];
            cell.imageView.image = img;
            
            NSString *iconName = nil;
            if (self.run.hasStarted && self.run.hasCompleted)
            {
                iconName = @"completed.png";
            }
            else if (self.run.hasStarted && !self.run.hasCompleted)
            {
                iconName = @"in-progress.png";
            }
            else
            {
                iconName = @"pending.png";
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
            
            cell.textLabel.text = @"Properties";
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
                cell.textLabel.text = @"Started At";
                if (self.runStatus.startTime == nil)
                {
                    cell.detailTextLabel.text = @"-";
                }
                else
                {
                    // TODO: Format date properly
                    cell.detailTextLabel.text = [self.runStatus.startTime description];
                }
            }
            else if (indexPath.row == 1)
            {
                cell.textLabel.text = @"Running Time";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d minutes", self.runStatus.duration];
            }
            else if (indexPath.row == 2)
            {
                cell.textLabel.text = @"Success Rate";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d%%", self.runStatus.successRate];
            }
            else if (indexPath.row == 3)
            {
                cell.textLabel.text = @"Result Count";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", self.runStatus.resultCount];
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
                                                                                         editable:!self.run.hasStarted
                                                                                 benchmarkService:self.benchmarkService];
    [self.navigationController pushViewController:propsVC animated:YES];
}

#pragma mark - Button handlers

- (IBAction)start:(id)sender
{
    NSLog(@"start");
}

- (IBAction)refresh:(id)sender
{
    NSLog(@"refresh");
}

@end
