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
#import "MBProgressHUD.h"

@interface TestsViewController ()
@property (nonatomic, strong, readwrite) id<BenchmarkService> benchmarkService;
@property (nonatomic, strong, readwrite) NSArray *tests;
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
    
    self.tests = [NSArray array];
    self.navigationItem.title = kUITitleTests;
    
    if (self.benchmarkService != nil)
    {
        // retrieve tests
        [self fetchTests];
        
        // provide refresh button
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                               target:self
                                                                                            action:@selector(refresh:)];
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
        UIImage *img = [UIImage imageNamed:@"learn-more.png"];
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

#pragma mark - Button handlers

- (IBAction)refresh:(id)sender
{
    [self fetchTests];
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
            self.tests = [NSArray arrayWithArray:tests];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

@end
