//
//  AldMainMenuViewController.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 04/12/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldMainMenuViewController.h"
#import "AldGameModel.h"
#import "AldGameViewController.h"

@interface AldMainMenuViewController ()

@property (nonatomic, strong) AldGameModel *previousGameModel;

@end

@implementation AldMainMenuViewController

-(NSIndexPath *) tableView: (UITableView *)tableView willSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    if (indexPath.row != 1) {
        return indexPath;
    }
    
    _previousGameModel = [AldGameModel modelFromDataCore];
    if (_previousGameModel == nil) {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Resume" message:@"You have finished all of your previous games already. Would you like to start a new one instead?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [view show];
        
        return nil;
    }
    
    return indexPath;
}

#pragma mark - Alert view delegation

-(void) alertView: (UIAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self performSegueWithIdentifier:@"NewGameSegue" sender:self];
    }
}

#pragma mark - Navigation

-(BOOL) shouldPerformSegueWithIdentifier: (NSString *)identifier sender: (id)sender
{
    if ([identifier isEqualToString:@"ResumeGameSegue"] && _previousGameModel == nil) {
        return NO;
    }
    
    return YES;
}

// In a story board-based application, you will often want to do a little preparation before navigation
-(void) prepareForSegue: (UIStoryboardSegue *)segue sender: (id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ResumeGameSegue"]) {
        AldGameViewController *gameController = (AldGameViewController *)[segue destinationViewController];
        
        gameController.model = _previousGameModel;
        _previousGameModel = nil;
    }
}

@end
