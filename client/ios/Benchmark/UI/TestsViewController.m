//
//  TestsViewController.m
//  Benchmark
//
//  Created by Gavin Cornwell on 14/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "TestsViewController.h"
#import "TestViewController.h"
#import "Test.h"
#import "Utils.h"
#import "AddTestFormViewController.h"
#import "MBProgressHUD.h"

@interface TestsViewController ()
@property (nonatomic, strong) id<BenchmarkService> benchmarkService;
@property (nonatomic, strong) NSMutableArray *tests;
@property (nonatomic, strong) NSArray *testDefinitions;
@end

@implementation TestsViewController

- (id)initWithBenchmarkService:(id<BenchmarkService>)service;
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.benchmarkService = service;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tests = [NSMutableArray array];
    self.navigationItem.title = kUITitleTests;
    
    if (self.benchmarkService != nil)
    {
        // retrieve tests
        [self fetchTests];
        
        // retrieve test definitions
        [self fetchTestDefinitions];
        
        // enable edit button so we can delete tests
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        
        // setup the bottom toolbar
        self.navigationController.toolbarHidden = NO;
        UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
        NSArray *items = [NSArray arrayWithObjects:add, flexibleItem, refresh, nil];
        self.toolbarItems = items;
    }
    
    // register for notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh:)
                                                 name:kTestAddedNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    return self.tests.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        UIImage *img = [UIImage imageNamed:@"test.png"];
        cell.imageView.image = img;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // set cell text
    Test *test = [self.tests objectAtIndex:indexPath.row];
    cell.textLabel.text = test.name;
    cell.detailTextLabel.text = test.summary;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Test *test = [self.tests objectAtIndex:indexPath.row];
    TestViewController *testVC = [[TestViewController alloc] initWithTest:test benchmarkService:self.benchmarkService];
    [self.navigationController pushViewController:testVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog(@"deleting test...");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = kUILabelDeleting;
        
        // request deletion of the test
        [self.benchmarkService deleteTest:[self.tests objectAtIndex:indexPath.row] completionHandler:^(BOOL succeeded, NSError *error) {
            [hud hide:YES];
            if (succeeded)
            {
                NSLog(@"test successfully deleted");
                [self.tests removeObjectAtIndex:indexPath.row];
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

- (IBAction)add:(id)sender
{
    AddTestFormViewController *addTestVC = [[AddTestFormViewController alloc] initWithTestDefinitons:self.testDefinitions
                                                                                    benchmarkService:self.benchmarkService];
    [self.navigationController pushViewController:addTestVC animated:YES];
}

- (IBAction)refresh:(id)sender
{
    [self fetchTests];
    [self fetchTestDefinitions];
}

- (void)fetchTests
{
    NSLog(@"fetching tests...");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = kUILabelLoading;
    
    [self.benchmarkService retrieveTestsWithCompletionBlock:^(NSArray *tests, NSError *error){
        [hud hide:YES];
        if (nil == tests)
        {
            [Utils displayError:error];
        }
        else
        {
            NSLog(@"tests successfully retrieved");
            self.tests = [NSMutableArray arrayWithArray:tests];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

- (void)fetchTestDefinitions
{
    NSLog(@"fetching test definitions...");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = kUILabelLoading;
    
    [self.benchmarkService retrieveTestDefinitionsWithCompletionBlock:^(NSArray *testDefinitions, NSError *error){
        [hud hide:YES];
        if (nil == testDefinitions)
        {
            [Utils displayError:error];
        }
        else
        {
            NSLog(@"test definitions successfully retrieved");
            self.testDefinitions = [NSMutableArray arrayWithArray:testDefinitions];
        }
    }];
}

@end
