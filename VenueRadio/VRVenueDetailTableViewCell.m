//
//  VRVenueDetailTableViewCell.m
//  VenueRadio
//
//  Created by Abel Allison on 4/9/14.
//  Copyright (c) 2014 GrooveMechanic. All rights reserved.
//

#import "VRVenueDetailTableViewCell.h"

@implementation VRVenueDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
