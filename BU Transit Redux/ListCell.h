//
//  Cell.h
//  BU_Shuttle
//
//  Created by Ross Tang Him on 8/17/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *inOrOutbound;

@property (weak, nonatomic) IBOutlet UILabel *busInfo;
@property (weak, nonatomic) IBOutlet UIImageView *busImage;
@property (weak, nonatomic) IBOutlet UILabel *stopName;
@property (weak, nonatomic) IBOutlet UILabel *timeAway;
@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UIView *timeBackground;

@end
