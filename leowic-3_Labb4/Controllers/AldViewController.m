//
//  AldViewController.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 12/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AldViewController.h"
#import "AldCardView.h"
#import "AldCardSideView.h"

@interface AldViewController()

@property(nonatomic, strong) NSMutableArray *cards;

@end

@implementation AldViewController

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    recognizer.numberOfTapsRequired = 2;
    recognizer.numberOfTouchesRequired = 1;
    [_scrollView addGestureRecognizer:recognizer];
    
    [self configure];
}

-(UIView *) viewForZoomingInScrollView: (UIScrollView *)scrollView
{
    return [scrollView.subviews objectAtIndex:0];
}

-(void) configure
{
    _model = [[AldGameModel alloc] initWithVariants:9];
    _cards = [[NSMutableArray alloc] initWithCapacity:9];
    
    CGRect mapFrame = CGRectMake(0, 0, _model.mapSize * [AldCardView cardSquareSize], _model.mapSize * [AldCardView cardSquareSize]);
    UIView *mapView = [[UIView alloc] initWithFrame:mapFrame];
    
    for (int i = 0, x = 0, y = 0; i < _model.mapSize * _model.mapSize; i += 1) {
        
        // Create a card with a front and back side
        AldCardView *card = [[AldCardView alloc] initWithIndex:i];
        
        // Create a rotation view wherein the cards will rotate. This is necessary because the UIView
        // transition kit rotates the parent view as well.
        CGRect frame = CGRectMake(x, y, card.frontView.frame.size.width, card.frontView.frame.size.height);
        UIView *rotationView = [[UIView alloc] initWithFrame:frame];
        
        // Store the card so that it will be retained, and add the card's front view to the rotation view, which
        // in turn is passed along to the UIScrollView.
        [_cards addObject:card];
        [rotationView addSubview:card.frontView];
        [mapView addSubview:rotationView];
        
        // Debug information
#if DEBUG
        NSLog(@"%d: %d %d",  i, x, y);
#endif
        
        // Increment X and Y. The map being a perfect square, Y is incremented with even division.
        if (i > 0 && (i + 1) % _model.mapSize == 0) {
            x = 0;
            y += [AldCardView cardSquareSize];
        } else {
            x += [AldCardView cardSquareSize];
        }
    }
    
    // Configure the scroll view
    _scrollView.canCancelContentTouches = YES;
    _scrollView.autoresizesSubviews = NO;
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_scrollView addSubview:mapView];
    
    _scrollView.contentSize = mapFrame.size;
}

-(void) viewDidAppear: (BOOL)animated
{
    CGRect scrollViewFrame = _scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    // Calculate the content size for the scroll view
    _scrollView.maximumZoomScale = 1;
    _scrollView.minimumZoomScale = minScale;
}

-(void) handleDoubleTap: (UITapGestureRecognizer *)sender
{
    if (sender.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    CGPoint coords = [sender locationInView:_scrollView];
    UIView *view = [_scrollView hitTest:coords withEvent:nil];
    
    if (view != nil) {

        AldCardView *card = [(AldCardSideView *)view belongsToCard];
        
        [UIView transitionFromView:view
                            toView:[card oppositeView:view]
                          duration:5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:nil];
        
    }
}

@end
