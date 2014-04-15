//
//  VRVenueListViewController.m
//  VenueRadio
//
//  Created by Abel Allison on 3/31/14.
//  Copyright (c) 2014 GrooveMechanic. All rights reserved.
//

#import "VRVenueListViewController.h"
#import "VRVenueListTableViewCell.h"
#import "VRVenueDetailViewController.h"

#import "SGVenue.h"

static NSString *cellIdentifier = @"VRVenueListTableViewCell";
static int       cellsBeforeLoading = 5;

@interface VRVenueListViewController ()

@property (nonatomic, strong) NSString       *city;
@property (nonatomic, strong) NSMutableArray *venues;
@property (nonatomic, assign) int             latestPage;
@property (nonatomic, assign) int             pendingPage;

@property (nonatomic, assign) BOOL            venuesLoaded;

@end

@implementation VRVenueListViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Venues";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pendingPage = 0;
    self.venuesLoaded = NO;
    self.city = @"San Francisco";
    
    [self.tableView registerClass:[VRVenueListTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    [SGVenue getVenuesForCity:self.city
                      success:^(NSArray *venues) {
                          
                          if (venues.count == 0) {
                              self.venuesLoaded = YES;
                          }
                          
                          self.latestPage = 1;
                          self.pendingPage = 1;
                          self.venues = [NSMutableArray arrayWithArray:venues];
                          // RKLogInfo(@"Load collection of Venues: %@", self.venues);
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self.tableView reloadData];
                          });
                          
                      }
                      failure:^(NSError *error) {
                          RKLogError(@"Operation failed with error: %@", error);
                      }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMoreVenues {
    int newPage = self.latestPage + 1;
    if (newPage <= self.pendingPage) {
        return;
    }
    
    // To prevent multiple reloads for the same chunk
    self.pendingPage = newPage;
    
    [SGVenue getVenuesForCity:self.city
                      success:^(NSArray *venues) {
                          
                          if (venues.count == 0) {
                              self.venuesLoaded = YES;
                          }
                          
                          self.latestPage = newPage;
                          [self.venues addObjectsFromArray:venues];
                          // RKLogInfo(@"Load collection of Venues: %@", self.venues);
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self.tableView reloadData];
                          });
                          
                      }
                      failure:^(NSError *error) {
                          RKLogError(@"Operation failed with error: %@", error);
                      }
                         page:newPage];
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
    return [self.venues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    SGVenue *venue = self.venues[indexPath.row];
    NSLog(@"%@", venue.name);
    NSLog(@"%f", venue.score);
    cell.textLabel.text = venue.name;
    
    NSNumber *scorePercent = [NSNumber numberWithFloat:roundf(venue.score * 10000.00) / 100.00];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%%", scorePercent];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // check if indexPath.row is last row
    // Perform operation to load new Cell's.
    if (indexPath.row == (self.venues.count-cellsBeforeLoading) && !self.venuesLoaded) {
        [self loadMoreVenues];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SGVenue *venue = self.venues[indexPath.row];
    if (!venue) { return; }
    
    VRVenueDetailViewController *detailViewController = [[VRVenueDetailViewController alloc] initWithVenue:venue];
    
    [self.navigationController pushViewController:(UIViewController *)detailViewController animated:YES];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
