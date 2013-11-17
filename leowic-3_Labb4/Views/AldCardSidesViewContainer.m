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

@interface AldCardSidesViewContainer()

@property(nonatomic, strong) UIView *frontView;
@property(nonatomic, strong) UIView *backView;

@end

@implementation AldCardSidesViewContainer

+(NSUInteger) cardSquareSize
{
    return 200;
}

-(id) initWithIndex: (NSUInteger)index
{
    self = [super init];
    if (self) {
        CGPoint origin = CGPointMake(0, 0);
        
        _index = index;
        _frontView = [[AldCardFrontView alloc] initWithOrigin:origin associatedWithCard:self];
        _backView  = [[AldCardBackView  alloc] initWithOrigin:origin associatedWithCard:self];
    }
    
    return self;
}

-(UIView*) oppositeView: (UIView *)view
{
    if (view == _backView) {
        return _frontView;
    }
    
    if (view == _frontView) {
        return _backView;
    }
    
    return nil;
}

-(void)    flipFromView: (UIView *)view configureDestinationView: (void (^)(UIView *destinationView))configureDestinationViewHandler completed: (void (^)(UIView *previousView, UIView *destinationView))completedHandler
{
    __weak UIView *sourceView = view;
    __weak UIView *oppositeView = [self oppositeView:view];
    
    if (configureDestinationViewHandler != nil) {
        configureDestinationViewHandler(oppositeView);
    }
    
    [UIView transitionFromView:sourceView
                        toView:oppositeView
                      duration:2
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished) {
                        if (completedHandler != nil) {
                            completedHandler(sourceView, oppositeView);
                        }
                    }];
}

@end
