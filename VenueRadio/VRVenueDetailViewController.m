//
//  VRVenueDetailViewController.m
//  VenueRadio
//
//  Created by Abel Allison on 4/9/14.
//  Copyright (c) 2014 GrooveMechanic. All rights reserved.
//

#import "VRVenueDetailViewController.h"
#import "VRVenueDetailTableViewCell.h"
#import "SGVenue.h"
#import "SGEvent.h"

static NSString *cellIdentifier = @"VRVenueDetailTableViewCell";
static int       cellsBeforeLoading = 5;

@interface VRVenueDetailViewController ()

@property (nonatomic, strong) IBOutlet UIView  *headerView;
@property (nonatomic, strong) IBOutlet UILabel *venueTitleView;

@end

@implementation VRVenueDetailViewController

- (instancetype) initWithVenue:(SGVenue *)venue {
    self = [self initWithStyle:UITableViewStylePlain];
    
    _venueModel = venue;
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (!self) {
        return nil;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *header = self.headerView;
    [self.tableView setTableHeaderView:header];
    
    [self.tableView registerClass:[VRVenueDetailTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    [self loadMoreEvents];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (UIView *)headerView {
    if (!_headerView) {
        [[NSBundle mainBundle] loadNibNamed:@"VRVenueDetailHeaderView" owner:self options:nil];
    }
    return _headerView;
}

- (UIView *)venueTitleView {
    if (!_headerView) {
        [[NSBundle mainBundle] loadNibNamed:@"VRVenueDetailHeaderView" owner:self options:nil];
    }
    return _venueTitleView;
}

- (void) loadMoreEvents {
    [self.venueModel loadMoreEventsWithSuccess:^{
        NSLog(@"More events loaded...");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.venueModel.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    SGEvent *event = self.venueModel.events[indexPath.row];
    NSLog(@"%@", event.title);
    NSLog(@"%f", event.score);
    cell.textLabel.text = event.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", event.datetimeLocal];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // check if indexPath.row is last row
    // Perform operation to load new Cell's.
    if (indexPath.row == (self.venueModel.events.count-cellsBeforeLoading) && !self.venueModel.eventsLoaded) {
        [self loadMoreEvents];
    }
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
