//
//  AldBackCardView.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 17/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldCardBackView.h"
#import "AldCardData.h"
#import "UIImage+BundleExtensions.h"

@implementation AldCardBackView

-(void) initContents
{
    // Apply the background texture to the image. As this class is a generalization of
    // UIImageView, the image property is readily accessible.
    if (self.image == nil) {
        self.image = [UIImage imageFromBundle:@"back-texture.jpg"];
    }

    // Initialize a label for the tengwar symbol as well as its associated description label.
    // The tengwar label will take up to 60 % of the available space. The details label covers
    // what's rest.
    //
    if (_detailsTitleLabel != nil) {
        return;
    }
    
    UILabel *tengwarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 0.6)];
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, tengwarLabel.frame.size.height, self.frame.size.width, self.frame.size.height - tengwarLabel.frame.size.height)];
    
    // Gather the font from the library. This font is defined in the application bundle
    // configuration parameter "Fonts provided by application"
    UIFont *tengwarFont = [UIFont fontWithName:@"Tengwar Parmaite" size:150.0];
    UIColor *fontColor = [UIColor colorWithRed:39/255.0 green:33/255.0 blue:0/255.0 alpha:1];
    
    // Configure the labels and make sure to disable the auto resizing feature in iOS7
    //
    tengwarLabel.textAlignment                 = NSTextAlignmentCenter;
    tengwarLabel.textColor                     = fontColor;
    tengwarLabel.font                          = tengwarFont;
    tengwarLabel.autoresizingMask              = UIViewAutoresizingNone;
    
    descriptionLabel.textAlignment             = NSTextAlignmentCenter;
    descriptionLabel.textColor                 = fontColor;
    descriptionLabel.font                      = [UIFont fontWithName:@"Marion" size:80];
    descriptionLabel.autoresizingMask          = UIViewAutoresizingNone;
    descriptionLabel.adjustsFontSizeToFitWidth = YES;
    
    // Add the labels to the superview and associate the two labels with their respective
    // (weak) properties.
    [self addSubview:tengwarLabel];
    [self addSubview:descriptionLabel];
    
    _detailsTitleLabel       = tengwarLabel;
    _detailsDescriptionLabel = descriptionLabel;
}
@end
