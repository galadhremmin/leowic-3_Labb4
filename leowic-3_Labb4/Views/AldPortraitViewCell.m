//
//  AldPortraitViewCell.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 30/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldPortraitViewCell.h"
#import "UIImage+BundleExtensions.h"
#import "UIView+Effects.h"

@implementation AldPortraitViewCell

-(id) initWithCoder: (NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIImage *backgroundImage = [UIImage imageFromBundle:@"back-texture.jpg"];
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
        self.backgroundView = backgroundView;
        
        CGFloat radius = self.bounds.size.width*0.05;
        [self effectRoundedCornersWithRadius:radius];
        
        int angle = (int) arc4random_uniform(4) - 2; // -2 to +2
        [UIView view:backgroundView rotateByDegrees:angle];
        [UIView view:_imageView rotateByDegrees:angle];
    }
    return self;
}

-(void) loadPortraitImage
{
    UIImage *backgroundImage = [UIImage imageFromBundle:_portraitImagePath];
    self.imageView.image = backgroundImage;
}

@end
