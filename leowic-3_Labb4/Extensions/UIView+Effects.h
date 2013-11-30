//
//  UIView+Effects.h
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 30/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Effects)

+(void) view: (UIView *)aView roundedCornersWithRadius: (CGFloat)r;
+(void) view: (UIView *)aView shadowWithOffset: (CGSize)offset radius: (CGFloat)radius;
+(void) view: (UIView *)aView rotateByDegrees: (CGFloat)degrees;

-(void) effectRoundedCornersWithRadius: (CGFloat)r;
-(void) effectShadowWithOffset: (CGSize)offset radius: (CGFloat)radius;
-(void) effectRotateByDegrees: (CGFloat)degrees;

-(void) effectSelect;
-(void) effectDeselect;
-(void) effectTriggerSelection;

@property(readonly, nonatomic) BOOL effectSelected;

@end
