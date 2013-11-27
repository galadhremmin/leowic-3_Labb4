//
//  AldPortraitSelectionViewController.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 26/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldPortraitSelectionViewController.h"
#import "AldViewController.h"

@interface AldPortraitSelectionViewController ()

@property(nonatomic, strong) NSMutableArray *portraitCells;

@end

@implementation AldPortraitSelectionViewController

-(void) viewDidAppear: (BOOL)animated
{
    _portraitCells = [[NSMutableArray alloc] initWithCapacity:_numberOfPlayers];
}

-(void) viewDidDisappear: (BOOL)animated
{
    _portraitCells = nil;
}

#pragma mark - Table view data source

-(void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    // Deselect the cell
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // The portraits are located in the first section. All other sections maintain
    // regular behaviour patterns.
    if (indexPath.section > 0) {
        return;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell != nil) {
        
        if ([_portraitCells containsObject:cell]) {
            // A portrait tapped on is already chosen, so deselect it.
            [_portraitCells removeObject:cell];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        } else {
            // The maximum number of portraits have been selected, so deselect the portrait
            // last tapped on, so the one recently tapped upon can move in to replace it.
            if (_numberOfPlayers == _portraitCells.count) {
                UITableViewCell *cell = [_portraitCells objectAtIndex:_portraitCells.count - 1];
                cell.accessoryType = UITableViewCellAccessoryNone;
                [_portraitCells removeObject:cell];
            }
            
            // Choose the portrait tapped upon.
            [_portraitCells addObject:cell];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
    AldViewController *destinationController = (AldViewController *)segue.destinationViewController;
    NSMutableArray *portraits = [[NSMutableArray alloc] initWithCapacity:_numberOfPlayers];
    
    for (UITableViewCell *cell in _portraitCells) {
        [portraits addObject:cell.imageView.image];
    }
    
    [destinationController createPlayersWithPortraits: portraits];
}

@end
