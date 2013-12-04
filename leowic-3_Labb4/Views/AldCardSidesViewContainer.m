//
//  AldCardViewCollection.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 17/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldCardSidesViewContainer.h"
#import "AldCardFrontView.h"
#import "AldCardBackView.h"
#import "AldConstants.h"

@interface AldCardSidesViewContainer()

@property(nonatomic, strong) UIView *frontView;
@property(nonatomic, strong) UIView *backView;

@end

@implementation AldCardSidesViewContainer

-(id) initWithFrame: (CGRect)frame index: (NSUInteger)index
{
    self = [super init];
    if (self) {
        _index = index;
        // The card's front side.
        _frontView = [[AldCardFrontView alloc] initWithFrame:frame associatedWithCard:self];
        // The card's rear side.
        _backView  = [[AldCardBackView  alloc] initWithFrame:frame associatedWithCard:self];
    }
    
    return self;
}

-(UIView*) oppositeView: (UIView *)view
{
    // Acquire the opposite side for the specified view.
    if (view == _backView) {
        return _frontView;
    }
    
    if (view == _frontView) {
        return _backView;
    }
    
    return nil;
}

-(void) flipFromView: (UIView *)view configureDestinationView: (void (^)(UIView *destinationView))configureDestinationViewHandler completed: (void (^)(UIView *previousView, UIView *destinationView))completedHandler
{
    __block UIView *sourceView = view;
    __block UIView *oppositeView = [self oppositeView:view];
    
    if (configureDestinationViewHandler != nil) {
        // Execute the configuration block to prepare the opposite view. This block can trigger
        // loading functions such as acquiring data from web services.
        configureDestinationViewHandler(oppositeView);
    }
    
    // Transition from the source view to the destination view. Execute the completion block
    // upon finishing the transition.
    [UIView transitionFromView:sourceView
                        toView:oppositeView
                      duration:kAldTimingCardFlippingDuration
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished) {
                        if (completedHandler != nil) {
                            completedHandler(sourceView, oppositeView);
                        }
                    }];
}

@end
