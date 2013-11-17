//
//  AldCardView.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 17/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldCardFrontView.h"
#import "UIImage+BundleExtensions.h"

@implementation AldCardFrontView

-(void) initContents
{
    UIImage *image = [UIImage imageFromBundle:@"front-texture.jpg"];
    self.image = image;
}

@end
