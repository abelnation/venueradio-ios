//
//  VRVenueDetailViewController.h
//  VenueRadio
//
//  Created by Abel Allison on 4/9/14.
//  Copyright (c) 2014 GrooveMechanic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGVenue;

@interface VRVenueDetailViewController : UITableViewController

@property (nonatomic, readonly) SGVenue *venueModel;

- (instancetype) initWithVenue:(SGVenue *)venue;

@end
