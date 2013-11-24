//
//  AldCardSideView.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 17/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AldCardSideView.h"
#import "UIView+Glow.h"

@interface AldCardSideView ()

@property(nonatomic) BOOL initialized;

@end


@implementation AldCardSideView

-(id) initWithFrame: (CGRect)frame associatedWithCard: (AldCardSidesViewContainer *)card
{
    self = [super initWithFrame:frame];
    if (self) {
        _associatedCard = card;
        self.userInteractionEnabled = YES;
        self.autoresizingMask       = UIViewAutoresizingNone;
        
        [self initStyles];
        [self initContents];
        
        _initialized = YES;
    }
    return self;
}

-(void) initStyles
{
    if (_initialized) {
        return;
    }
    
    // round the corners with a corner radius equivalent to 5 % of the square's width
    // by creating a bezier path as an alpha mask.
    CGFloat r = self.bounds.size.width * 0.05f;
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                           byRoundingCorners:UIRectCornerAllCorners
                                                 cornerRadii:CGSizeMake(r, r)].CGPath;
    
    self.layer.mask = maskLayer;
}

-(void) initContents
{
}

-(void) deselect
{
    [self stopGlowing];
}

-(void) select
{
    [self startGlowingWithColor:[UIColor orangeColor] intensity:0.5];
}

@end
