//
//  UIView+Effects.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 30/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "UIView+Effects.h"
#import "UIView+Glow.h"
#import <objc/runtime.h>

@implementation UIView (Corners)

+(void) view: (UIView *)aView roundedCornersWithRadius: (CGFloat)r
{
    // round the corners with a corner radius equivalent to 5 % of the square's width
    // by creating a bezier path as an alpha mask.
    if (r < 1) {
        aView.layer.mask = nil;
    }
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:aView.bounds
                                           byRoundingCorners:UIRectCornerAllCorners
                                                 cornerRadii:CGSizeMake(r, r)].CGPath;
    
    aView.layer.mask = maskLayer;
}

+(void) view: (UIView *)aView shadowWithOffset: (CGSize)offset radius: (CGFloat)radius
{
    aView.layer.shadowColor = [[UIColor blackColor] CGColor];
    aView.layer.shadowOffset = offset;
    aView.layer.shadowOpacity = 0.5f;
    aView.layer.shadowRadius = radius;
}

+(void) view: (UIView *)aView rotateByDegrees: (CGFloat)degrees
{
    aView.transform = CGAffineTransformMakeRotation(degrees*M_PI/180.0);
}

-(void) effectRoundedCornersWithRadius: (CGFloat)r
{
    [UIView view:self roundedCornersWithRadius:r];
}

-(void) effectShadowWithOffset: (CGSize)offset radius: (CGFloat)radius
{
    [UIView view:self shadowWithOffset:offset radius:radius];
}

-(void) effectRotateByDegrees: (CGFloat)degrees
{
    [UIView view:self rotateByDegrees:degrees];
}

-(void) effectSelect
{
    [self startGlowingWithColor:[UIColor colorWithRed:144/255.0 green:0 blue:32/255.0 alpha:1] intensity:0.5];
    [self setEffectSelected:YES];
}

-(void) effectDeselect
{
    [self stopGlowing];
    [self setEffectSelected:NO];
}

-(void) effectTriggerSelection
{
    if (self.effectSelected) {
        [self effectDeselect];
    } else {
        [self effectSelect];
    }
}

-(BOOL) effectSelected
{
    NSNumber *wrapper = (NSNumber *) objc_getAssociatedObject(self, "UIVIEWEffects_effectSelected");
    if (wrapper == nil) {
        return NO;
    }
    
    return [wrapper boolValue];
}

-(void) setEffectSelected: (BOOL)value
{
    NSNumber *wrapper = [NSNumber numberWithBool:value];
    objc_setAssociatedObject(self, "UIVIEWEffects_effectSelected", wrapper, OBJC_ASSOCIATION_ASSIGN);
}

@end
