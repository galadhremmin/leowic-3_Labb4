//
//  AldWillOWispView.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 30/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldWillOWispView.h"
#import "AldTimingConstants.h"

@implementation AldWillOWispView

-(id) initWithCoder: (NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Configure the will o wisp to rotate forever
        //
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = [NSNumber numberWithFloat:0.0f];
        animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
        animation.duration = 25.0f;
        animation.repeatCount = HUGE_VAL;
        [self.layer addAnimation:animation forKey:@"RotationAnimation"];
    }
    return self;
}

-(void) moveToView: (UIView *)destinationView
{
    __block CGPoint center = destinationView.center;
    __block UIView *wisp = self;
    
    [UIView animateWithDuration:kAldTimingWillOWispMovementDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [wisp setCenter:center];
    } completion:nil];
}

@end
