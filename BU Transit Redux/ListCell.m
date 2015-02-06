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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self addShadowToView:self.innerView];
    [self addShadowToView:self.timeAway];
    
    self.timeBackground.layer.cornerRadius = 4.0f;
    [self addShadowToView:self.timeBackground];
    
    [self layoutSubviews];
    


}

-(void) layoutSubviews {
    [super layoutSubviews];
    
    [self addShadowPathToView:self.innerView];
    [self addShadowPathToView:self.timeAway];
    
    

    [self addShadowPathToView:self.timeBackground];

}


-(void) addShadowToView: (UIView *) view {
    view.layer.drawsAsynchronously = YES;
    view.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    view.layer.shadowRadius = 1.0;
    view.layer.shadowOpacity = 0.25;
    view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    view.layer.shouldRasterize = YES;
}

-(void) addShadowPathToView: (UIView *) view {
    CGRect shadowFrame = view.bounds;
    CGPathRef shadowPath = [UIBezierPath bezierPathWithRoundedRect:shadowFrame cornerRadius:view.layer.cornerRadius].CGPath;
    view.layer.shadowPath = shadowPath;
}


@end
