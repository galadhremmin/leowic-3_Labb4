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
#import "UIView+Effects.h"

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
    
    [self effectRoundedCornersWithRadius:self.bounds.size.width * 0.05];
}

-(void) initContents
{
}

@end
