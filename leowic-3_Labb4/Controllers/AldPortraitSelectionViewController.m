//
//  AldPortraitSelectionViewController.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 26/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldPortraitSelectionViewController.h"
#import "AldGameViewController.h"
#import "AldPortraitViewCell.h"
#import "UIImage+BundleExtensions.h"
#import "UIView+Effects.h"

@interface AldPortraitSelectionViewController ()

@property(nonatomic, strong) NSMutableArray *portraitCells;

@end

@implementation AldPortraitSelectionViewController

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *recogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    recogniser.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:recogniser];
}

-(void) viewDidAppear: (BOOL)animated
{
    _portraitCells = [[NSMutableArray alloc] initWithCapacity:_numberOfPlayers];
}

-(void) viewDidDisappear: (BOOL)animated
{
    _portraitCells = nil;
}

#pragma mark - Collection view cell

-(NSInteger) collectionView: (UICollectionView *)collectionView numberOfItemsInSection: (NSInteger)section
{
    return 9;
}

-(NSInteger) numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *) collectionView: (UICollectionView *)collectionView cellForItemAtIndexPath: (NSIndexPath *)indexPath
{
    AldPortraitViewCell *cell = (AldPortraitViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PortraitCell" forIndexPath:indexPath];
    
    cell.portraitImagePath = [NSString stringWithFormat:@"elf%d.png", indexPath.row + 1];
    [cell loadPortraitImage];
    
    return cell;
}

-(void) handleSingleTap: (UITapGestureRecognizer *)sender
{
    CGPoint coords = [sender locationInView:self.view];
    // Acquire the superview fo the view the user tapped upon. Apparently, the UICollectionViewCell
    // hit test results in an UIView of unknown origin, which is a direct descendant to the cell.
    // For this reason, the superview is acquired, which ought to be an instance of the
    // AldPortraitViewCell class.
    UIView *view = [[self.view hitTest:coords withEvent:nil] superview];
    
    if (view == nil || ![view isKindOfClass:[AldPortraitViewCell class]]) {
        return;
    }
    
    [view effectTriggerSelection];
    
    if (view.effectSelected) {
        
        if (_portraitCells.count >= _numberOfPlayers) {
            // If the  maximum number of players already have been selected, deselect the
            // oldest one, and replace it with the new.
            AldPortraitViewCell *previousView = [_portraitCells objectAtIndex:0];
            [previousView effectTriggerSelection];
            [_portraitCells removeObject:previousView];
            previousView = nil;
        }
        
        [_portraitCells addObject:view];
    } else {
        [_portraitCells removeObject:view];
    }
}

#pragma mark - Navigation

-(BOOL) shouldPerformSegueWithIdentifier: (NSString *)identifier sender: (id)sender
{
    BOOL ok = YES;
    if (_portraitCells.count != _numberOfPlayers) {
        ok = NO;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Choose a portrait!" message:[NSString stringWithFormat:@"You must choose a portrait for %d player(s) before moving on.", _numberOfPlayers] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    return ok;
}

-(void) prepareForSegue: (UIStoryboardSegue *)segue sender: (id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    AldGameViewController *destinationController = (AldGameViewController *)segue.destinationViewController;
    NSMutableArray *portraits = [[NSMutableArray alloc] initWithCapacity:_numberOfPlayers];
    
    for (AldPortraitViewCell *cell in _portraitCells) {
        [portraits addObject:cell.portraitImagePath];
    }
    
    destinationController.playerPortraitPaths = portraits;
}

@end
