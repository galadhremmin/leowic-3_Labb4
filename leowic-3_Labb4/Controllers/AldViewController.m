//
//  AldViewController.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 12/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AldViewController.h"
#import "AldCardBackView.h"

@interface AldViewController()

@property(nonatomic, strong) NSMutableArray *cards;
@property(nonatomic)         BOOL            isFlipping;

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
    _model = [[AldGameModel alloc] initWithVariants:16];
    
    // Map size (in number of cards per row)
    int cardsPerRow = _model.mapSize;
    
    // Number of cards in total (cardsPerRow^2)
    int numberOfCards = cardsPerRow * cardsPerRow;
    
    // Card width and height
    int cardSize = [AldCardSideViewContainer cardSquareSize];
 
    // Padding width (5 % of card width)
    int paddingSize = cardSize * 0.05;
    
    CGRect mapFrame = CGRectMake(
                                 0, 0,
                                 cardsPerRow * cardSize + (paddingSize * (cardsPerRow - 1)),
                                 cardsPerRow * cardSize + (paddingSize * (cardsPerRow - 1))
                                 );
    
    UIView *mapView = [[UIView alloc] initWithFrame:mapFrame];
    
    _cards = [[NSMutableArray alloc] initWithCapacity:numberOfCards];
    for (int i = 0, x = 0, y = 0; i < numberOfCards; i += 1) {
        
        // Create a card with a front and back side
        AldCardSideViewContainer *card = [[AldCardSideViewContainer alloc] initWithIndex:i];
        
        // Create a rotation view wherein the cards will rotate. This is necessary because the UIView
        // transition kit rotates the parent view as well.
        CGRect frame = CGRectMake(x, y, cardSize, cardSize);
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
        if (i > 0 && (i + 1) % cardsPerRow == 0) {
            x = 0;
            y += [AldCardSideViewContainer cardSquareSize] + paddingSize;
        } else {
            x += [AldCardSideViewContainer cardSquareSize] + paddingSize;
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
    // You can't flip another set of card if cards are already flipping
    if (_isFlipping == YES) {
        return;
    }
    
    if (sender.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    // Fetch the subview (to the UIScrollView) at the coordinates where the client double tapped
    CGPoint coords = [sender locationInView:_scrollView];
    UIView *view = [_scrollView hitTest:coords withEvent:nil];
    
    if (view == nil || ![view isKindOfClass:[AldCardSideView class]]) {
        return;
    }
    
    AldCardSideView *cardView = (AldCardSideView *)view;
    
    // Save the selection of the first card
    if (_selectedCardView == nil || cardView == _selectedCardView) {
        _selectedCardView = cardView;
        return;
    }
    
    // A card has already been selected, so move on and flip both
    NSArray *cards = @[_selectedCardView, cardView];
    
    BOOL matches = [_model variationForIndex:_selectedCardView.parentCard.index] == [_model variationForIndex:cardView.parentCard.index];
    
    for (AldCardSideView *cardView in cards) {
        __weak AldCardSideViewContainer* card = cardView.parentCard;
        
        [card flipFromView:cardView configureDestinationView:^(UIView *view) {
            // Skip the front of the card as it has nothing to configure
            if (![view isKindOfClass:[AldCardBackView class]]) {
                return;
            }
            
            // Populate the back of the card with its variation
            AldCardBackView *cardView = (AldCardBackView *) view;
            int index = cardView.parentCard.index;
            
            // Temporary: assign the variation as the textual content for thed details label
            NSString *title = [NSString stringWithFormat:@"%d", [_model variationForIndex:index]];
            cardView.detailsTitleLabel.text = title;
        } completed:^(UIView *sourceView, UIView* destinationView) {
            if (!matches) {
                // The two cards doesn't match--so flip right back.
                [card flipFromView:destinationView configureDestinationView:nil completed:^(UIView *sourceView, UIView* destinationView) {
                    _isFlipping = NO;
                }];
            } else {
                _isFlipping = NO;
            }
        }];
    }
    
    _selectedCardView = nil;
    _isFlipping = YES;
}

@end
