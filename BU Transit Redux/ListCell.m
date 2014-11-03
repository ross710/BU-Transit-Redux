//
//  Cell.m
//  BU_Shuttle
//
//  Created by Ross Tang Him on 8/17/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import "ListCell.h"
@interface ListCell ()


@end
@implementation ListCell
@synthesize stopName,timeAway, inOrOutBound;
@synthesize busType;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat xPadding = 16;
        CGFloat yPadding = 8;
        
        stopName = [[UILabel alloc] initWithFrame:CGRectMake(xPadding,
                                                             yPadding,
                                                             screenWidth - xPadding*2,
                                                             36)];
        stopName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0];
        
        UILabel *nextBusLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 108 - xPadding, 48, 108, 21)];
        nextBusLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
        nextBusLabel.text = @"next bus is:";
        nextBusLabel.textAlignment = NSTextAlignmentCenter;

        
        UILabel *minutesAwayLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 108 - xPadding, 112, 108, 21)];
        minutesAwayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
        minutesAwayLabel.text = @"minutes away";
        minutesAwayLabel.textAlignment = NSTextAlignmentCenter;

        
        
        timeAway = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 108 - xPadding, 76, 108, 31)];
        timeAway.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0];
        timeAway.textAlignment = NSTextAlignmentCenter;
        [timeAway setAdjustsFontSizeToFitWidth:YES];
        
        
        inOrOutBound = [[UILabel alloc] initWithFrame:CGRectMake(32, 48, 160, 21)];
        inOrOutBound.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0];
        inOrOutBound.textAlignment = NSTextAlignmentLeft;
        
        
        busType = [[UILabel alloc] initWithFrame:CGRectMake(32, 73, 160, 37)];
        busType.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0];
        busType.textAlignment = NSTextAlignmentLeft;
        
        
        [self addSubview:stopName];
        [self addSubview:timeAway];
        [self addSubview:inOrOutBound];
        [self addSubview:busType];
        [self addSubview:nextBusLabel];
        [self addSubview:minutesAwayLabel];

        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
