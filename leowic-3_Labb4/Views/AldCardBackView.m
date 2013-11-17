//
//  AldBackCardView.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 17/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldCardBackView.h"
#import "UIImage+BundleExtensions.h"

@implementation AldCardBackView

-(void) initContents
{
    UIImage *image = [UIImage imageFromBundle:@"back-texture.jpg"];
    self.image = image;
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
    label.text = [NSString stringWithFormat:@"%d", self.parentCard.index];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    [self addSubview:label];
    self.detailsTitleLabel = label;
}
@end
