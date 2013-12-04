//
//  AldViewController.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 12/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "AldTimingConstants.h"
#import "UIView+Effects.h"
#import "UIImage+BundleExtensions.h"
#import "AldGameViewController.h"
#import "AldCardBackView.h"
#import "AldCardData.h"
#import "AldPlayerWrapper.h"

@interface AldGameViewController()

@property(nonatomic, strong) NSMutableArray *cards;
@property(nonatomic, strong) NSMutableArray *selectedCards;

@end

@implementation AldGameViewController

#pragma mark - View life-cycle delegation

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    // Attach a tap gesture recogniser to the UIScrollView. It'll be used to recognise user
    // interaction for the cards.
    //
    UITapGestureRecognizer *recogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCardTap:)];
    recogniser.numberOfTapsRequired = 1;
    recogniser.numberOfTouchesRequired = 1;
    [_scrollView addGestureRecognizer:recogniser];
    
    [self configure];
}

-(void) viewWillDisappear: (BOOL)animated
{
    [self unload];
}

-(void) didReceiveMemoryWarning
{
    [self unload];
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

#pragma mark - Scroll view delegation

-(UIView *) viewForZoomingInScrollView: (UIScrollView *)scrollView
{
    // Always presume that it is the first subview within the scroll view which is to
    // be affected by zooming.
    //
    return [scrollView.subviews objectAtIndex:0];
}

#pragma mark - Game graphics core

-(void) configure
{
    if (_model == nil) {
        
        if (_playerPortraitPaths == nil || _playerPortraitPaths.count < 1) {
            [NSException raise:@"Invalid number of portraits." format:@"%d is not a valid number of portraits (i.e. players)", _players.count];
        }
        
        _model = [[AldGameModel alloc] initWithNumberOfCards:16 playersWithPortraits:_playerPortraitPaths];
        
        // deallocate the portrait paths, as they are no longer required.
        _playerPortraitPaths = nil;
    }
    
    // The AldPlayerWrapper class for AldPlayerData adds informatin the views needs to visualize
    // the players. So create an instance of this class per active player.
    NSMutableArray *players = [[NSMutableArray alloc] initWithCapacity:_model.players.count];
    for (AldPlayerData *playerData in _model.players) {
        AldPlayerWrapper *wrapper = [[AldPlayerWrapper alloc] initWithID:playerData.ID portraitPath:playerData.portraitPath];
        
        [players addObject:wrapper];
    }
    _players = players;
    
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
    
    // Lay out the memory cards on the table.
    //
    _cards = [[NSMutableArray alloc] initWithCapacity:numberOfCards];
    for (NSUInteger i = 0, x = 0, y = 0; i < numberOfCards; i += 1) {
        
        CGRect frame = CGRectMake(0, 0, cardSize, cardSize);
        
        // Create a card with a front and back side
        AldCardSidesViewContainer *card = [[AldCardSidesViewContainer alloc] initWithFrame:frame index:i];
        
        // Hide the front of the card if it's already been collected. This can happen when restoring
        // an older game.
        card.frontView.hidden = [_model dataForIndex:i].collected;
        
        // Create a rotation view wherein the cards will rotate. This is necessary because the UIView
        // transition kit rotates the parent view as well.
        frame.origin.x = x;
        frame.origin.y = y;
        
        UIView *rotationView = [[UIView alloc] initWithFrame:frame];
        
        // Rotate the cards randomly, giving the impression of a proper board
        int angle = (int) arc4random_uniform(8) - 4; // -4 to +4
        [UIView view:rotationView rotateByDegrees:angle];
        
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
    
    // Lay out the player portraits
    //
    for (NSUInteger i = 0; i < 2; i += 1) {
        UIImageView *portraitView = [self valueForKeyPath:[NSString stringWithFormat:@"player%dView", i + 1]];
        UIImageView *frameView = [self valueForKeyPath:[NSString stringWithFormat:@"player%dFrameView", i + 1]];
        
        portraitView.hidden = frameView.hidden = i >= _players.count;
        if (portraitView.hidden) {
            continue;
        }

        AldPlayerWrapper *wrapper = [_players objectAtIndex:i];
        portraitView.image = [UIImage imageFromBundle:wrapper.portraitPath];
        wrapper.portraitView = portraitView;
        
        [UIView view:frameView shadowWithOffset:CGSizeMake(3, 3) radius:3];
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
    [_scrollView addSubview:mapView];
}

-(void) unload
{
    _selectedCards = nil;
    _players = nil;
    _cards   = nil;
    
    [_model persist];
    _model = nil;
    
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
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
    
    // Center the wisp on the current player
    AldPlayerWrapper *currentPlayer = (AldPlayerWrapper *) [_players objectAtIndex:[_model currentPlayer].ID - 1];
    [_willOWisp setCenter:currentPlayer.portraitView.center];
    
    NSLog(@"Scroll view zoom levels: %f --> %f", _scrollView.minimumZoomScale, _scrollView.maximumZoomScale);
    NSLog(@"Scroll view frame: (%f, %f)", _scrollView.frame.size.width, _scrollView.frame.size.height);
    NSLog(@"Content size: (%f, %f)", _scrollView.contentSize.width, _scrollView.contentSize.height);
}


-(void) flipCardsToBack
{
    NSUInteger indexes[_selectedCards.count];
    for (NSUInteger i = 0; i < _selectedCards.count; i += 1) {
        AldCardSideView *card = [_selectedCards objectAtIndex:i];
        indexes[i] = card.associatedCard.index;
    }

    __block BOOL matches = [_model flipCards:indexes];
    __block NSObject *controller = self;
    
    [self performSelector:@selector(playerMoveFeedback:) withObject:[NSNumber numberWithBool:matches] afterDelay:kAldTimingSuccessFeedbackDuration];
    
    for (AldCardSideView *cardSideView in _selectedCards) {
        // Deselect the card view as the animation will ensue
        [cardSideView effectDeselect];
        
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
                [controller performSelector:@selector(flipCardToFront:) withObject:destinationView afterDelay:kAldTimingCardViewingDuration];
            } else {
                [controller performSelector:@selector(claimCard:) withObject:destinationView afterDelay:kAldTimingCardViewingDuration];
            }
        }];
    }
}

-(void) flipCardToFront: (AldCardSideView *)sourceView
{
    // The two cards doesn't match--so flip right back.
    [sourceView.associatedCard flipFromView:sourceView configureDestinationView:nil completed:^(UIView *s, UIView* d) {
        // Free up a bit of memory by removing the label's textual content as well
        // as removing it from its superview.
        AldCardBackView *cardBackSideView = (AldCardBackView *) s;
        cardBackSideView.detailsDescriptionLabel.text = nil;
        cardBackSideView.detailsTitleLabel.text = nil;
        [cardBackSideView removeFromSuperview];
    }];
}

-(void) claimCard: (AldCardSideView *)sourceView
{
    __block UIView *view = sourceView;
    __block CGRect  originalFrame = sourceView.frame;
    
    [UIView animateWithDuration:kAldCardRemovalEffectDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // Slowly, let the card fade out
        view.layer.opacity = 0;
        
        // Rotate the card in a flash 3D effect, while also scaling it down.
        CATransform3D rotation3D = CATransform3DIdentity;
        rotation3D.m34 = 1.0 / 500;
        rotation3D = CATransform3DRotate(rotation3D, M_PI, 1.0f, 0.0f, 0.0f);
        rotation3D = CATransform3DScale(rotation3D, 0.1, 0.1, 0.1);
        view.layer.transform = rotation3D;
        
    } completion:^(BOOL finished) {
        view.frame = originalFrame;
        view.hidden = YES;
    }];
}

-(void) playerMoveFeedback: (NSNumber *)matches
{
    AldPlayerData *currentPlayer = [_model currentPlayer];
    AldPlayerWrapper *portrait = [_players objectAtIndex:currentPlayer.ID - 1];
    
    [_willOWisp moveToView:portrait.portraitView];
    
    @synchronized(_selectedCards) {
        [_selectedCards removeAllObjects];
    }
}

#pragma mark - Card tapping events

-(void) handleCardTap: (UITapGestureRecognizer *)sender
{
    // You can't flip another set of card if cards are already flipping
    if ([_selectedCards count] >= kAldNumberOfSimultaneousCardSelections) {
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
        _selectedCards = [[NSMutableArray alloc] initWithCapacity:kAldNumberOfSimultaneousCardSelections];
    }
    
    @synchronized(_selectedCards) {
        if ([_selectedCards count] < kAldNumberOfSimultaneousCardSelections) {
            if ([_selectedCards containsObject:cardView]) {
                // The card already exists in the collection - deselect it
                [cardView effectDeselect];
                [_selectedCards removeObject:cardView];
            } else {
                // The card doesn't exist in the collection with selected cards. Select it.
                [cardView effectSelect];
                [_selectedCards addObject:cardView];
            }
        }
    }
    
    if ([_selectedCards count] >= kAldNumberOfSimultaneousCardSelections) {
        // View the cards for a while, then flip them around
        [self performSelector:@selector(flipCardsToBack) withObject:nil afterDelay:kAldTimingCardBeforeFlippingDuration];
    }
}

@end
