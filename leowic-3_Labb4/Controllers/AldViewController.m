//
//  AldViewController.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 12/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "UIImage+BundleExtensions.h"
#import "AldViewController.h"
#import "AldCardBackView.h"
#import "AldCardData.h"

#define kNumberOfSimultaneousCardSelections (2)

@interface AldViewController()

@property(nonatomic, strong) NSMutableArray *cards;
@property(nonatomic, strong) NSMutableArray *selectedCards;

@end

@implementation AldViewController

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    // Create the scroll view programmatically as iOS7 storyboard layout configuration for the
    // UIScrollView doesn't mix very well with subviews created programmatically. See reference:
    // https://developer.apple.com/library/ios/technotes/tn2154/_index.html
    //
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:view];
    _scrollView = view;
    
    // Attach a tap gesture recogniser to the UIScrollView. It'll be used to recognise user
    // interaction for the cards.
    //
    UITapGestureRecognizer *recogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCardTap:)];
    recogniser.numberOfTapsRequired = 1;
    recogniser.numberOfTouchesRequired = 1;
    [_scrollView addGestureRecognizer:recogniser];
    
    [self configure];
}

-(void) viewDidLayoutSubviews
{
    // Resize the scroll view by assigning its frame to the superview's bounds.
    // Note that the superview's frame apparently isn't affected by the rotation,
    // thus the bounds is used instead.
    //
    _scrollView.frame = self.view.bounds;
    
    // Recalculate the zoom scale and more.
    [self calculateScale:NO];
}

-(UIView *) viewForZoomingInScrollView: (UIScrollView *)scrollView
{
    // Always presume that it is the first subview within the scroll view which is to
    // be affected by zooming.
    //
    return [scrollView.subviews objectAtIndex:0];
}

-(void) configure
{
    _model = [[AldGameModel alloc] initWithNumberOfCards:16 players:_players.count];
    
    // Map size (in number of cards per row)
    int cardsPerRow = _model.cardsPerRow;
    
    // Number of cards in total (cardsPerRow^2)
    int numberOfCards = cardsPerRow * cardsPerRow;
    
    // Card width and height
    int cardSize = self.view.bounds.size.height * 0.8;
 
    // Padding width (5 % of card width)
    int paddingSize  = cardSize * 0.05;
    int totalPadding = paddingSize * (cardsPerRow - 1);
    
    CGRect mapFrame = CGRectMake(
                                 0, 0,
                                 cardsPerRow * cardSize + totalPadding,
                                 cardsPerRow * cardSize + totalPadding
                                 );
    
    UIView *mapView = [[UIView alloc] initWithFrame:mapFrame];
    
    _cards = [[NSMutableArray alloc] initWithCapacity:numberOfCards];
    for (int i = 0, x = 0, y = 0; i < numberOfCards; i += 1) {
        
        CGRect frame = CGRectMake(0, 0, cardSize, cardSize);
        
        // Create a card with a front and back side
        AldCardSidesViewContainer *card = [[AldCardSidesViewContainer alloc] initWithFrame:frame index:i];
        
        // Create a rotation view wherein the cards will rotate. This is necessary because the UIView
        // transition kit rotates the parent view as well.
        frame.origin.x = x;
        frame.origin.y = y;
        
        UIView *rotationView = [[UIView alloc] initWithFrame:frame];
        
        // Rotate the cards randomly, giving the impression of a proper board
        rotationView.transform = CGAffineTransformMakeRotation((arc4random() % 4)*M_PI/180.0);
        
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
            y += cardSize + paddingSize;
        } else {
            x += cardSize + paddingSize;
        }
    }
    
    // Configure the subview for the scroll view, disabling auto resizing
    mapView.autoresizingMask = UIViewAutoresizingNone;
    mapView.autoresizesSubviews = NO;
    
    // Configure the scroll view, disabling auto resizing and other features
    // which might be enabled by default.
    _scrollView.autoresizesSubviews = NO;
    _scrollView.clipsToBounds       = NO;
    _scrollView.pagingEnabled       = NO;
    _scrollView.delegate            = self;
    
    // Remove all other subviews and add the map view to the scroll view.
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_scrollView addSubview:mapView];
}

-(void) calculateScale: (BOOL)animated
{
    // Now that all views (hopefully) are aware of their final frame, assign the content
    // size to the scroll view and make sure to zero the inserts.
    //
    UIView *view = (UIView *)[_scrollView.subviews objectAtIndex:0];
    _scrollView.contentSize  = view.bounds.size;
    _scrollView.contentInset = UIEdgeInsetsZero;
    
    // Set the zoom scale for the card collection.
    //
    _scrollView.maximumZoomScale = 1;
    switch ([[UIDevice currentDevice] orientation]) {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            // Minimum zoom scale based on the width, i.e. it should be possible to see all cards
            // on a horizontal level.
            _scrollView.minimumZoomScale = _scrollView.frame.size.width / _scrollView.contentSize.width;
            break;
            
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        default:
            // In portrait mode, the zoom scale is based on the height, i.e. it should be possible
            // to see all cards on a vertical level.
            _scrollView.minimumZoomScale = _scrollView.frame.size.height / _scrollView.contentSize.height;
            break;
    }
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:animated];
    
    NSLog(@"Scroll view zoom levels: %f --> %f", _scrollView.minimumZoomScale, _scrollView.maximumZoomScale);
    NSLog(@"Scroll view frame: (%f, %f)", _scrollView.frame.size.width, _scrollView.frame.size.height);
    NSLog(@"Content size: (%f, %f)", _scrollView.contentSize.width, _scrollView.contentSize.height);
}

-(void) handleCardTap: (UITapGestureRecognizer *)sender
{
    // You can't flip another set of card if cards are already flipping
    if ([_selectedCards count] >= kNumberOfSimultaneousCardSelections) {
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
    
    // Allocate a mutable array with the capacity of two cards simultaneously selected.
    if (_selectedCards == nil) {
        _selectedCards = [[NSMutableArray alloc] initWithCapacity:2];
    }
    
    @synchronized(_selectedCards) {
        if ([_selectedCards count] < kNumberOfSimultaneousCardSelections) {
            if ([_selectedCards containsObject:cardView]) {
                // The card already exists in the collection - deselect it
                [cardView deselect];
                [_selectedCards removeObject:cardView];
            } else {
                // The card doesn't exist in the collection with selected cards. Select it.
                [cardView select];
                [_selectedCards addObject:cardView];
            }
        }
    }
    
    if ([_selectedCards count] >= kNumberOfSimultaneousCardSelections) {
        // Flip the card after two seconds of flashing
        [self performSelector:@selector(flipCardsToBack) withObject:nil afterDelay:2];
    }
}

-(void) flipCardsToBack
{
    __block BOOL matches = [self selectedCardsVariantsMatch];
    __block NSObject *controller = self;
    
    for (AldCardSideView *cardSideView in _selectedCards) {
        // Deselect the card view as the animation will ensue
        [cardSideView deselect];
        
        __block AldCardSidesViewContainer* card = cardSideView.associatedCard;
        
        [card flipFromView:cardSideView configureDestinationView:^(UIView *view) {
            // Skip the front of the card as it has nothing to configure
            if (![view isKindOfClass:[AldCardBackView class]]) {
                return;
            }
            
            // Populate the back of the card with its variation
            AldCardBackView *cardBackSideView = (AldCardBackView *) view;
            int index = cardBackSideView.associatedCard.index;
            
            // Temporary: assign the variation as the textual content for thed details label
            AldCardData *data = [_model dataForIndex:index];
            cardBackSideView.detailsTitleLabel.text = data.title;
            cardBackSideView.detailsDescriptionLabel.text = data.description;
            
        } completed:^(UIView *sourceView, UIView* destinationView) {
            // Remove the source view from its superview.
            [sourceView removeFromSuperview];
            
            if (!matches) {
                // Sleep for one second , giving the player a chance to memorize the cards.
                [controller performSelector:@selector(flipCardsToFront:) withObject:destinationView afterDelay:1];
            } else {
                @synchronized(_selectedCards) {
                    [_selectedCards removeAllObjects];
                }
            }
        }];
    }
}

-(void) flipCardsToFront: (AldCardSideView *)sourceView
{
    // The two cards doesn't match--so flip right back.
    [sourceView.associatedCard flipFromView:sourceView configureDestinationView:nil completed:^(UIView *s, UIView* d) {
        // Free up a bit of memory by removing the label's textual content as well
        // as removing it from its superview.
        AldCardBackView *cardBackSideView = (AldCardBackView *) s;
        cardBackSideView.detailsDescriptionLabel.text = nil;
        cardBackSideView.detailsTitleLabel.text = nil;
        [cardBackSideView removeFromSuperview];
        
        @synchronized(_selectedCards) {
            [_selectedCards removeAllObjects];
        }
    }];
}

-(BOOL) selectedCardsVariantsMatch
{
    NSUInteger variant = 0, i = 0;
    
    for (; i < [_selectedCards count]; i += 1) {
        AldCardSideView *cardSideView = (AldCardSideView *)[_selectedCards objectAtIndex:i];
        AldCardData *currentVariant = [_model dataForIndex:cardSideView.associatedCard.index];
        
        if (i < 1) {
            // First iteration - assign to the variant variable
            variant = currentVariant.hash;
        } else if (variant != currentVariant.hash) {
            // All subsequent iterations - compare the variant with the initial variant. If it
            // isn't the same, the cards aren't the same.
            return NO;
        }
    }
    
    // Two cards are expected
    return i == kNumberOfSimultaneousCardSelections;
}

@end
